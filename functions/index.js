/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const {onRequest} = require("firebase-functions/v2/https");
const admin = require("firebase-admin");
const logger = require("firebase-functions/logger");
const nodemailer = require("nodemailer");
const {TronWeb} = require("tronweb"); // TronWeb blockchain transactions

admin.initializeApp();
const db = admin.firestore();

// TRON Configuration
const tronWeb = new TronWeb({
  fullHost: "https://api.trongrid.io", // MainNet URL
   privateKey: "c66578a4aac443073050601295b970af2d9fa4643b39baa617f8afa8169e1bf7",
//  privateKey: "c37bcb093e7a9b53a7c478602ff4510313a21d2e20c8034d0010d6e920520c848",
  // privateKey: "36E14FE949DCE28AF7A7D061DE164018F0E4CDEAFC99ACE724065C95DC4042A4",
});

// Generate the address from the private key
const publicAddress = tronWeb.defaultAddress.base58;
const address1 = '0x67dedf8cc958dbe573d4c9b5669d2943812bfa99';
const address2 = '0xa614f803b6fd780986a42c78ec9c7f77e6ded13c';

const tronAddress1 = TronWeb.address.fromHex(address1);
const tronAddress2 = TronWeb.address.fromHex(address2);

console.log(`TRON base58 Address 1: ${tronAddress1}`);
console.log(`TRON base58 Address 2: ${tronAddress2}`);
// Compare the generated address with the address you're trying to verify
console.log("Generated Public Address: ", publicAddress);

// Function to generate a 6-digit OTP
/**
 * Generates a 6-digit OTP
 * @return {string} - The generated 6-digit OTP
 */
function generateOtp() {
  return Math.floor(100000 + Math.random() * 900000).toString();
}

const SUNSWAP_ROUTER = "TXF1xDbVGdxFGbovmmmXvBGu8ZiE3Lq4mR"; // SunSwap Router V2
const WTRX = "TNUC9Qb1rRpS5CbWLmNMxXBjyFoydXjWFR"; // Wrapped TRX Address
const USDT = "TR7NHqjeKQxGTCi8q8ZY4pL8otSzgjLj6t"; // USDT Contract

const errorMessages = [];


if (!tronWeb.isAddress(WTRX)) {
  console.error("WTRX address is invalid:", WTRX);
  errorMessages.push("WTRX address is invalid.");
}
if (!tronWeb.isAddress(USDT)) {
  console.error("USDT address is invalid:", USDT);
  errorMessages.push("USDT address is invalid.");
}
if (!tronWeb.isAddress(SUNSWAP_ROUTER)) {
  console.error("SUNSWAP_ROUTER address is invalid:", SUNSWAP_ROUTER);
  errorMessages.push("SUNSWAP_ROUTER address is invalid.");
}
if (errorMessages.length > 0) {
  throw new Error(errorMessages.join(" "));
}


console.log("Generated SunSwap Address: ", SUNSWAP_ROUTER);


