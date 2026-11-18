// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:retry/retry.dart';
//
//
// void main() async {
//
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Image Generator',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         useMaterial3: true,
//       ),
//       home: const ImageGeneratorScreen(),
//     );
//   }
// }
//
// class ImageGeneratorScreen extends StatefulWidget {
//   const ImageGeneratorScreen({super.key});
//
//   @override
//   State<ImageGeneratorScreen> createState() => _ImageGeneratorScreenState();
// }
//
// class _ImageGeneratorScreenState extends State<ImageGeneratorScreen> {
//   final TextEditingController _promptController = TextEditingController();
//   String? _imageUrl;
//   String? _textResponse;
//   String? _errorMessage;
//   List<Map<String, String>> _imageList = [];
//   bool _isLoading = false;
//
//   final String _baseUrl ='https://texttoimage-yzvu.onrender.com';
//
//   Future<void> _generateImage() async {
//     final prompt = _promptController.text.trim();
//
//     if (prompt.isEmpty || prompt.length > 1000) {
//       setState(() {
//         _errorMessage = 'Prompt must be between 1 and 1000 characters';
//       });
//       return;
//     }
//
//     setState(() {
//       _isLoading = true;
//       _errorMessage = null;
//       _imageUrl = null;
//       _textResponse = null;
//     });
//
//     try {
//       final response = await retry(
//             () => http
//             .post(
//           Uri.parse('$_baseUrl/generate'),
//           headers: {'Content-Type': 'application/json'},
//           body: jsonEncode({'prompt': prompt}),
//         )
//             .timeout(const Duration(seconds: 30)),
//         maxAttempts: 3,
//         onRetry: (e) => print('Retrying generate request: $e'),
//       );
//
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         setState(() {
//           _imageUrl = data['imageUrl'] != null
//               ? data['imageUrl'].startsWith('http')
//               ? data['imageUrl'].toString()
//               : '$_baseUrl${data['imageUrl']}'
//               : null;
//           _textResponse = data['text']?.toString() ?? '';
//         });
//       } else if (response.statusCode == 400) {
//         final data = jsonDecode(response.body);
//         setState(() {
//           if (data['error'] is List) {
//             _errorMessage = data['error'].map((e) => e['message']).join(', ');
//           } else {
//             _errorMessage = data['error']?.toString() ?? 'Invalid request';
//           }
//         });
//       } else {
//         setState(() {
//           _errorMessage = 'Failed to generate image: ${response.statusCode}';
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _errorMessage = 'Error: ${e.toString()}';
//       });
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }
//
//   Future<void> _fetchImages() async {
//     setState(() {
//       _isLoading = true;
//       _errorMessage = null;
//     });
//
//     try {
//       final response = await retry(
//             () => http
//             .get(Uri.parse('$_baseUrl/images'))
//             .timeout(const Duration(seconds: 30)),
//         maxAttempts: 3,
//         onRetry: (e) => print('Retrying fetch images: $e'),
//       );
//
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         print('Raw images response: $data'); // Debug: Log raw response
//
//         if (data['images'] is! List) {
//           setState(() {
//             _errorMessage = 'Invalid response format: images is not a list';
//           });
//           return;
//         }
//
//         setState(() {
//           _imageList = (data['images'] as List<dynamic>)
//               .asMap()
//               .entries
//               .map((entry) {
//             final item = entry.value as Map<String, dynamic>;
//             final name = item['name']?.toString() ?? 'Image_${entry.key}';
//             final url = item['url']?.toString();
//             return url != null && url.isNotEmpty
//                 ? {
//               'name': name,
//               'url': url.startsWith('http') ? url : '$_baseUrl$url',
//             }
//                 : null;
//           })
//               .where((item) => item != null)
//               .cast<Map<String, String>>()
//               .toList();
//           _imageList.sort((a, b) => b['name']!.compareTo(a['name']!));
//         });
//       } else {
//         setState(() {
//           _errorMessage = 'Failed to load images: ${response.statusCode}';
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _errorMessage = 'Error: ${e.toString()}';
//       });
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchImages();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final screenHeight = MediaQuery.of(context).size.height;
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Image Generator'),
//       ),
//       body: Stack(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   TextField(
//                     controller: _promptController,
//                     decoration: const InputDecoration(
//                       labelText: 'Enter Prompt',
//                       border: OutlineInputBorder(),
//                       hintText: 'Enter a description (1-1000 characters)',
//                     ),
//                     maxLines: 3,
//                   ),
//                   const SizedBox(height: 16),
//                   ElevatedButton(
//                     onPressed: _isLoading ? null : _generateImage,
//                     child: _isLoading
//                         ? const CircularProgressIndicator()
//                         : const Text('Generate Image'),
//                   ),
//                   const SizedBox(height: 16),
//                   if (_errorMessage != null)
//                     Text(
//                       _errorMessage!,
//                       style: const TextStyle(color: Colors.red),
//                       textAlign: TextAlign.center,
//                     ),
//                   if (_imageUrl != null) ...[
//                     const SizedBox(height: 16),
//                     CachedNetworkImage(
//                       imageUrl: _imageUrl!,
//                       height: screenHeight * 0.3,
//                       fit: BoxFit.contain,
//                       placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
//                       errorWidget: (context, url, error) => const Text('Failed to load image'),
//                     ),
//                   ],
//                   if (_textResponse != null && _textResponse!.isNotEmpty) ...[
//                     const SizedBox(height: 16),
//                     Text(
//                       'Text Response: $_textResponse',
//                       style: const TextStyle(fontSize: 16),
//                     ),
//                   ],
//                   const SizedBox(height: 16),
//                   ElevatedButton(
//                     onPressed: _isLoading ? null : _fetchImages,
//                     child: const Text('Refresh Image List'),
//                   ),
//                   const SizedBox(height: 16),
//                   const Text(
//                     'Generated Images:',
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 8),
//                   _imageList.isEmpty
//                       ? const Text('No images found.')
//                       : ListView.builder(
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     itemCount: _imageList.length,
//                     itemBuilder: (context, index) {
//                       final image = _imageList[index];
//                       return ListTile(
//                         title: Text(image['name']!),
//                         trailing: CachedNetworkImage(
//                           imageUrl: image['url']!,
//                           width: 50,
//                           height: 50,
//                           fit: BoxFit.cover,
//                           placeholder: (context, url) => const CircularProgressIndicator(),
//                           errorWidget: (context, url, error) => const Icon(Icons.error),
//                         ),
//                         onTap: () {
//                           setState(() {
//                             _imageUrl = image['url'];
//                           });
//                         },
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           if (_isLoading)
//             const Center(
//               child: CircularProgressIndicator(),
//             ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _promptController.dispose();
//     super.dispose();
//   }
// }