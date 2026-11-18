import 'package:deepseek/provider/auth_provider.dart';
import 'package:deepseek/screens/ForgetPassword.dart';
import 'package:deepseek/screens/regestration_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DeepSeekLogin extends StatelessWidget {
  const DeepSeekLogin({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Column(
                children: [
                  Image.asset(
                    'assets/images/icons8-deepseek-50.png', // Replace with your logo
                    width: 60,
                    height: 60,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'deepseek',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4C66FB),
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Info Text
              const Text(
                'Only login via email, Google, or +86 phone number login is supported in your region.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 20),

              // Email / Phone
              TextFormField(
                controller: authProvider.emailController,
                decoration: InputDecoration(
                  hintText: 'Phone number / email address',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter Email";
                  }
                  if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                    return "Enter valid email";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // Password
              TextFormField(
                controller: authProvider.passwordController,
                obscureText: authProvider.obscureLoginPassword,
                decoration: InputDecoration(
                  hintText: 'Password',
                  suffixIcon: IconButton(
                    onPressed: () {
                      authProvider.obsLoginPassword();
                    },
                    icon: Icon(
                      authProvider.obscureLoginPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // Terms
              const Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text:
                          'By signing up or logging in, you consent to DeepSeek\'s ',
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                    TextSpan(
                      text: 'Terms of Use',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontSize: 12,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: ' and ',
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                    TextSpan(
                      text: 'Privacy Policy.',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontSize: 12,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Log In Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed:
                      authProvider.isLoading
                          ? null
                          : () => authProvider.logIn(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF4C66FB),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child:
                      authProvider.isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                            'Log in',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                ),
              ),
              const SizedBox(height: 8),

              // Forgot Password and Sign Up
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed:
                        authProvider.isLoading
                            ? null
                            : () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ResetPasswordPage(),
                                ),
                              );
                            },
                    child: const Text(
                      'Forgot password?',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                  TextButton(
                    onPressed:
                        authProvider.isLoading
                            ? null
                            : () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DeepSeekSignUp(),
                                ),
                              );
                            },
                    child: const Text(
                      'Sign up',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Divider
              Row(
                children: const [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text('OR'),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 16),

              // Google Login
              OutlinedButton.icon(
                onPressed:
                    authProvider.isLoading
                        ? null
                        : () => authProvider.signInWithGoogle(context),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 50,
                  ),
                  side: BorderSide(color: Colors.black12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  backgroundColor: Colors.white,
                ),
                icon: Image.asset(
                  'assets/images/google_img.jpeg', // Add Google logo asset
                  height: 20,
                ),
                label: const Text(
                  'Log in with Google',
                  style: TextStyle(color: Colors.black87),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
