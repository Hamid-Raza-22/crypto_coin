/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const { onRequest } = require("firebase-functions/v2/https");
const admin = require("firebase-admin");
const logger = require("firebase-functions/logger");
const nodemailer = require("nodemailer");
const { TronWeb } = require("tronweb");
const net = require("net");


admin.initializeApp();
const db = admin.firestore();

// Initialize TronWeb globally
const tronWeb = new TronWeb({
  fullHost: "https://api.trongrid.io",
});

const client = new net.Socket();
client.connect(465, "smtp.hostinger.com", () => {
  console.log("Connected to SMTP server");
  client.destroy();
});

client.on("error", (err) => {
  console.error("Connection failed:", err);
});
/**
 * Initializes TronWeb with a private key
 * @param {string} privateKey - The private key to initialize TronWeb
 * @return {TronWeb} - Initialized TronWeb instance
 */
function initializeTronWeb(privateKey) {
  return new TronWeb({
    fullHost: "https://api.trongrid.io",
    privateKey: privateKey,
  });
}

/**
 * Validates TRON addresses
 * @param {TronWeb} tronWeb - TronWeb instance
 * @param {string[]} addresses - Array of TRON addresses to validate
 * @throws {Error} - Throws an error if any address is invalid
 */
function validateAddresses(tronWeb, addresses) {
  addresses.forEach((addr) => {
    if (!tronWeb.isAddress(addr)) throw new Error(`Invalid address: ${addr}`);
  });
}

/**
 * Swap TRX to USDT
 */
exports.swapTrxToUsdt = onRequest(async (request, response) => {
  const { fromAddress, receiverAddress, trxAmount, privateKey, wtrx, usdt, sunswapRouter } = request.body;

  if (!fromAddress || !receiverAddress || !trxAmount || !privateKey || !wtrx || !usdt || !sunswapRouter) {
    return response.status(400).json({ error: "Missing parameters" });
  }

  const tronWeb = initializeTronWeb(privateKey);

  try {
    validateAddresses(tronWeb, [fromAddress, receiverAddress, wtrx, usdt, sunswapRouter]);

    const amountInSun = tronWeb.toSun(trxAmount);
    if (!amountInSun || isNaN(amountInSun)) {
      throw new Error("Invalid TRX amount provided.");
    }

    const path = [wtrx, usdt];

    const amountsOutResult = await tronWeb.transactionBuilder.triggerConstantContract(
      sunswapRouter,
      "getAmountsOut(uint256,address[])",
      { feeLimit: 10000000 },
      [
        { type: "uint256", value: amountInSun.toString() },
        { type: "address[]", value: path },
      ],
      tronWeb.address.toHex(fromAddress),
    );

    const hexData = amountsOutResult.constant_result[0];
    if (!hexData || hexData.length < 128) {
      throw new Error("Invalid response from getAmountsOut");
    }
    const expectedUsdt = tronWeb.toBigNumber(`0x${hexData.substring(64, 128)}`);
    const amountOutMin = expectedUsdt.multipliedBy(0.98).integerValue();

    const swapParams = [
      { type: "uint256", value: amountOutMin.toString() },
      { type: "address[]", value: path },
      { type: "address", value: receiverAddress },
      { type: "uint256", value: (Math.floor(Date.now() / 1000) + 300).toString() },
    ];

    const transaction = await tronWeb.transactionBuilder.triggerSmartContract(
      sunswapRouter,
      "swapExactETHForTokens(uint256,address[],address,uint256)",
      {
        feeLimit: 10000000,
        callValue: amountInSun,
      },
      swapParams,
      fromAddress,
    );

    const signedTx = await tronWeb.trx.sign(transaction.transaction);
    const receipt = await tronWeb.trx.sendRawTransaction(signedTx);

    response.json({
      success: true,
      txId: receipt.transaction.txID,
      amountOutMin: amountOutMin.toString(),
    });

  } catch (error) {
    console.error("Swap Failed:", error);
    response.status(500).json({
      error: "Swap execution failed",
      reason: error.message.includes("revert") ? "Insufficient liquidity or invalid path" : error.message,
    });
  }
});
/**
 * Stake TRX for Energy or Bandwidth
 */
