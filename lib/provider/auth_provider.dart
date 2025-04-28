import 'package:deepseek/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final codeController = TextEditingController(); // for later if needed

  bool _isLoading = false;

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
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen(),));
      _showMessage(context, "Registration Successful");
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
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen(),));
      _showMessage(context, "Login Successful");
    } on FirebaseAuthException catch (e) {
      _showMessage(context, e.message ?? "Login Failed");
    } finally {
      setLoading(false);
    }
  }

  void _showMessage(BuildContext context, String s) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(s)));
  }

  void disposeController() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    codeController.dispose();
  }
}
