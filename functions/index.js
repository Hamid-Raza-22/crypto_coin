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
  // privateKey: "c66578a4aac443073050601295b970af2d9fa4643b39baa617f8afa8169e1bf7",
//  privateKey: "c37bcb093e7a9b53a7c478602ff4510313a21d2e20c8034d0010d6e920520c848",
  privateKey: "36E14FE949DCE28AF7A7D061DE164018F0E4CDEAFC99ACE724065C95DC4042A4",
});

// Generate the address from the private key
const publicAddress = tronWeb.defaultAddress.base58;

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

/**
 * Send TRC-20 Tokens
 */
exports.sendTrc20Transaction = onRequest(async (request, response) => {
  const { contractAddress, toAddress, amount } = request.body;

  console.log("Received Data:", {contractAddress, toAddress, amount});

  if (!contractAddress || !toAddress || !amount) {
    return response.status(400).json({ error: "Missing required fields" });
  }

  try {
    // Validate contract and recipient addresses
    if (!tronWeb.isAddress(contractAddress)) {
      console.error("Invalid contract address:", contractAddress);
      return response.status(400)
      .json({ error: "Invalid contract address" });
    }
    if (!tronWeb.isAddress(toAddress)) {
      console.error("Invalid recipient address:", toAddress);
      return response.status(400)
      .json({ error: "Invalid recipient address" });
    }

    // Convert amount to the smallest unit (USDT has 6 decimals)
    const decimals = 6;  // Adjust for your token if needed
    const adjustedAmount = tronWeb.toBigNumber(parseFloat(amount)).multipliedBy(10 ** decimals);

    console.log("Adjusted Amount (in smallest unit):", adjustedAmount.toString());

    // Load TRC-20 contract
    const contract = await tronWeb.contract().at(contractAddress);

    // Perform the transfer transaction
    const transaction = await contract.transfer(toAddress, adjustedAmount.toString()).send({
      feeLimit: 1000000,  // TRX for gas fees
    });

    console.log("Transaction successful:", transaction);

    // Respond with transaction details
    response.json({ success: true, transaction });

  } catch (error) {
    console.error("TRC-20 Transaction error:", error.message);
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
