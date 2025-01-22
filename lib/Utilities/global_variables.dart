import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

late AnimationController _fadeController;
late Animation<double> _fadeAnimation;

late AnimationController _slideController;
late Animation<Offset> _slideAnimation;

late AnimationController _buttonController;
late Animation<double> _buttonAnimation;
// Main Color
const Color buttonColorGreen = Color(0xFF00F27E);
// Images
final FirebaseAuth auth = FirebaseAuth.instance;

const hamidImage = "assets/images/Hamid2.jpg";
const logo = "assets/images/logo.png";
const lockImage = "assets/images/lock.png";
const messageImage = "assets/images/message.png";
const mobileEmail = "assets/images/mobileEmail.png";
const verificationMarkImage = "assets/images/verificationMark.png";
const transactionMarkImage = "assets/images/TransactionSuccess.png";


// Icons
const googleIcon = "assets/icons/google.png";
const facebookIcon = "assets/icons/facebook.png";
const instagramIcon = "assets/icons/instagram.png";
const twitterIcon = "assets/icons/twitter.png";
const whatsappIcon = "assets/icons/whatsapp.png";

