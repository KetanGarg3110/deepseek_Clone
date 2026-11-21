import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:deepseek/provider/image_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class ImageGeneratorScreen extends StatefulWidget {
  const ImageGeneratorScreen({super.key});

  @override
  State<ImageGeneratorScreen> createState() => _ImageGeneratorScreenState();
}

class _ImageGeneratorScreenState extends State<ImageGeneratorScreen> {
  /// Why we use video player ?
  /// Because of the lottie file has mp4 exetention.
  VideoPlayerController? _videoPlayerController;
  bool _isVideoSupported = false;

  @override
  void initState() {
    super.initState();
    _isVideoSupported = !kIsWeb && (Platform.isAndroid || Platform.isIOS || Platform.isMacOS);
    if (_isVideoSupported) {
      _videoPlayerController = VideoPlayerController.asset(
          'assets/videos/aiRobotChatbot.mp4',
        )
        ..initialize().then((_) {
          if (mounted) {
            setState(() {});
            _videoPlayerController?.setLooping(true);
            _videoPlayerController?.play();
          }
        }).catchError((error) {
          print('VideoPlayer error: $error');
        });
    }
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ImageGeneratorProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Text to Image Generator",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: provider.controller,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: "Enter a prompt",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: Colors.teal,
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 30,
                ),
              ),
              onPressed:
                  provider.isLoading
                      ? null
                      : () async {
                        await provider.generateImage(context);
                      },
              child: Text(
                provider.isLoading ? "Generating..." : "Generate Image",
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 16),

            ///... is called the spread operator in Dart, and it's used to insert the elements of a list  into another list or collection.
            if (provider.imageBytes != null) ...[
              Image.memory(provider.imageBytes!, height: 300),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      provider.clearData();
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text("Clear Image")));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                    ),
                    label: Text(
                      'Clear Image',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ElevatedButton.icon(
                    icon: Icon(Icons.download, color: Colors.white),
                    label: Text(
                      'Download',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                    ),
                    onPressed: () async {
                      await provider.saveImageToGallery(provider.imageBytes!);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Image saved to gallery")),
                      );
                    },
                  ),
                ],
              ),
            ] else if (_isVideoSupported &&
                _videoPlayerController != null &&
                _videoPlayerController!.value.isInitialized)
              AspectRatio(
                aspectRatio: _videoPlayerController!.value.aspectRatio,
                child: VideoPlayer(_videoPlayerController!),
              )
            else
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Image.asset(
                    'assets/images/deepseekLogo.png',
                    height: 200,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
