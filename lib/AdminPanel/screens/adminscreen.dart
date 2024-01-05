import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  TextEditingController deleteTextController = TextEditingController();

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
    CollectionReference services =
    FirebaseFirestore.instance.collection('userProfile');

    try {
      if (nameToDelete.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please enter text to delete.'),
            duration: Duration(seconds: 2),
          ),
        );
        return; // Stop execution if the text field is empty
      }

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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Container(

                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      Stack(
                        children: [
                          _image != null
                              ? CircleAvatar(
                                  radius: 40,
                                  backgroundImage: MemoryImage(_image!),
                                )
                              : const CircleAvatar(

                                  radius: 43,
                                     backgroundColor: Colors.brown,
                                  backgroundImage: NetworkImage(

                                      'https://th.bing.com/th?id=OIP.7G6XwS4BzQWHQl-VoyvCFgHaHa&w=250&h=250&c=8&rs=1&qlt=90&o=6&pid=3.1&rm=2',

                                  ),
                                ),
                          Positioned(
                            bottom: -10,
                            left: 52,
                            child: IconButton(
                              onPressed: selectImage,
                              icon: const Icon(Icons.add_a_photo,color: Colors.lightGreen,),
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
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d+\.?\d{0,2}')),
                        ],
                        decoration: const InputDecoration(
                          hintText: 'Enter price',
                          contentPadding: EdgeInsets.all(10),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        onPressed: saveProfile,
                        child: const Text('Save Profile'),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green, // Change the button color
                          onPrimary: Colors.white, // Change the text color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                8.0), // Round the button corners
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Center(
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Delete Stylist'),
                                      content: TextField(
                                        controller: deleteTextController,
                                        decoration: InputDecoration(
                                          labelText: 'Enter Stylist Name ',
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                      actions: <Widget>[
                                        ElevatedButton(
                                          onPressed: () {
                                            String textToDelete = deleteTextController.text;
                                            deleteDataByName(textToDelete);
                                            deleteTextController.clear(); // Clear the text field
                                            Navigator.of(context).pop(); // Close the dialog
                                          },
                                          child: Text('Delete'),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(context).pop(); // Close the dialog
                                          },
                                          child: Text('Cancel'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: Text(
                                'Delete Here',
                                style: TextStyle(
                                    color: Colors.red,
                                    decoration: TextDecoration.underline,fontWeight: FontWeight.bold
                                ),
                              ),
                            ),


                          ],
                        ),
                      ),
                    ]))));
  }
}





class StylistForm extends StatefulWidget {
  final Function(Services) addServiceToListScreen; // Function reference

  StylistForm({Key? key, required this.addServiceToListScreen})
      : super(key: key);

  @override
  _StylistFormState createState() => _StylistFormState();
}

class _StylistFormState extends State<StylistForm> {
  TextEditingController deleteTextController1 = TextEditingController();
  Uint8List? _image;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController expertiseController = TextEditingController();

  // ...
  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }
  void saveStylist() async {
    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please add an image.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    String stylistName = nameController.text;
    String expertise = expertiseController.text;

    if (stylistName.isEmpty || expertise.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill in all fields.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    String resp = await StoreData(). saveStylistData(
      stylistName: stylistName,
      expertise: expertise,
      file: _image!,
    );

    if (resp == 'success') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Stylist data saved successfully!'),
          duration: Duration(seconds: 2),
        ),
      );
      nameController.clear();
      expertiseController.clear();

      setState(() {
        _image = null;
      });
    }
  }
  Future<void> deleteDataByName1(String nameToDelete) async {
    CollectionReference services =
    FirebaseFirestore.instance.collection('stylistProfile');

    try {
      if (nameToDelete.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please enter text to delete.'),
            duration: Duration(seconds: 2),
          ),
        );
        return; // Stop execution if the text field is empty
      }

      QuerySnapshot querySnapshot =
      await services.where('stylistName', isEqualTo: nameToDelete).get();

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        await doc.reference.delete();
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('The Stylist $nameToDelete deleted successfully!'),
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
                            radius: 40,
                            backgroundImage: MemoryImage(_image!),
                          )
                              : const CircleAvatar(
                            backgroundColor: Colors.brown,
                            radius: 43,
                            backgroundImage: NetworkImage(
                                'https://th.bing.com/th?id=OIP.7G6XwS4BzQWHQl-VoyvCFgHaHa&w=250&h=250&c=8&rs=1&qlt=90&o=6&pid=3.1&rm=2'),
                          ),
                          Positioned(
                            bottom: -10,
                            left: 52,
                            child: IconButton(
                              onPressed: selectImage,
                              icon: const Icon(Icons.add_a_photo,color: Colors.lightGreen,),
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
                        controller: expertiseController,
                        decoration: const InputDecoration(
                          hintText: 'Enter Description',
                          contentPadding: EdgeInsets.all(10),
                          border: OutlineInputBorder(),
                        ),
                      ),


                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        onPressed: saveStylist,
                        child: const Text('Save Profile'),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green, // Change the button color
                          onPrimary: Colors.white, // Change the text color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                8.0), // Round the button corners
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Delete Stylist'),
                                      content: TextField(
                                        controller: deleteTextController1,
                                        decoration: InputDecoration(
                                          labelText: 'Enter Stylist Name ',
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                      actions: <Widget>[
                                        ElevatedButton(
                                          onPressed: () {
                                            String textToDelete = deleteTextController1.text;
                                            deleteDataByName1(textToDelete);
                                            deleteTextController1.clear(); // Clear the text field
                                            Navigator.of(context).pop(); // Close the dialog
                                          },
                                          child: Text('Delete'),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(context).pop(); // Close the dialog
                                          },
                                          child: Text('Cancel'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: Text(
                                'Delete Here',
                                style: TextStyle(
                                  color: Colors.red,
                                  decoration: TextDecoration.underline,fontWeight: FontWeight.bold
                                ),
                              ),
                            ),


                          ],
                        ),
                      ),
                    ]))));
  }
}