exports.swapTrxToUsdt = onRequest(async (request, response) => {
  const { fromAddress, receiverAddress, trxAmount } = request.body;

  // Validate input
  if (!fromAddress || !receiverAddress || !trxAmount) {
    return response.status(400).json({ error: "Missing parameters" });
  }

  try {
    // Validate addresses
    [fromAddress, receiverAddress, WTRX, USDT, SUNSWAP_ROUTER].forEach((addr) => {
      if (!tronWeb.isAddress(addr)) throw new Error(`Invalid address: ${addr}`);
    });

    // Convert TRX to SUN
    const amountInSun = tronWeb.toSun(trxAmount);
    if (!amountInSun || isNaN(amountInSun)) {
      throw new Error("Invalid TRX amount provided.");
    }

    // Use base58 addresses for the path
    const path = [WTRX, USDT];

    // Get amounts out using correct path formatting
    const amountsOutResult = await tronWeb.transactionBuilder.triggerConstantContract(
      SUNSWAP_ROUTER,
      "getAmountsOut(uint256,address[])",
      { feeLimit: 10000000 },
      [
        { type: "uint256", value: amountInSun.toString() },
        { type: "address[]", value: path },
      ],
      tronWeb.address.toHex(fromAddress), // fromAddress in hex for simulation
    );

    // Extract expected USDT amount
    const hexData = amountsOutResult.constant_result[0];
    if (!hexData || hexData.length < 128) {
      throw new Error("Invalid response from getAmountsOut");
    }
    const expectedUsdt = tronWeb.toBigNumber(`0x${hexData.substring(64, 128)}`);
    const amountOutMin = expectedUsdt.multipliedBy(0.98).integerValue();

    // Prepare swap parameters with correct address types
    const swapParams = [
      { type: "uint256", value: amountOutMin.toString() },
      { type: "address[]", value: path },
      { type: "address", value: receiverAddress }, // Pass base58 directly
      { type: "uint256", value: (Math.floor(Date.now() / 1000) + 300).toString() },
    ];

    // Execute the swap
    const transaction = await tronWeb.transactionBuilder.triggerSmartContract(
      SUNSWAP_ROUTER,
      "swapExactETHForTokens(uint256,address[],address,uint256)",
      {
        feeLimit: 10000000,
        callValue: amountInSun,
      },
      swapParams,
      fromAddress, // base58 fromAddress
    );

    // Sign and broadcast transaction
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
exports.withdraw = onRequest(async (req, res) => {
  const { recipientAddress, trxAmount } = req.body;

  if (!recipientAddress || !trxAmount) {
    return res.status(400).json({ error: "Missing parameters" });
  }

  // Validate recipient address
  if (!tronWeb.isAddress(recipientAddress)) {
    return res.status(400).json({ error: "Invalid recipient address" });
  }

  try {
    // TRX balance check
    const senderAddress = await tronWeb.defaultAddress.base58;
    const balance = await tronWeb.trx.getBalance(senderAddress);
    if (balance < trxAmount * 1e6) {
      return res.status(400).json({ error: "Insufficient TRX balance" });
    }

    // Swap TRX to USDT using SunSwap Router
    const path = [WTRX, USDT].map((addr) =>
      tronWeb.address.toHex(addr).replace(/^41/, "0x"),
    );

    const deadline = Math.floor(Date.now() / 1000) + 600; // 10-minute deadline

    const swapTx = await tronWeb.transactionBuilder.triggerSmartContract(
      SUNSWAP_ROUTER,
      "swapExactTRXForTokens(uint256,address[],address,uint256)",
      {
        feeLimit: 10000000,
        callValue: tronWeb.toSun(trxAmount),
      },
      [
        "0", // Minimum amount out (you can adjust slippage handling here)
        path,
        tronWeb.address.toHex(recipientAddress),
        deadline,
      ],
      senderAddress,
    );

    // Sign & broadcast transaction
    const signedTx = await tronWeb.trx.sign(swapTx.transaction);
    const receipt = await tronWeb.trx.sendRawTransaction(signedTx);

    res.json({ success: true, receipt });

  } catch (error) {
    console.error("Withdraw Error:", error);
    res.status(500).json({ error: "Withdrawal failed", details: error.message });
  }
});

// Email transporter configuration
const transporter = nodemailer.createTransport({
  service: "gmail", // Replace with your email service (e.g., SendGrid, Gmail)
  auth: {
    user: "hamidraza.engr@gmail.com", // Replace with your email
    pass: "imyy swks mieh bhwy", // Replace with your email password
  },
});

/**
 * HTTP function that logs a message and sends a response
 * @param {object} request - The HTTP request object
 * @param {object} response - The HTTP response object
 */
exports.helloWorld = onRequest((request, response) => {
  logger.info("Hello logs!", {structuredData: true});
  response.json("Hello from Firebase!");
});

/**
 * HTTP function that generates and sends OTP via email
 * @param {object} request - The HTTP request object
 * @param {object} response - The HTTP response object
 */
exports.sendOtp = onRequest(async (request, response) => {
  logger.info("Request body:", request.body);

  const email = request.body.email; // Extract email from request body
  if (!email) {
    logger.error("No email address provided.");
    return response.status(400).json({error: "No email address provided."});
  }

  const otp = generateOtp(); // Generate a 6-digit OTP

  // Store the OTP in Firestore with a TTL (Time-to-Live)
  const otpDoc = db.collection("otps").doc(email);
  await otpDoc.set({
    otp: otp,
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
  });

  logger.info(`Stored OTP for ${email}: ${otp}`);

  const mailOptions = {
    from: "hamidraza.engr@gmail.com", // Replace with your email
    to: email, // Use the extracted email
    subject: "Your OTP Code",
    text: `Your OTP code is: ${otp}`,
  };

  transporter.sendMail(mailOptions, (error, info) => {
    if (error) {
      logger.error("Error sending OTP email:", error);
      return response.status(500)
          .json({error: `Error sending OTP email: ${error.toString()}`});
    }
    logger.info("OTP email sent successfully:", info.response);
    response.json({message: "OTP email sent successfully"});
  });
});

/**
 * HTTP function that verifies the OTP
 * @param {object} request - The HTTP request object
 * @param {object} response - The HTTP response object
 */
exports.verifyOtp = onRequest(async (request, response) => {
  logger.info("Request body:", request.body);

  const {email, otp} = request.body; // Extract email and OTP from request body
  if (!email || !otp) {
    logger.error("Email or OTP not provided.");
    return response.status(400).json({error: "Email or OTP not provided."});
  }

  // Retrieve the OTP from Firestore
  const otpDoc = db.collection("otps").doc(email);
  const doc = await otpDoc.get();

  if (!doc.exists) {
    logger.error("No OTP found for the provided email.");
    return response.status(400)
        .json({error: "No OTP found for the provided email."});
  }

  const storedOtp = doc.data().otp;

  if (storedOtp === otp) {
    logger.info("OTP verification successful for email:", email);
    response.json({message: "OTP verification successful"});
    // Optionally, delete the OTP from Firestore after successful verification
    await otpDoc.delete();
  } else {
    logger.error("OTP verification failed for email:", email);
    response.status(400).json({error: "Invalid OTP"});
  }
});

/**
 * Get TRON Wallet Balance
 */
exports.getTronBalance = onRequest(async (request, response) => {
  const address = request.query.address;
  if (!address) {
    return response.status(400).json({error: "Address is required"});
  }

  try {
    const balance = await tronWeb.trx.getBalance(address);
    response.json({balance});
  } catch (error) {
    logger.error("Error fetching balance:", error);
    response.status(500).json({error: "Failed to get balance"});
  }
});

/**
 * Send TRON Transaction
 */
exports.sendTronTransaction = onRequest(async (request, response) => {
  const {fromAddress, toAddress, amount} = request.body;

  if (!fromAddress || !toAddress || !amount) {
    return response.status(400).json({error: "Missing required fields"});
  }

  try {
    const trade = await tronWeb.transactionBuilder.sendTrx(
        toAddress,
        tronWeb.toSun(amount), // Convert to SUN
        fromAddress,
    );

    const signedTransaction = await tronWeb.trx.sign(trade);
    const receipt = await tronWeb.trx.sendRawTransaction(signedTransaction);

    response.json({receipt});
  } catch (error) {
    logger.error("Transaction error:", error);
    response.status(500).json({error: "Failed to send transaction"});
  }
});

// Adjusted Backend Code (Node.js)
exports.sendTrc20Transaction = onRequest(async (request, response) => {
  const { contractAddress, toAddress, amount } = request.body;

  if (!contractAddress || !toAddress || !amount) {
    return response.status(400).json({ error: "Missing required fields" });
  }

  try {
    // Validate addresses
    if (!tronWeb.isAddress(contractAddress) || !tronWeb.isAddress(toAddress)) {
      return response.status(400).json({ error: "Invalid address" });
    }

    // Convert amount to smallest unit
    const decimals = 6; // Adjust for token's decimals
    const adjustedAmount = tronWeb.toBigNumber(parseFloat(amount)).multipliedBy(10 ** decimals);

    // Load contract
    const contract = await tronWeb.contract().at(contractAddress);

    // Send transaction
    const transaction = await contract.transfer(toAddress, adjustedAmount.toString()).send({
      feeLimit: 1000000, // 20 TRX
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
 * Generate a new TRON Wallet
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
    response.status(500).json({error: "Failed to generate wallet"});
  }
});

/**
 * Broadcast a Raw Transaction
 */
exports.broadcastRawTransaction = onRequest(async (request, response) => {
  const {signedTransaction} = request.body;
  if (!signedTransaction) {
    return response.status(400).json({error: "Signed transaction is required"});
  }

  try {
    const result = await tronWeb.trx.sendRawTransaction(signedTransaction);
    response.json({result});
  } catch (error) {
    logger.error("Error broadcasting transaction:", error);
    response.status(500).json({error: "Failed to broadcast transaction"});
  }
});
