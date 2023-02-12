import 'dart:io';

import 'package:image_picker/image_picker.dart';

class ImageHelper{
  
   static Future<File?> tackPhoto(ImageSource imageSource) async {
  final picker = ImagePicker();
    final XFile? pickedImage = await picker.pickImage(source: imageSource);
    if (pickedImage != null) {
    
        return File(pickedImage.path);
     
    }
    return null;
  }
}