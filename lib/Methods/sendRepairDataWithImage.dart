import 'dart:async';
import 'package:http/http.dart' as http;

class SendRepairDataWithImage {
  static Future<void> sendRepairDataWithImage(
    String customer,
    String receiver,
    String phoneNumber,
    String watchBrand,
    String watchModel,
    String watchBand,
    String operation,
    String imagePath,
  ) async {
    print('Sending repair data:');
    print('Customer: $customer');
    print('Receiver: $receiver');
    print('Phone Number: $phoneNumber');
    print('Watch Brand: $watchBrand');
    print('Watch Model: $watchModel');
    print('Watch Band: $watchBand');
    print('Operation: $operation');
    print('Selected Image Path: $imagePath');

    // Replace with your backend URL
    var url = Uri.parse(
        'https://avukatraziyegulacaracikyurek.com/backend/addRepair.php');

    if (imagePath != '') {
      try {
        var response = await http.post(
          url,
          body: {
            'name_customer': customer,
            'name_receiver': receiver,
            'watch_brand': watchBrand,
            'watch_model': watchModel,
            'watch_band': watchBand,
            'operation': operation,
            'phone_number': phoneNumber,
            'code': 'default',
            'note': 'Your repair note',
            'watch_photo': imagePath, // Send the image path to 'watch_photo'
          },
        );

        if (response.statusCode == 200) {
          var responseData = response.body;
          print('Response: $responseData');
        } else {
          print('Failed to upload data: ${response.reasonPhrase}');
        }
      } catch (error) {
        print('Error uploading data: $error');
      }
    }
  }
}
