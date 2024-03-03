import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:_24saat/Methods/getImageWidth.dart';
import 'package:_24saat/Pages/LastWatches.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import '../Methods/saveImageToDevice.dart';
import '../Methods/sendRepairDataWithImage.dart';
import '../Methods/handleImageSelection.dart';

class AddRepairPage extends StatefulWidget {
  @override
  _AddRepairPageState createState() => _AddRepairPageState();
}

class _AddRepairPageState extends State<AddRepairPage> {
  late HandleImageSelection _handleImageSelectionw;
  File? _selectedImage; // Store the selected image as a File

  Future<String?> _handleImageSelection() async {
    if (_selectedImage == null) {
      String imagePath = await _handleImageSelectionw.handleImageSelection();
      if (imagePath.isNotEmpty) {
        setState(() {
          _selectedImage = File(imagePath);
        });
      }
    }
    return _selectedImage?.path;
  }

  TextEditingController watchBrandController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  TextEditingController watchModelController = TextEditingController();
  TextEditingController watchBandController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  String lastStatusController = "Teslim Alindi";
  TextEditingController operationController = TextEditingController();
  TextEditingController customerController = TextEditingController();
  TextEditingController receiverController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _handleImageSelectionw =
        HandleImageSelection(context, onImageSelected: _updateSelectedImage);
  }

  void _updateSelectedImage(String imagePath) {
    setState(() {
      _selectedImage = File(imagePath);
    });
  }

  List<Widget> noteTextFields = []; // Store the dynamically created TextFields

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
                onTap: () async {
                  String? imagePath = await _handleImageSelection();
                  // Check imagePath for nullability and use it if needed
                },
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
                            future: GetImageWidth.getImageWidth(_selectedImage),
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
                controller: customerController,
                decoration: InputDecoration(labelText: 'Müşteri Adı'),
              ),
              TextField(
                controller: phoneNumberController,
                decoration: InputDecoration(labelText: 'İletişim'),
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
        onPressed: () async {
          if (_selectedImage != null) {
            String imagePath = _selectedImage!.path;
            SendRepairDataWithImage.sendRepairDataWithImage(
              customerController.text,
              receiverController.text,
              phoneNumberController.text,
              watchBrandController.text,
              watchModelController.text,
              watchBandController.text,
              operationController.text,
              imagePath,
            ).then((_) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => RepairDetailsPage(),
                ),
              );
            }).catchError((error) {});
          } else {
            // Handle case where no image is selected
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
