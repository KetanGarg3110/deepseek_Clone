// import 'package:flutter/material.dart';
// import '../services/api_service.dart';
//
// class TextGenerationScreen extends StatefulWidget {
//   @override
//   _TextGenerationScreenState createState() => _TextGenerationScreenState();
// }
//
// class _TextGenerationScreenState extends State<TextGenerationScreen> {
//   final TextEditingController _controller = TextEditingController();
//   String _response = '';
//   bool _loading = false;
//
//   void _generateText() async {
//     setState(() => _loading = true);
//     final result = await ApiService.generateText(_controller.text);
//     setState(() {
//       _response = result;
//       _loading = false;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.all(16),
//       child: Column(
//         children: [
//           TextField(
//             controller:
//             _controller,
//             decoration: InputDecoration(labelText: "Enter a prompt"),
//           ),
//           SizedBox(height: 16),
//           ElevatedButton(
//             onPressed: _loading ? null : _generateText,
//             child: Text(_loading ? 'Loading...' : 'Generate Text'),
//           ),
//           SizedBox(height: 20),
//           Expanded(child: SingleChildScrollView(child: Text(_response))),
//         ],
//       ),
//     );
//   }
// }
