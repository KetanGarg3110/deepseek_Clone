import 'dart:convert';
import 'dart:io';
import 'package:deepseek/data/remote/api/urls.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:video_player/video_player.dart';

class ImageToVideoScreen extends StatefulWidget {
  const ImageToVideoScreen({super.key});

  @override
  State<ImageToVideoScreen> createState() => _ImageToVideoScreenState();
}

class _ImageToVideoScreenState extends State<ImageToVideoScreen> {
  File? _selectedImage;
  VideoPlayerController? _videoPlayerController;
  bool _isLoading = false;
  final String apiKey = Urls.VIDEO_COMPELETION_API_KEY;

  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    super.dispose();
  }

  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> generateVideoFromImage() async {
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context as BuildContext).showSnackBar(SnackBar(content: Text('Please pick an image first ')),);
      return;
    }

    setState(() => _isLoading = true);
    try {

      final uri = Uri.parse("https://api.stability.ai/v2beta/image-to-video");

      final ext = extension(_selectedImage!.path).toLowerCase();
      final contentType = ext == '.png'
          ? MediaType('image', 'png')
          : MediaType('image', 'jpeg'); // default fallback

      final request =
          http.MultipartRequest('POST', uri)
            ..headers.addAll({
              "Authorization": "Bearer $apiKey",
              // "stability-client-id": "flutter-video-generator",
              // "stability-client-user-id": "user123",
              // "stability-client-version": "1.0.0",
            })
            ..fields['motion_bucket_id'] = '127'
            ..fields['cfg_scale'] = '1.8'
            ..fields['seed'] = '0'
            ..files.add(
              await http.MultipartFile.fromPath(
                'image',
                _selectedImage!.path,
                contentType: contentType,
              ),
            );

      final response = await request.send();

      if (response.statusCode == 200) {
        final respStr = await response.stream.bytesToString();
        final jsonResp = jsonDecode(respStr);
        final id = jsonResp['id'];

        // Polling for the video result
        final videoUrl = await pollForVideoUrl(id);
        if (videoUrl != null) {
          _videoPlayerController = VideoPlayerController.network(videoUrl);
          await _videoPlayerController!.initialize();

          setState(() {
            _isLoading = false;
          });

          _videoPlayerController!.play();
        } else {
          throw Exception('Video generation failed.');
        }
      } else {
        throw Exception('Failed: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<String?> pollForVideoUrl(String id) async {
    final pollUrl =
        "https://api.stability.ai/v2alpha/image-to-video/result/$id";

    for (int i = 0; i < 20; i++) {
      await Future.delayed(Duration(seconds: 2));
      final response = await http.get(
        Uri.parse(pollUrl),
        headers: {"Authorization": "Bearer $apiKey"},
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final status = json['status'];

        if (status == 'succeeded') {
          print('Response JSON: $json');
          return json['video_url'];
        } else if (status == 'failed') {
          return null;
        }
      }
    }
    return null; // Timed out
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Image to Video Generator",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: [
              ElevatedButton.icon(
                onPressed: pickImage,
                icon: Icon(Icons.image,color: Colors.white,),
                label: Text("Pick Image", style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)
                  )
                ),
              ),
              if (_selectedImage != null) ...[
                SizedBox(height: 16),
                Image.file(_selectedImage!, height: 200),
                SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)
                      )
                  ),
                  onPressed: _isLoading ? null : generateVideoFromImage,
                  child: Text("Generate Video from Image",style: TextStyle(color: Colors.white),),
                ),
              ],
              SizedBox(height: 20),
              if (_isLoading)
                CircularProgressIndicator()
              else if (_videoPlayerController != null &&
                  _videoPlayerController!.value.isInitialized)
                AspectRatio(
                  aspectRatio: _videoPlayerController!.value.aspectRatio,
                  child: VideoPlayer(_videoPlayerController!),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
