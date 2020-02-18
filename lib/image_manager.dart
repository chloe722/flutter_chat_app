import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;

//0 = Chat, 1 = Profile

enum ImageType{CHAT, PROFILE}

Future<dynamic> getImage(ImageType type) async {
  var image = await ImagePicker.pickImage(source: ImageSource.gallery);
  if (image != null) {
    var url;
    if(type == ImageType.CHAT) {
      url = await uploadChatFile(image);
    } else if (type == ImageType.PROFILE) {
      url = await uploadProfileFile(image);
    }
    print('return image: $url');
    return url;
  } else {
    print('Uploaded failed');
  }
}


//TODO maybe refactor
Future<dynamic> uploadChatFile(File image) async {
  StorageReference storageReference = FirebaseStorage.instance
      .ref()
      .child('chats/${Path.basename(image.path)}');
  StorageUploadTask uploadTask = storageReference.putFile(image);
  await uploadTask.onComplete;
  var url = await storageReference.getDownloadURL();
  return url;
}

Future<dynamic> uploadProfileFile(File image) async {
  StorageReference storageReference = FirebaseStorage.instance
      .ref()
      .child('profiles/${Path.basename(image.path)}');
  StorageUploadTask uploadTask = storageReference.putFile(image);
  await uploadTask.onComplete;
  var url = await storageReference.getDownloadURL();
  return url;
}