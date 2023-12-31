import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';


class StoreData {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<String> uploadImageToStorage(
      String folderName, String imageName, Uint8List file) async {
    Reference ref = _storage.ref().child(folderName).child(imageName);
    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<String> saveStylistData({
    required String stylistName,
    required String expertise,
    required Uint8List file,
  }) async {
    String resp = "Some Error Occurred";
    try {
      if (stylistName.isNotEmpty || expertise.isNotEmpty) {
        String imageUrl = await uploadImageToStorage(
          'stylistImages',
          stylistName,
          file,
        );
        await _firestore.collection('stylistProfile').add({
          'stylistName': stylistName,
          'expertise': expertise,
          'imageLink': imageUrl,
        });

        resp = 'success';
      }
    } catch (err) {
      resp = err.toString();
    }
    return resp;
  }


  Future<String> saveData({
    required String name,
    required String bio,
    required Uint8List file,
    required String price,
  }) async {
    String resp = " Some Error Occurred";
    try {
      if (name.isNotEmpty || bio.isNotEmpty) {
        String imageUrl =
            await uploadImageToStorage('profileImages', name, file);
        await _firestore.collection('userProfile').add({
          'name': name,
          'bio': bio,
          'price': price,
          'imageLink': imageUrl,
        });

        resp = 'success';
      }
    } catch (err) {
      resp = err.toString();
    }
    return resp;
  }
}
