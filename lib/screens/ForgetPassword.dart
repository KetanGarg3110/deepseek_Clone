import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/auth_provider.dart';

void main() {
  runApp(const MaterialApp(
    home: ResetPasswordPage(),
    debugShowCheckedModeBanner: false,
  ));
}

class ResetPasswordPage extends StatelessWidget {
  const ResetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider =Provider.of<AuthProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                )
              ],
            ),
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 40,
                  child: Icon(Icons.security, size: 48, color: Colors.blue),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Reset password',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Enter your phone number or email address and we will\nsend you a verification code to reset your password.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: authProvider.emailController,
                  decoration: InputDecoration(
                    hintText: 'Email address / +86 phone number',
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Row(
                //   children: [
                //     Expanded(
                //       child: TextField(
                //         decoration: InputDecoration(
                //           hintText: 'Code',
                //           prefixIcon: const Icon(Icons.numbers),
                //           border: OutlineInputBorder(
                //             borderRadius: BorderRadius.circular(12),
                //           ),
                //         ),
                //       ),
                //     ),
                //     const SizedBox(width: 12),
                //     ElevatedButton(
                //       style: ElevatedButton.styleFrom(
                //         foregroundColor: Colors.black87,
                //         backgroundColor: Colors.white,
                //         elevation: 2,
                //         shape: RoundedRectangleBorder(
                //           borderRadius: BorderRadius.circular(12),
                //           side: const BorderSide(color: Colors.black12),
                //         ),
                //       ),
                //       onPressed: () {},
                //       child: const Text('Send code'),
                //     ),
                //   ],
                // ),
                // const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF556FFF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: authProvider.isLoading
                        ?null
                        :()=> authProvider.forgetPassword(context),
                    child: const Text(
                      'Continue',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Back to log in',
                    style: TextStyle(color: Color(0xFF556FFF)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