exports.stakeTrx = onRequest(async (request, response) => {
  const { fromAddress, privateKey, resourceType, amount } = request.body;

  // Validate required parameters
  if (!fromAddress || !privateKey || !resourceType || !amount) {
    return response.status(400).json({ error: "Missing parameters" });
  }

  // Validate resource type
  if (!["ENERGY", "BANDWIDTH"].includes(resourceType)) {
    return response.status(400).json({ error: "Invalid resource type. Use 'ENERGY' or 'BANDWIDTH'" });
  }

  // Initialize TronWeb with the provided private key
  const tronWeb = initializeTronWeb(privateKey);

  try {
    // Validate the wallet address
    validateAddresses(tronWeb, [fromAddress]);

    // Convert amount to SUN (smallest unit of TRX)
    const amountInSun = tronWeb.toSun(amount);
    if (!amountInSun || isNaN(amountInSun)) {
      throw new Error("Invalid TRX amount provided.");
    }

    console.log(`Staking ${amount} TRX (${amountInSun} SUN) for ${resourceType}`);

   // Build the freeze transaction
    const transaction = await tronWeb.transactionBuilder.freezeBalanceV2(
      amountInSun, // Amount in SUN
      resourceType, // "ENERGY" or "BANDWIDTH"
      fromAddress, // Receiver address (can be the same as owner address)
    );

    console.log("Transaction built successfully:", transaction);

    // Sign the transaction
    const signedTx = await tronWeb.trx.sign(transaction);
    console.log("Transaction signed successfully:", signedTx);

    // Broadcast the transaction
    const receipt = await tronWeb.trx.sendRawTransaction(signedTx);
    console.log("Transaction broadcasted successfully:", receipt);

    // Return the transaction details
    response.json({
      success: true,
      txId: receipt.txID,
      stakedAmount: amount,
      resourceType: resourceType,
    });
  } catch (error) {
    console.error("Staking Failed:", error);
    response.status(500).json({
      error: "Staking execution failed",
      reason: error.message,
    });
  }
});

/**
 * Swap USDT to TRX
 */
exports.swapAllUsdtToTrx = onRequest(async (request, response) => {
  const { fromAddress, receiverAddress, privateKey, wtrx, usdt, sunswapRouter } = request.body;

  // Validate required parameters
  if (!fromAddress || !receiverAddress || !privateKey || !wtrx || !usdt || !sunswapRouter) {
    return response.status(400).json({ error: "Missing parameters" });
  }

  // Initialize TronWeb with the provided private key
  const tronWeb = initializeTronWeb(privateKey);

  try {
    // Validate all addresses
    validateAddresses(tronWeb, [fromAddress, receiverAddress, wtrx, usdt, sunswapRouter]);

    // Fetch the USDT balance of the wallet
    const usdtContract = await tronWeb.contract().at(usdt);
    const usdtBalanceHex = await usdtContract.balanceOf(fromAddress).call();
    const usdtBalance = tronWeb.toBigNumber(usdtBalanceHex).dividedBy(10 ** 6); // Convert to human-readable format

    if (usdtBalance.isZero()) {
      return response.status(400).json({ error: "No USDT balance available in the wallet" });
    }

    // Define the swap path (USDT -> WTRX -> TRX)
    const path = [usdt, wtrx];

    // Get the expected amount of TRX to receive
    const adjustedAmount = tronWeb.toBigNumber(usdtBalance).multipliedBy(10 ** 6); // Convert back to smallest unit
    const amountsOutResult = await tronWeb.transactionBuilder.triggerConstantContract(
      sunswapRouter,
      "getAmountsOut(uint256,address[])",
      { feeLimit: 10000000 },
      [
        { type: "uint256", value: adjustedAmount.toString() },
        { type: "address[]", value: path },
      ],
      tronWeb.address.toHex(fromAddress),
    );

    const hexData = amountsOutResult.constant_result[0];
    if (!hexData || hexData.length < 128) {
      throw new Error("Invalid response from getAmountsOut");
    }

    const expectedTrx = tronWeb.toBigNumber(`0x${hexData.substring(64, 128)}`);
    const amountOutMin = expectedTrx.multipliedBy(0.98).integerValue(); // Allow 2% slippage

    // Prepare the swap parameters
    const swapParams = [
      { type: "uint256", value: adjustedAmount.toString() },
      { type: "uint256", value: amountOutMin.toString() },
      { type: "address[]", value: path },
      { type: "address", value: receiverAddress },
      { type: "uint256", value: (Math.floor(Date.now() / 1000) + 300).toString() }, // Deadline: 5 minutes
    ];

    // Build the transaction to swap USDT for TRX
    const transaction = await tronWeb.transactionBuilder.triggerSmartContract(
      sunswapRouter,
      "swapExactTokensForETH(uint256,uint256,address[],address,uint256)",
      {
        feeLimit: 10000000,
      },
      swapParams,
      fromAddress,
    );

    // Sign and broadcast the transaction
    const signedTx = await tronWeb.trx.sign(transaction.transaction);
    const receipt = await tronWeb.trx.sendRawTransaction(signedTx);

    // Return the transaction details
    response.json({
      success: true,
      txId: receipt.transaction.txID,
      swappedUsdtAmount: usdtBalance.toString(),
      amountOutMin: amountOutMin.toString(),
    });
  } catch (error) {
    console.error("Swap Failed:", error);
    response.status(500).json({
      error: "Swap execution failed",
      reason: error.message.includes("revert") ? "Insufficient liquidity or invalid path" : error.message,
    });
  }
});
/**
 * Send TRON Transaction
 */
