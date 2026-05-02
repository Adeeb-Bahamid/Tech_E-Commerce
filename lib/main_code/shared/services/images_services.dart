import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ImagesServices {
  Future<String?> uploadImage() async {
    String? imageUrl;
    final picker = ImagePicker();
    final XFile? file = await picker.pickImage(source: ImageSource.gallery);

    if (file == null) return null;

    Uint8List bytes = await file.readAsBytes();

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://api.cloudinary.com/v1_1/df1pbuqjn/image/upload'),
    );

    request.fields['upload_preset'] = 'df1pbuqjn';

    request.files.add(
      http.MultipartFile.fromBytes(
        'file',
        bytes,
        filename: file.name,
      ),
    );

    var response = await request.send();
    var responseData = await response.stream.bytesToString();

    final data = json.decode(responseData);

    imageUrl = data['secure_url'];
    return imageUrl;
  }
}
