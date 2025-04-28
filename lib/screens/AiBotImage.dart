import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AiBotImage extends StatefulWidget{
  const AiBotImage({super.key});

  @override
  State<AiBotImage> createState() => _AiBotImageState();
}

class _AiBotImageState extends State<AiBotImage> {
  final TextEditingController _controller = TextEditingController();
  String imageUrl = '';
  bool isLoading = false;

  Future<void> generateImage(String prompt) async {
    setState(() {
      isLoading = true;
      imageUrl = '';
    });

    final url = Uri.parse('https://api.deepai.org/api/text2img');
    final response = await http.post(
      url,
      headers: {
        'api-key': '507fd372-556b-410e-bbcb-4a3bd29c2968', // Replace with your real API key
      },
      body: {
        'text': prompt,
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        imageUrl = data['output_url'] ?? '';
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      print('Error: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('DeepAI Image Generator')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter prompt',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                if (_controller.text.isNotEmpty) {
                  generateImage(_controller.text);
                }
              },
              child: Text('Generate Image'),
            ),
            SizedBox(height: 20),
            isLoading
                ? CircularProgressIndicator()
                : imageUrl.isNotEmpty
                ? Expanded(
              child: Image.network(imageUrl),
            )
                : Container(),
          ],
        ),
      ),
    );
  }
}