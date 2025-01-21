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
admin.initializeApp();
const db = admin.firestore();

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
    pass: "passkey", // Replace with your email password
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
