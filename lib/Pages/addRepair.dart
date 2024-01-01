import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:_24saat/Pages/LastWatches.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';

Future<void> sendRepairDataWithImage(
  String customer,
  String receiver,
  String phoneNumber,
  String watchBrand,
  String watchModel,
  String watchBand,
  String operation,
  File? image,
) async {
  print('Sending repair data:');
  print('Customer: $customer');
  print('Receiver: $receiver');
  print('Phone Number: $phoneNumber');
  print('Watch Brand: $watchBrand');
  print('Watch Model: $watchModel');
  print('Watch Band: $watchBand');
  print('Operation: $operation');
  print('Selected Image Path: ${image?.path}');
  // Replace with your backend URL
  var url = Uri.parse(
      'https://avukatraziyegulacaracikyurek.com/backend/addRepair.php');

  if (image != null) {
    // Create a multipart request
    var request = http.MultipartRequest('POST', url);

    // Add repair data fields to the request
    request.fields['name_customer'] = customer;
    request.fields['name_receiver'] = receiver;
    request.fields['watch_brand'] = watchBrand;
    request.fields['watch_model'] = watchModel;
    request.fields['watch_band'] = watchBand;
    request.fields['operation'] = operation;
    request.fields['phone_number'] = phoneNumber;
    request.fields['code'] = 'default';
    request.fields['note'] =
        'Your repair note'; // Assuming 'note' is one of the repair data fields

    // Attach the image to the request
    request.files.add(await http.MultipartFile.fromPath(
      'watch_photo',
      image.path, // File path of the image
      filename: 'repair_image.jpg', // Filename for the image
    ));

    try {
      var response = await http.Response.fromStream(await request.send());

      if (response.statusCode == 200) {
        var responseData = response.body;
        print('Response: $responseData');
      } else {
        print('Failed to upload image and data: ${response.reasonPhrase}');
      }
    } catch (error) {
      print('Error uploading data: $error');
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
  TextEditingController phoneNumberController = TextEditingController();
  String lastStatusController = "Teslim Alındı";
  TextEditingController operationController = TextEditingController();
  TextEditingController customerController = TextEditingController();
  TextEditingController receiverController = TextEditingController();

  File? _selectedImage; // Store the selected image as a File

  List<Widget> noteTextFields = []; // Store the dynamically created TextFields

  void _handleImageSelection() async {
    final ImagePicker _picker = ImagePicker();

    // Show options to pick image from gallery or take a new picture
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Photo Library'),
                onTap: () async {
                  Navigator.pop(context);
                  XFile? image =
                      await _picker.pickImage(source: ImageSource.gallery);
                  if (image != null) {
                    setState(() {
                      _selectedImage = File(
                          image.path); // Store the selected image as a File
                    });
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Camera'),
                onTap: () async {
                  Navigator.pop(context);
                  XFile? image =
                      await _picker.pickImage(source: ImageSource.camera);
                  if (image != null) {
                    setState(() {
                      _selectedImage = File(
                          image.path); // Store the selected image as a File
                    });
                  }
                },
              ),
            ],
          ),
        );
      },
    );
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
        onPressed: () {
          sendRepairDataWithImage(
                  customerController.text,
                  receiverController.text,
                  phoneNumberController.text,
                  watchBrandController.text,
                  watchModelController.text,
                  watchBandController.text,
                  operationController.text,
                  _selectedImage)
              .then((_) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => RepairDetailsPage(),
              ),
            );
          }).catchError((error) {});
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
