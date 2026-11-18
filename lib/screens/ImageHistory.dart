import 'dart:io';
import 'package:deepseek/provider/image_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ImageHistory extends StatefulWidget {
  const ImageHistory({super.key});

  @override
  State<ImageHistory> createState() => _ImageHistoryState();
}

class _ImageHistoryState extends State<ImageHistory> {
  ///Wrap your call in a WidgetsBinding.instance.addPostFrameCallback block so it runs after the current frame is built
  @override
  void initState() {
    super.initState();
    //addPostFrameCallback ensures loadImageHistory() is called after the widget tree is fully built so that context is safe to use.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Delays execution until after first frame, ensuring context is ready
      final provider = Provider.of<ImageGeneratorProvider>(
        context,
        listen: false,
      );
      provider.loadImageHistory(); // Triggers notifyListeners() immediately
    });
  }

  Future<void> _deleteImage(
    BuildContext context,
    String path,
    int index,
  ) async {
    final file = File(path);
    if (await file.exists()) {
      await file.delete(); // delete file from storage .
    }
    ///This controls whether the widget should rebuild when the provider notifies its listeners using notifyListeners()
    final provider = Provider.of<ImageGeneratorProvider>(
      context,
      listen: false,
    );
    provider.imagesHistory.removeAt(index); // remove only tapped image
    provider.notifyListeners(); // Notify the UI to rebuild with updated list
    // await provider.loadImageHistory(); // reload DB-backed list
    // setState(() {}); // rebuild UI
  }

  Future<void> _clearAllHistory(BuildContext context) async {
    final provider = Provider.of<ImageGeneratorProvider>(
      context,
      listen: false,
    );

    // Delete each image file
    for (final image in provider.imagesHistory) {
      final file = File(image['path']!);
      if (await file.exists()) {
        await file.delete();
      }
    }
    // Clear from database
    await provider.clearImageHistory(); // add this in provider below
    await provider.loadImageHistory();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ImageGeneratorProvider>(context);
    final history = provider.imagesHistory;

    return Scaffold(
      appBar: AppBar(
        title: Text('Image History'),
        actions: [
          IconButton(
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: const Text('Clear All History ?'),
                      content: const Text('This will delete all saved images'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text("Cancel"),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: Text("Delete All"),
                        ),
                      ],
                    ),
              );
              if (confirm == true) {
                await _clearAllHistory(context);
              }
            },
            icon: Icon(Icons.delete_forever),
          ),
        ],
        backgroundColor: Colors.teal,
      ),
      // body: ListView.builder(
      //   itemCount: history.length,
      //   itemBuilder: (context, index) {
      //     final image = history[index];
      //     return provider.isLoading
      //         ? Center(child: CircularProgressIndicator())
      //         : ListTile(
      //           title: Text(image['name'] ?? 'unnamed'),
      //           trailing:
      //               File(image['path']!).existsSync()
      //                   ? Image.file(
      //                     File(image['path']!),
      //                     width: 50,
      //                     height: 50,
      //                     fit: BoxFit.cover,
      //                   )
      //                   : const Icon(Icons.image_not_supported),
      //           onTap: () {
      //             showDialog(
      //               context: context,
      //               builder: (context) {
      //                 return Dialog(
      //                   child:
      //                       File(image['path']!).existsSync()
      //                           ? Image.file(File(image['path']!))
      //                           : const Padding(
      //                             padding: EdgeInsets.all(16.0),
      //                             child: Text('Image file not available'),
      //                           ),
      //                 );
      //               },
      //             );
      //           },
      //         );
      //   },
      // ),
      body:
          provider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : history.isEmpty
              ? const Center(child: Text('No images found'))
              : ListView.builder(
                itemCount: history.length,
                itemBuilder: (context, index) {
                  final image = history[index];
                  final filePath = image['path']!;
                  final file = File(filePath);
                  print(file);

                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ListTile(
                      title: Text(image['name'] ?? 'Unnamed'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          file.existsSync()
                              ? Image.file(
                                file,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              )
                              : const Icon(Icons.image_not_supported),
                          IconButton(
                            onPressed:
                                () => _deleteImage(
                                  context,
                                  image['path']!,
                                  index,
                                ),
                            icon: const Icon(Icons.delete, color: Colors.red),
                          ),
                        ],
                      ),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              child:
                                  file.existsSync()
                                      ? Image.file(file)
                                      : const Padding(
                                        padding: EdgeInsets.all(16.0),
                                        child: Text('Image file not available'),
                                      ),
                            );
                          },
                        );
                      },
                    ),
                  );
                },
              ),
    );
  }
}