exports.sendTronTransaction = onRequest(async (request, response) => {
  const { fromAddress, toAddress, amount, privateKey } = request.body;

  if (!fromAddress || !toAddress || !amount || !privateKey) {
    return response.status(400).json({ error: "Missing parameters" });
  }

  const tronWeb = initializeTronWeb(privateKey);

  try {
    const trade = await tronWeb.transactionBuilder.sendTrx(
      toAddress,
      tronWeb.toSun(amount),
      fromAddress,
    );

    const signedTransaction = await tronWeb.trx.sign(trade);
    const receipt = await tronWeb.trx.sendRawTransaction(signedTransaction);

    response.json({ receipt });
  } catch (error) {
    console.error("Transaction error:", error);
    response.status(500).json({ error: "Failed to send transaction" });
  }
});

/**
 * Send TRC-20 Tokens
 */
exports.sendTrc20Transaction = onRequest(async (request, response) => {
  const { contractAddress, toAddress, amount, privateKey } = request.body;

  if (!contractAddress || !toAddress || !amount || !privateKey) {
    return response.status(400).json({ error: "Missing parameters" });
  }

  const tronWeb = initializeTronWeb(privateKey);

  try {
    const decimals = 6;
    const adjustedAmount = tronWeb.toBigNumber(parseFloat(amount)).multipliedBy(10 ** decimals);

    const contract = await tronWeb.contract().at(contractAddress);

    const transaction = await contract.transfer(toAddress, adjustedAmount.toString()).send({
      feeLimit: 1000000,
    });

    response.json({ success: true, transaction });
  } catch (error) {
    console.error("Transaction error:", error);
    response.status(500).json({
      error: "Failed to send TRC-20 transaction",
      details: error.message,
    });
  }
});
/**
 * Get Energy and Bandwidth Resources for a TRON Wallet Address
 */
exports.getResources = onRequest(async (request, response) => {
  const { address } = request.query;

  // Validate required parameters
  if (!address) {
    return response.status(400).json({ error: "Address is required" });
  }

  try {
    // Validate the wallet address
    validateAddresses(tronWeb, [address]);

    // Fetch account resource information
    const accountResource = await tronWeb.trx.getAccountResources(address);

    // Extract Energy and Bandwidth details
    const energyLimit = accountResource.EnergyLimit || 0;
    const energyUsed = accountResource.EnergyUsed || 0;
    const bandwidthLimit = accountResource.freeNetLimit || 0;
    const bandwidthUsed = accountResource.NetUsed || 0;

    // Return the resource details
    response.json({
      success: true,
      address,
      resources: {
        energy: {
          limit: energyLimit,
          used: energyUsed,
          available: energyLimit - energyUsed,
        },
        bandwidth: {
          limit: bandwidthLimit,
          used: bandwidthUsed,
          available: bandwidthLimit - bandwidthUsed,
        },
      },
    });
  } catch (error) {
    console.error("Failed to fetch resources:", error);
    response.status(500).json({
      error: "Failed to fetch resources",
      reason: error.message,
    });
  }
});
/**
 * Withdraw TRX
 */
