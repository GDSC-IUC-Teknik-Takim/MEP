import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mep/app/views/report/create_report/report_succesful.dart';

class CreateReport extends StatefulWidget {
  @override
  State<CreateReport> createState() => _CreateReportState();

}
TextEditingController fullNameController = new TextEditingController();

class _CreateReportState extends State<CreateReport> {



  List<CustomTextFormFieldClass> textFormFieldItems = [
    CustomTextFormFieldClass(label: "Location", icon: Icons.location_on_outlined, controller: fullNameController),
    CustomTextFormFieldClass(label: "Details", icon: Icons.info_outline, controller: fullNameController),
  ];


  String? _selectedPollutionType;
  String? _selectedMuniplicty;
  File? _imageFile;
  final List<String> _pollutionTypes = [
    'Air Pollution',
    'Water Pollution',
    'Land Pollution'
  ];
  final List<String> _MuniplicityList = ['Kadikoy', 'Avcilar', 'Kucukcekmece'];
  Future<void> _getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _imageFile = File(pickedFile!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text("Create a report"),),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Create a Report",
                textScaleFactor: 2.5,
              ),
              Text(
                "Create your new account",
                textScaleFactor: 1.0,
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(height: 40.0),
              reporttitle(),
              SizedBox(height: 20.0),
              DropdownButtonFormField<String>(
                value: _selectedMuniplicty,
                items: _MuniplicityList.map((String type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  _selectedMuniplicty = newValue;
                },
                decoration: InputDecoration(
                  labelText: 'Municipality',
                  prefixIcon: Icon(Icons.add_business_outlined),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0)),
                  filled: true,
                  fillColor: Colors.grey[250],
                ),
              ),
              SizedBox(height: 20.0),
              DropdownButtonFormField<String>(
                value: _selectedPollutionType,
                items: _pollutionTypes.map((String type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  _selectedPollutionType = newValue;
                },
                decoration: InputDecoration(
                  labelText: 'Pollution Type',
                  prefixIcon: Icon(Icons.eco_outlined),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0)),
                  filled: true,
                  fillColor: Colors.grey[250],
                ),
              ),
              SizedBox(height: 20,),
              LocationBar(),
              SizedBox(height: 20,),
              DetailBar(),
              SizedBox(height: 20,),
              GestureDetector(
                onTap: _getImage,
                child: Container(
                  width: double.infinity,
                  height: 100,
                  color: Colors.grey[200],
                  child: _imageFile != null
                      ? Image.file(
                          _imageFile!,
                          fit: BoxFit.cover,
                        )
                      : Center(
                          child: Text(
                            'Add an Image',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                ),
              ),
              SizedBox(height: 40.0),
              SignUpButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomTextFormFieldClass {
  final String label;
  IconData? icon;
  TextEditingController controller;
  CustomTextFormFieldClass({required this.label, this.icon, required this.controller});

}

class SignUpButton extends StatelessWidget {
  const SignUpButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ReportSuccesful()),
        );
      },
      style: ElevatedButton.styleFrom(
          backgroundColor: Color.fromRGBO(50, 90, 62, 100),
          fixedSize: Size(300, 10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Complete report',
            textScaleFactor: 1.2,
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class DetailBar extends StatelessWidget {
  const DetailBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.info_outline),
        labelText: 'Details',
        border: OutlineInputBorder(
          borderSide: BorderSide(style: BorderStyle.none),
          borderRadius: BorderRadius.circular(12.0),
        ),
        filled: true,
        fillColor: Colors.grey[250],
      ),
    );
  }
}

class LocationBar extends StatelessWidget {
  const LocationBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.location_on_outlined),
        labelText: 'Location',
        border: OutlineInputBorder(
          borderSide: BorderSide(style: BorderStyle.none),
          borderRadius: BorderRadius.circular(12.0),
        ),
        filled: true,
        fillColor: Colors.grey[250],
      ),
    );
  }
}

class reporttitle extends StatelessWidget {
  const reporttitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.edit),
        labelText: 'Report title',
        border: OutlineInputBorder(
          borderSide: BorderSide(style: BorderStyle.none),
          borderRadius: BorderRadius.circular(12.0),
        ),
        filled: true,
        fillColor: Colors.grey[250],
      ),
    );
  }
}

