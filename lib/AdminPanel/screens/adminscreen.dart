
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ServiceForm extends StatefulWidget {
  const ServiceForm({Key? key}) : super(key: key);

  @override
  State<ServiceForm> createState() => _ServiceFormState();
}

class _ServiceFormState extends State<ServiceForm> {
  TextEditingController _serviceNameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
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
            'Add Service Form',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),
          Row(
            children: [
              GestureDetector(
                onTap: getImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _image != null
                      ? FileImage(_image!) as ImageProvider<Object>?
                      : AssetImage('assets/profile.png'),
                ),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: getImage,
                child: Text('Add Photo'),
              ),
            ],
          ),
          SizedBox(height: 5),
          TextField(
            controller: _serviceNameController,
            decoration: InputDecoration(labelText: 'Service Name'),
          ),
          SizedBox(height: 5),
          TextField(
            controller: _descriptionController,
            maxLines: 3,
            decoration: InputDecoration(labelText: 'Service Description'),
          ),
          SizedBox(height: 5),
          TextField(
            controller: _priceController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Service Price'),
          ),
          SizedBox(height: 5),
          ElevatedButton(
            onPressed: () {
              // Handle form submission here
              String serviceName = _serviceNameController.text;
              String serviceDescription = _descriptionController.text;
              double servicePrice =
                  double.tryParse(_priceController.text) ?? 0.0;

              // Use 'serviceName', 'serviceDescription', 'servicePrice', and '_image' as needed for your logic

              // Reset the form after submission
              _serviceNameController.clear();
              _descriptionController.clear();
              _priceController.clear();
              setState(() {
                _image = null;
              });
            },
            child: Text('Submit'),
          ),
        ],
      ),
    );
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
              // Handle profile form submission here
              String profileName = _profileNameController.text;
              String expertise = _expertiseController.text;

              // Use 'profileName', 'expertise', and '_profileImage' as needed for your logic

              // Reset the form after submission
              _profileNameController.clear();
              _expertiseController.clear();
              setState(() {
                _profileImage = null;
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
          ElevatedButton(
            onPressed: () {
              // Handle price update form submission here
              double oldPrice =
                  double.tryParse(widget.oldPriceController.text) ?? 0.0;
              double newPrice1 =
                  double.tryParse(widget.newPriceController1.text) ?? 0.0;
              double newPrice2 =
                  double.tryParse(widget.confirmPriceController2.text) ?? 0.0;

              // Use 'oldPrice', 'newPrice1', and 'newPrice2' as needed for your logic

              // Reset the form after submission
              widget.oldPriceController.clear();
              widget.newPriceController1.clear();
              widget.confirmPriceController2.clear();
            },
            child: Text('Update Price'),
          ),
        ],
      ),
    );
  }
}