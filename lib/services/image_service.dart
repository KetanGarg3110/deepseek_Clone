// import 'dart:convert';
// import 'dart:typed_data';
// import 'package:flutter/cupertino.dart';
// import 'package:http/http.dart' as http;
//
// import '../data/remote/api/urls.dart';
//
// //IPv4 Address. . . . . . . . . . . : 192.168.29.124
// class ImageService {
//   static Future<Uint8List?> generateImage(
//     String prompt
//   ) async {
//     try {
//       const baseUrl = 'https://api.stability.ai';
//       final url = Uri.parse('$baseUrl/v2beta/stable-image/generate/ultra');
//
//       final request =
//           http.MultipartRequest('POST', url)
//             ..headers.addAll({
//               'Authorization': 'Bearer ${Urls.IMAGE_COMPELETION_API_KEY}',
//               'Accept': 'image/*',
//               'stability-client-id': 'my-awesome-app',
//               'stability-client-user-id': 'flutter-user#1234',
//               'stability-client-version': '1.0.0',
//             })
//             ..fields['prompt'] = prompt
//             ..fields['aspect_ratio'] = '1:1'
//             ..fields['output_format'] = 'png'
//             ..fields['seed'] = '0'
//             ..fields['style_preset'] = '3d-model';
//
//       final streamedResponse = await request.send();
//
//       if (streamedResponse.statusCode == 200) {
//         final imageBytes = await streamedResponse.stream.toBytes();
//         return imageBytes;
//       } else {
//         final errorBody = await streamedResponse.stream.bytesToString();
//         print('Failed: ${streamedResponse.statusCode}');
//         print('Error Body: $errorBody');
//         return null;
//       }
//     } catch (e) {
//       print('Error: $e');
//       return null;
//     }
//   }
// }
import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

//IPv4 Address. . . . . . . . . . . : 192.168.29.124
class ImageService {
  /// This method can be accessed without creating an instance of ImageServices .
  static Future<Uint8List?> generateImage(String prompt) async {
    try {
      // const baseUrl = 'http://192.168.29.124:3000';
      const baseUrl = 'https://texttoimage-yzvu.onrender.com';
      final url = Uri.parse('$baseUrl/generate');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'prompt': prompt}),
      );

      if (response.statusCode == 200) {
        // convert json response into dart data.
        final Map<String, dynamic> json = jsonDecode(response.body);
        // Extracts the imageUrl (e.g., /images/generated123.png)
        final imageUrl = json['imageUrl'];

        // fetching the image data
        if (imageUrl != null) {
          //If imageUrl is valid, sends a GET request to download the image.
          final imageResponse = await http.get(Uri.parse('$baseUrl$imageUrl'));
          if (imageResponse.statusCode == 200) {
            //If successful, returns the raw image bytes using bodyBytes.
            //These bytes can be used to display the image in a Flutter widget like Image.memory(...).
            return imageResponse.bodyBytes;
          } else {
            print('Failed to fetch image :${imageResponse.statusCode}');
          }
        } else {
          print('Image Url not found in response');
        }
      } else {
        print('Failed :${response.statusCode}');
        print('Response :${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
    return null;
  }
}