exports.withdraw = onRequest(async (request, response) => {
  const { recipientAddress, trxAmount, privateKey, wtrx, usdt, sunswapRouter } = request.body;

  if (!recipientAddress || !trxAmount || !privateKey || !wtrx || !usdt || !sunswapRouter) {
    return response.status(400).json({ error: "Missing parameters" });
  }

  const tronWeb = initializeTronWeb(privateKey);

  try {
    const senderAddress = await tronWeb.defaultAddress.base58;
    const balance = await tronWeb.trx.getBalance(senderAddress);
    if (balance < trxAmount * 1e6) {
      return response.status(400).json({ error: "Insufficient TRX balance" });
    }

    const path = [wtrx, usdt].map((addr) =>
      tronWeb.address.toHex(addr).replace(/^41/, "0x"),
    );

    const deadline = Math.floor(Date.now() / 1000) + 600;

    const swapTx = await tronWeb.transactionBuilder.triggerSmartContract(
      sunswapRouter,
      "swapExactTRXForTokens(uint256,address[],address,uint256)",
      {
        feeLimit: 10000000,
        callValue: tronWeb.toSun(trxAmount),
      },
      [
        "0",
        path,
        tronWeb.address.toHex(recipientAddress),
        deadline,
      ],
      senderAddress,
    );

    const signedTx = await tronWeb.trx.sign(swapTx.transaction);
    const receipt = await tronWeb.trx.sendRawTransaction(signedTx);

    response.json({ success: true, receipt });

  } catch (error) {
    console.error("Withdraw Error:", error);
    response.status(500).json({ error: "Withdrawal failed", details: error.message });
  }
});

/**
 * Verify OTP
 */
exports.verifyOtp = onRequest(async (request, response) => {
  const { email, otp } = request.body;
  if (!email || !otp) {
    return response.status(400).json({ error: "Email or OTP not provided." });
  }

  const otpDoc = db.collection("otps").doc(email);
  const doc = await otpDoc.get();

  if (!doc.exists) {
    return response.status(400).json({ error: "No OTP found for the provided email." });
  }

  const storedOtp = doc.data().otp;

  if (storedOtp === otp) {
    await otpDoc.delete();
    response.json({ message: "OTP verification successful" });
  } else {
    response.status(400).json({ error: "Invalid OTP" });
  }
});

/**
 * Get TRON Wallet Balance
 */
exports.getTronBalance = onRequest(async (request, response) => {
  const { address } = request.query;
  if (!address) {
    return response.status(400).json({ error: "Address is required" });
  }

  try {
    const balance = await tronWeb.trx.getBalance(address);
    response.json({ balance });
  } catch (error) {
    response.status(500).json({ error: "Failed to get balance" });
  }
});

/**
 * Generates a new TRON wallet
 * @returns {Promise<Object>} - A promise that resolves to an object containing the wallet address and private key
 */
exports.generateWallet = onRequest(async (request, response) => {
  try {
    const account = await tronWeb.createAccount();
    response.json({
      address: account.address.base58,
      privateKey: account.privateKey,
    });
  } catch (error) {
    logger.error("Error generating wallet:", error);
    response.status(500).json({ error: "Failed to generate wallet" });
  }
});

/**
 * Broadcast a Raw Transaction
 */
exports.broadcastRawTransaction = onRequest(async (request, response) => {
  const { signedTransaction } = request.body;
  if (!signedTransaction) {
    return response.status(400).json({ error: "Signed transaction is required" });
  }

  try {
    const result = await tronWeb.trx.sendRawTransaction(signedTransaction);
    response.json({ result });
  } catch (error) {
    logger.error("Error broadcasting transaction:", error);
    response.status(500).json({ error: "Failed to broadcast transaction" });
  }
});

/**
 * Send OTP
 */
exports.sendOtp = onRequest(async (request, response) => {
  const { email } = request.body;
  if (!email) {
    return response.status(400).json({ error: "No email address provided." });
  }

  const otp = generateOtp();

  const otpDoc = db.collection("otps").doc(email);
  await otpDoc.set({
    otp: otp,
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
  });

  const mailOptions = {
    from: "info@cryptocoinworld.net",
    to: email,
    subject: "Crypto Coin OTP Code",
    text: `Your Crypto Coin OTP code is: ${otp}`,
  };

  transporter.sendMail(mailOptions, (error, info) => {
    if (error) {
      logger.error("Error sending OTP email:", error);
      return response.status(500).json({ error: `Error sending OTP email: ${error.toString()}` });
    }
    response.json({ message: "OTP email sent successfully" });
  });
});

// Email transporter configuration
const transporter = nodemailer.createTransport({
  host: "smtp.hostinger.com",
  port: 465,
  secure: true, // Use SSL/TLS for port 465
  auth: {
    user: "info@cryptocoinworld.net",
    pass: "Sialkot123@123",
  },
  tls: {
    rejectUnauthorized: false, // Disable certificate validation (temporary)
  },
  connectionTimeout: 60000, // Increase timeout
  debug: true, // Enable debug mode
});

// Verify transporter connection
transporter.verify((error, success) => {
  if (error) {
    console.error("SMTP verification failed:", error);
  } else {
    console.log("SMTP server is ready to take messages");
  }
});

/**
 * Function to generate OTP
 */
function generateOtp() {
  return Math.floor(100000 + Math.random() * 900000).toString();
}

