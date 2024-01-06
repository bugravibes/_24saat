import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../Methods/saveImageToDevice.dart';

class HandleImageSelection {
  final ImagePicker _picker = ImagePicker();
  final ImageHelper _imageHelper = ImageHelper();
  final BuildContext context;
  final void Function(String) onImageSelected; // Callback function

  HandleImageSelection(this.context, {required this.onImageSelected});

  Future<String> handleImageSelection() async {
    XFile? image;

    var imagePath = await showModalBottomSheet<String>(
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
                  image = await _picker.pickImage(source: ImageSource.gallery);
                  if (image != null) {
                    String imagePath = image!.path;
                    if (imagePath != null) {
                      imagePath =
                          await _imageHelper.saveImageToDevice(imagePath);
                      onImageSelected(imagePath);
                      Navigator.pop(context, imagePath);
                    } else {
                      Navigator.pop(context, '');
                    }
                  } else {
                    Navigator.pop(context, '');
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Camera'),
                onTap: () async {
                  Navigator.pop(context);
                  image = await _picker.pickImage(source: ImageSource.camera);
                  if (image != null) {
                    String imagePath = image!.path;
                    if (imagePath != null) {
                      imagePath =
                          await _imageHelper.saveImageToDevice(imagePath);
                      onImageSelected(imagePath);
                      Navigator.pop(context, imagePath);
                    } else {
                      Navigator.pop(context, '');
                    }
                  } else {
                    Navigator.pop(context, '');
                  }
                },
              ),
            ],
          ),
        );
      },
    );

    return imagePath ?? '';
  }
}
