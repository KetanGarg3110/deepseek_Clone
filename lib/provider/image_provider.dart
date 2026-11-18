import 'dart:io';
import 'package:deepseek/db_helper/image_db.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:media_store_plus/media_store_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../services/image_service.dart';

class ImageGeneratorProvider extends ChangeNotifier {
  final TextEditingController controller = TextEditingController();
  Uint8List? imageBytes;
  bool isLoading = false;
  bool historyLoading = false;
  String? errorMessage;
  List<Map<String, String>> imagesHistory = [];

  Future<void> loadImageHistory() async {
    setLoading(true);
    final data = await ImageDatabase.getAllImages();
    imagesHistory =
        data
            .map(
              (row) => {
                'name': row['name'] as String,
                'path': row['path'] as String,
              },
            )
            .toList();
    setLoading(false);
  }

  Future<void> clearImageHistory() async {
    await ImageDatabase.clearAllImages();
    imagesHistory.clear();
    notifyListeners();
  }

  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  void clearData() {
    controller.clear();
    imageBytes = null;
    notifyListeners();
  }

  Future<void> generateImage(BuildContext context) async {
    final prompt = controller.text.trim();
    if (prompt.isEmpty) return;

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final result = await ImageService.generateImage(prompt);
    print(result);
    imageBytes = result;
    isLoading = false;
    notifyListeners();
  }

  ///our saveImageToGallery function currently saves an image file to the app's internal documents directory,
  /// which is useful for persistent storage within the app, but it doesn’t actually save the image to the device’s gallery (photos app)
  Future<void> saveImageToGallery(Uint8List bytes) async {
    final fileName = 'image_${DateTime.now().millisecondsSinceEpoch}.png';
    final dir =
        await getApplicationDocumentsDirectory(); // apps internal storage
    final filePath = '${dir.path}/$fileName';
    final file = await File(filePath).writeAsBytes(bytes);
    print('Image saved: $filePath');
  }

  /// this function save an image either to android gallery using media_store_plus or to the app's private directory on the other platform like desktop or ios .

  Future<void> saveImage(Uint8List bytes) async {
    if (Platform.isAndroid) {
      // Initialize MediaStore
      await MediaStore.ensureInitialized();
      // Set the app folder (this is required) name under DCIM or Pictures in the Android gallery to organize saved media .
      MediaStore.appFolder = 'DeepSeek';

      // Step 1: Request  correct Permissions
      final androidInfo = await Permission.photos.status;
      if (!androidInfo.isGranted) {
        final result = await Permission.storage.request();
        if (!result.isGranted) {
          throw Exception('Photo media permission not granted');
        }
      }
      // Step 2: Save bytes to a temporary file
      // final tempDir = await getTemporaryDirectory();
      // final filePath = '${tempDir.path}/temp_image_${DateTime.now().millisecondsSinceEpoch}.png';
      // final file = await File(filePath).writeAsBytes(bytes);

      // Step 3: Use media_store_plus to move it to gallery

      ///Update saveImageToGallery() to save image in app directory directly and avoid using MediaStore, unless gallery access is critical.
      final dir =
          await getApplicationDocumentsDirectory(); // app private folder
      final filePath =
          '${dir.path}/image_${DateTime.now().millisecondsSinceEpoch}.png';
      // ✅ Write the actual image bytes to this file
      final file = await File(filePath).writeAsBytes(bytes);

      // Save using file to gallery via MediaStore
      //Moves the temporary file to the Android DCIM folder (gallery) using media_store_plus.
      final mediaStore = MediaStore();
      await mediaStore.saveFile(
        tempFilePath: file.path,
        dirName: DirName.dcim,
        dirType: DirType.photo,
      );
      print('Image saved to: $filePath');
      print('File exists: ${file.existsSync()}');

      //Save the image metadata (file name ,size,dimensions )in the database
      await ImageDatabase.insertImage(
        'Image ${imagesHistory.length + 1}',
        filePath,
      );
      await loadImageHistory(); // refresh List
      notifyListeners();
    } else {
      final dir = await getApplicationDocumentsDirectory();
      final filePath =
          '${dir.path}/image_${DateTime.now().millisecondsSinceEpoch}.png';
      // ✅ Write the actual image bytes to this file
      final file = await File(filePath).writeAsBytes(bytes);
      print('✅ Image saved on Desktop/iOS: $filePath');
    }
  }
}
