import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';

void sendRepairDataWithImage() async {
  // Replace with your backend URL
  var url = Uri.parse('http://your_backend_url/add_repair.php');

  // Retrieve the image using ImagePicker
  final ImagePicker _picker = ImagePicker();
  XFile? image = await _picker.pickImage(source: ImageSource.gallery);

  if (image != null) {
    // Convert the image to bytes (Uint8List)
    List<int> imageBytes = await image.readAsBytes();
    String base64Image = base64Encode(imageBytes);

    // Replace these fields with your repair data
    Map<String, String> data = {
      'watch_brand': 'Your watch brand',
      'code': 'Your code',
      // Add other repair fields here
      'note':
          'Your repair note', // Assuming 'note' is one of the repair data fields
    };

    // Add the image to the data as a base64 string
    data['image'] = base64Image;

    // Create a multipart request
    var request = http.MultipartRequest('POST', url);

    // Add repair data fields to the request
    data.forEach((key, value) {
      request.fields[key] = value;
    });

    // Attach the image to the request
    request.files.add(http.MultipartFile.fromString(
      'image',
      base64Image,
      filename: 'repair_image.jpg',
    ));

    // Send the request
    var response = await request.send();

    // Handle the response
    if (response.statusCode == 200) {
      print('Image and data uploaded successfully');
    } else {
      print('Failed to upload image and data');
    }
  }
}

class AddRepairPage extends StatefulWidget {
  @override
  _AddRepairPageState createState() => _AddRepairPageState();
}

class _AddRepairPageState extends State<AddRepairPage> {
  TextEditingController watchBrandController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  TextEditingController watchModelController = TextEditingController();
  TextEditingController watchBandController = TextEditingController();
  String lastStatusController = "Teslim Alındı";
  TextEditingController operationController = TextEditingController();
  TextEditingController customerController = TextEditingController();
  TextEditingController receiverController = TextEditingController();

  File? _selectedImage; // Store the selected image as a File

  List<Widget> noteTextFields = []; // Store the dynamically created TextFields

  void _handleImageSelection() async {
    final ImagePicker _picker = ImagePicker();
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path); // Store the selected image as a File
      });
    }
  }

  void _addNoteTextField() {
    setState(() {
      int textFieldCount = noteTextFields.length + 1;

      noteTextFields.add(
        Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(labelText: 'Not $textFieldCount'),
              ),
            ),
            IconButton(
              icon: Icon(Icons.remove),
              onPressed: () {
                setState(() {
                  noteTextFields.removeLast();
                });
              },
            ),
          ],
        ),
      );
    });
  }

  Future<int?> getImageWidth(File? image) async {
    if (image != null) {
      final Completer<ui.Image> completer = Completer();
      final data = await image.readAsBytes();
      ui.decodeImageFromList(Uint8List.fromList(data), (result) {
        completer.complete(result);
      });
      final img = await completer.future;
      return img.width;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saat Ekle'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              InkWell(
                onTap: _handleImageSelection,
                child: Container(
                  height: 180,
                  width: 180,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.grey[300],
                  ),
                  child: Center(
                    child: _selectedImage != null
                        ? FutureBuilder<int?>(
                            future: getImageWidth(_selectedImage),
                            builder: (BuildContext context,
                                AsyncSnapshot<int?> snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text('Error loading image');
                              } else if (!snapshot.hasData ||
                                  snapshot.data == null) {
                                return Text('Image height unavailable');
                              } else {
                                return Image.file(
                                  _selectedImage!, // Use the selected image as File
                                  fit: BoxFit.cover,
                                  height: snapshot.data!.toDouble(),
                                );
                              }
                            },
                          )
                        : Icon(
                            Icons.add,
                            size: 48.0,
                            color: Colors.grey[600],
                          ),
                  ),
                ),
              ),

              SizedBox(height: 20.0),
              TextField(
                controller: watchBrandController,
                decoration: InputDecoration(labelText: 'Müşteri Adı'),
              ),
              TextField(
                controller: receiverController,
                decoration: InputDecoration(labelText: 'Teslim Alan'),
              ),
              TextField(
                controller: watchBrandController,
                decoration: InputDecoration(labelText: 'Saat Markası'),
              ),
              TextField(
                controller: watchModelController,
                decoration: InputDecoration(labelText: 'Saat Modeli'),
              ),
              TextField(
                controller: watchBandController,
                decoration: InputDecoration(labelText: 'Kordon Tipi'),
              ),
              TextField(
                controller: operationController,
                decoration: InputDecoration(labelText: 'İşlem'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addNoteTextField,
                child: Text("Not Ekle"),
              ),
              // Display dynamically added TextFields
              Column(
                children: noteTextFields,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        onPressed: () {
          // Handle action when FloatingActionButton is pressed
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
