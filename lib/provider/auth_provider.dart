import 'dart:io';
import 'package:deepseek/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthProvider extends ChangeNotifier {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final codeController = TextEditingController(); // for later if needed

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureLoginPassword = true;
  bool _obscureConfirmPassword = true;

  bool get obscurePassword => _obscurePassword;
  bool get obscureLoginPassword => _obscureLoginPassword;
  bool get obscureConfirmPassword => _obscureConfirmPassword;

  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> signUp(BuildContext context) async {
    if (passwordController.text.trim() !=
        confirmPasswordController.text.trim()) {
      _showMessage(context, "Password do not match");
      return;
    }
    setLoading(true);
    try {

     UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      // await FirebaseFirestore.instance.collection('Users').add({
      //   'email': emailController.text.trim(),
      //   'password': passwordController.text.trim(),
      // });
     final uid = userCredential.user!.uid;

      await FirebaseFirestore.instance.collection('Users').doc(uid).set({
        'email': emailController.text.trim(),
        'passwordPlain' : passwordController.text.trim(),
      });

      if (!context.mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
        (route) => false,
      );
      // if (!context.mounted) return;
      // _showMessage(context, "Registration Successful");
    } on FirebaseAuthException catch (e) {
      _showMessage(context, e.message ?? "Registration Failed");
    } finally {
      setLoading(false);
    }
  }

  Future<void> logIn(BuildContext context) async {
    setLoading(true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      if (!context.mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
      _showMessage(context, "Login Successful");
    } on FirebaseAuthException catch (e) {
      _showMessage(context, e.message ?? "Login Failed");
    } finally {
      setLoading(false);
    }
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    setLoading(true);
    try {
      if (kIsWeb) {
        // Web : Use signInWithPopup
        GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();

        await FirebaseAuth.instance.signInWithPopup(googleAuthProvider);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
        _showMessage(context, "SignUp Successful");
      } else if (!Platform.isAndroid && !Platform.isIOS) {
        _showMessage(
          context,
          "Google Sign-In is only supported on Android, iOS, and Web. Please use Email/Password on Windows.",
        );
        setLoading(false);
        return;
      } else {
        //Mobile : Use GoogleSignIn + FirebaseAuth
        // Trigger Authentication Flow
        final GoogleSignInAccount? googleUser =
            await GoogleSignIn(scopes: ['email', 'profile']).signIn();

        // googleUser! can crash if the user cancels sign-in
        if (googleUser == null) {
          _showMessage(context, "Google sign-in was cancelled");
          setLoading(false);
          return;
        }

        //Get auth details from the request
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        //Sometimes googleAuth might not return both, especially on mobile with issues in Google Sign-In config.
        if (googleAuth.accessToken == null || googleAuth.idToken == null) {
          _showMessage(context, "Google sign-in failed to retrieve tokens");
          setLoading(false);
          return;
        }

        // Create a Credential
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Sign in to Firebase with the credential
        await FirebaseAuth.instance.signInWithCredential(credential);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );

        _showMessage(context, "SignUp Successful");
      }
    } on FirebaseAuthException catch (e) {
      _showMessage(context, e.message ?? "SignUp Failed");
    } finally {
      setLoading(false);
    }
  }

  Future<void> forgetPassword(BuildContext context) async {
    if (emailController.text.trim().isEmpty) {
      _showMessage(context, "Please enter your email");
      setLoading(false);
      return;
    }
    setLoading(true);
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailController.text.trim(),
      );
      if (!context.mounted) return;
      _showMessage(context, "Password reset email sent");
      Navigator.pop(context); // Go back to login page
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        _showMessage(context, "No user found with this email");
      } else if (e.code == 'invalid-email') {
        _showMessage(context, "Invalid email format");
      } else {
        _showMessage(context, e.message ?? "Something went wrong");
      }
    } finally {
      setLoading(false);
    }
  }

  void _showMessage(BuildContext context, String s) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(s)));
  }

  void obsPassword() {
    _obscurePassword = !_obscurePassword;
    notifyListeners(); // Notify Ui to rebuild.
  }

  void obsLoginPassword() {
    _obscureLoginPassword = !_obscureLoginPassword;
    notifyListeners(); // Notify Ui to rebuild.
  }

  void obsConfirmPassword() {
    _obscureConfirmPassword = !_obscureConfirmPassword;
    notifyListeners();
  }

  void disposeController() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    codeController.dispose();
  }
}
