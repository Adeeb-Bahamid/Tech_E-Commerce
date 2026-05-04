import 'dart:convert';
import 'dart:typed_data';
import 'package:cloudinary_url_gen/cloudinary.dart';
import 'package:cloudinary_url_gen/transformation/delivery/delivery.dart';
import 'package:cloudinary_url_gen/transformation/delivery/delivery_actions.dart';
import 'package:cloudinary_url_gen/transformation/resize/resize.dart';
import 'package:cloudinary_url_gen/transformation/transformation.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ImagesServices {
  final Cloudinary cloudinary =
      Cloudinary.fromCloudName(cloudName: 'df1pbuqjn');
      
  String image(String publicId) {
    return cloudinary
        .image(publicId)
        .transformation(Transformation()
            .resize(Resize.scale().width(300))
            .delivery(Delivery.quality(Quality.auto()))
            .delivery(Delivery.format(Format.auto)))
        .toString();
  }

  Future<Map<String, String>?> uploadImage() async {
    Map<String, String> imageUrl;
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

    imageUrl = {
      'secure_url': data['secure_url'],
      'public_id': data['public_id']
    };
    return imageUrl;
  }
}
