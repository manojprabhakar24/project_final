import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/service_list.dart';
import '../../models/store.dart';
import '../../models/utils.dart';

class ServiceForm extends StatefulWidget {
  final Function(Services) addServiceToListScreen; // Function reference

  ServiceForm({Key? key, required this.addServiceToListScreen})
      : super(key: key);

  @override
  State<ServiceForm> createState() => _ServiceFormState();
}

class _ServiceFormState extends State<ServiceForm> {

  TextEditingController _priceController = TextEditingController();
  Uint8List? _image;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  void saveProfile() async {
    if (_image == null) {
      // If image is not added, show an error SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please add an image.'),
          duration: Duration(seconds: 2),
        ),
      );
      return; // Stop further execution of the method
    }

    String name = nameController.text;
    String bio = bioController.text;
    String price = _priceController.text;

    // Check if any of the fields are empty
    if (name.isEmpty || bio.isEmpty || price.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill in all fields.'),
          duration: Duration(seconds: 2),
        ),
      );
      return; // Stop further execution if any field is empty
    }

    // Assuming StoreData() is a hypothetical class that saves data asynchronously
    String resp = await StoreData().saveData(
      name: name,
      bio: bio,
      price: price,
      file: _image!,
    );

    if (resp == 'success') {
      // If saving is successful, show a success SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Data saved successfully!'),
          duration: Duration(seconds: 2),
        ),
      );
      nameController.clear();
      bioController.clear();
      _priceController.clear();
      setState(() {
        _image = null; // Clear the stored image
      });
    }
  }
  Future<void> deleteDataByName(String nameToDelete) async {
    CollectionReference services = FirebaseFirestore.instance.collection('userProfile');

    try {
      QuerySnapshot querySnapshot =
      await services.where('name', isEqualTo: nameToDelete).get();

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        await doc.reference.delete();
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('The Service $nameToDelete deleted successfully!'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      print('Error deleting data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete data. Please try again.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }


  void openModalBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        TextEditingController deleteNameController = TextEditingController();

        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextField(
                controller: deleteNameController,
                decoration: InputDecoration(
                  hintText: 'Enter Name to Delete',
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  String nameToDelete = deleteNameController.text;
                  deleteDataByName(nameToDelete); // Call your delete method here
                  Navigator.pop(context); // Close the bottom sheet after deletion
                },
                child: Text('Delete'),
              ),
            ],
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 32,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 24,
              ),
              Stack(
                children: [
                  _image != null
                      ? CircleAvatar(
                    radius: 64,
                    backgroundImage: MemoryImage(_image!),
                  )
                      : const CircleAvatar(
                    radius: 64,
                    backgroundImage: NetworkImage(
                        'https://th.bing.com/th?id=OIP.7G6XwS4BzQWHQl-VoyvCFgHaHa&w=250&h=250&c=8&rs=1&qlt=90&o=6&pid=3.1&rm=2'),
                  ),
                  Positioned(
                    bottom: -10,
                    left: 90,
                    child: IconButton(
                      onPressed: selectImage,
                      icon: const Icon(Icons.add_a_photo),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 24,
              ),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  hintText: 'Enter Name',
                  contentPadding: EdgeInsets.all(10),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              TextField(
                controller: bioController,
                decoration: const InputDecoration(
                  hintText: 'Enter Description',
                  contentPadding: EdgeInsets.all(10),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              TextField(
                controller: _priceController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                decoration: const InputDecoration(
                  hintText: 'Enter price',
                  contentPadding: EdgeInsets.all(10),
                  border: OutlineInputBorder(),
                ),
              ),
              ElevatedButton(
                onPressed: saveProfile,
                child: const Text('Save Profile'),
              ),
    InkWell(
    onTap: openModalBottomSheet,
    child: Padding(
    padding: const EdgeInsets.all(8.0),
    child: Text(
    'Click here to delete data',
    style: TextStyle(
    decoration: TextDecoration.underline,
    color: Colors.blue,
    ),
    ),
    ),
    ),
    ]))));
  }
}
class ProfileForm extends StatefulWidget {
  const ProfileForm({Key? key}) : super(key: key);

  @override
  State<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  TextEditingController _profileNameController = TextEditingController();
  TextEditingController _expertiseController = TextEditingController();
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  Future getProfileImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Add Profile Form',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              GestureDetector(
                onTap: getProfileImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _profileImage != null
                      ? FileImage(_profileImage!) as ImageProvider<Object>?
                      : AssetImage('assets/profile.png'),
                ),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: getProfileImage,
                child: Text('Add Photo'),
              ),
            ],
          ),
          SizedBox(height: 5),
          TextField(
            controller: _profileNameController,
            decoration: InputDecoration(labelText: 'Profile Name'),
          ),
          SizedBox(height: 5),
          TextField(
            controller: _expertiseController,
            decoration: InputDecoration(labelText: 'Expertise'),
          ),
          SizedBox(height: 5),
          ElevatedButton(
            onPressed: () {

              _profileNameController.clear();
              _expertiseController.clear();
              setState(() {
              });
            },
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }
}

class PriceUpdateForm extends StatefulWidget {
  final TextEditingController oldPriceController;
  final TextEditingController newPriceController1;
  final TextEditingController confirmPriceController2;

  const PriceUpdateForm({
    Key? key,
    required this.oldPriceController,
    required this.newPriceController1,
    required this.confirmPriceController2,
  }) : super(key: key);

  @override
  State<PriceUpdateForm> createState() => _PriceUpdateFormState();
}

class _PriceUpdateFormState extends State<PriceUpdateForm> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Update Price Form',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),
          TextField(
            controller: widget.oldPriceController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Old Price'),
          ),
          SizedBox(height: 5),
          TextField(
            controller: widget.newPriceController1,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'New Price'),
          ),
          SizedBox(height: 5),
          TextField(
            controller: widget.confirmPriceController2,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Confirm Price'),
          ),
          SizedBox(height: 5),

// Your existing PriceUpdateForm code...

          ElevatedButton(
            onPressed: () async {
              double oldPrice =
                  double.tryParse(widget.oldPriceController.text) ?? 0.0;
              double newPrice1 =
                  double.tryParse(widget.newPriceController1.text) ?? 0.0;
              double newPrice2 =
                  double.tryParse(widget.confirmPriceController2.text) ?? 0.0;

              // Use 'oldPrice', 'newPrice1', and 'newPrice2' as needed for your logic

              // Update Firestore document here
              try {
                // Replace 'yourCollection' and 'yourDocumentId' with your Firestorm collection and document IDs
                await FirebaseFirestore.instance
                    .collection('services')
                    .doc('yourDocumentId')
                    .update({
                  'oldPrice': oldPrice,
                  'newPrice1': newPrice1,
                  'newPrice2': newPrice2,
                  // Add other fields as necessary
                });

                // Reset the form after successful submission
                widget.oldPriceController.clear();
                widget.newPriceController1.clear();
                widget.confirmPriceController2.clear();

                // Show a success message or perform any additional actions
              } catch (e) {
                // Handle errors, show an error message, or perform fallback actions
                print('Error updating prices: $e');
              }
            },
            child: Text('Update Price'),
          ),
        ],
      ),
    );
  }
}