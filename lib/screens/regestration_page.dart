import 'package:deepseek/screens/login_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/auth_provider.dart';



class DeepSeekSignUp extends StatelessWidget {
  const DeepSeekSignUp({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider =Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo and Title
              Column(
                children: [
                  Image.asset(
                    'assets/images/icons8-deepseek-50.png', // Replace with actual logo
                    width: 60,
                    height: 60,
                  ),
                  const SizedBox(height: 10),
                  const Text(
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
                'Only email registration is supported in your region. One DeepSeek account is all you need to access to all DeepSeek services.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 20),

              // Email Field
              TextFormField(
                controller: authProvider.emailController,
                decoration: InputDecoration(
                  hintText: 'Email address',
                  prefixIcon: Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if(value ==null || value.isEmpty){
                    return 'Enter email';
                  }
                  if(!RegExp(r'\S+@\S+\.\S+').hasMatch(value)){
                    return "Enter valid email";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // Password Field
              TextFormField(
                controller: authProvider.passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Password',
                  prefixIcon: Icon(Icons.lock_outline),
                  suffixIcon: Icon(Icons.visibility),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
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

              // Confirm Password
              TextFormField(
                controller: authProvider.confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Confirm password',
                  prefixIcon: Icon(Icons.lock_outline),
                  suffixIcon: Icon(Icons.visibility),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (value != authProvider.passwordController) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // Code Field + Send Code
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      controller: authProvider.codeController,
                      decoration: InputDecoration(
                        hintText: 'Code',
                        prefixIcon: Icon(Icons.tag_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        backgroundColor: Colors.grey.shade200,
                        foregroundColor: Colors.black87,
                      ),
                      child: const Text('Send code'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Terms
              const Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'By signing up, you consent to DeepSeek\'s ',
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                    TextSpan(
                      text: 'Terms of Use',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Colors.black,
                        fontSize: 12,
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
                        color: Colors.black,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Sign Up Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: authProvider.isLoading
                  ?null
                  :()=> authProvider.signUp(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF4C66FB),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Sign up',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              // Login Text
              const SizedBox(height: 12),
              TextButton(
                onPressed: authProvider.isLoading
                ?null:(){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => DeepSeekLogin()),
                  );
                },
                child: const Text(
                  'Log in',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
