import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'dart:io';
import 'package:mep/app/data/models/report_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'dart:convert';

import '../my_reports/my_reports_page.dart';
import 'package:mep/app/views/report/create_report/report_succesful.dart';

class CreateReport extends StatefulWidget {
  final String? adress;
  final LatLng? geopoint;

  const CreateReport({super.key, this.adress, this.geopoint});

  @override
  State<CreateReport> createState() => _CreateReportState();
}

class _CreateReportState extends State<CreateReport> {
  List<XFile>? pickedImages;
  List<String> imageBase64Strings = [];

  Future uploadImages() async {
    if (pickedImages != null) {
      for (XFile image in pickedImages!) {
        // Read the bytes of the image file
        List<int> bytes = await image.readAsBytes();
        // Encode the bytes as a base64 string
        String base64Image = base64Encode(bytes);
        // Add the base64 string to the list
        imageBase64Strings.add(base64Image);
      }
    }
  }

  Future selectImages() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
    );
    if (result != null) {
      setState(() {
        pickedImages = result.files.map((file) => XFile(file.path!)).toList();
      });
    }
  }

  TextEditingController titleController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController detailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    locationController = TextEditingController(text: widget.adress);
  }

  String selectedPollutionType = 'Select pollution type';
  String selectedMunicipality = 'Select Municipality';

  final List<String> pollutionTypes = [
    'Air Pollution',
    'Water Pollution',
    'Land Pollution',
    'Select pollution type'
  ];
  final List<String> municipalities = [
    'Kadıköy',
    'Avcılar',
    'Küçükçekmece',
    'Select Municipality'
  ];
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    titleController.dispose();
    locationController.dispose();
    detailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Text("Create a Report", textScaleFactor: 2.5),
              SizedBox(height: 40.0),
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.edit),
                  labelText: 'Report title',
                ),
              ),
              SizedBox(height: 20.0),
              DropdownButtonFormField<String>(
                value: selectedMunicipality,
                items: municipalities.map((String type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedMunicipality = newValue!;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Municipality',
                  prefixIcon: Icon(Icons.add_business_outlined),
                ),
              ),
              SizedBox(height: 20.0),
              DropdownButtonFormField<String>(
                value: selectedPollutionType,
                items: pollutionTypes.map((String type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedPollutionType = newValue!;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Pollution Type',
                  prefixIcon: Icon(Icons.eco_outlined),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: locationController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.location_on_outlined),
                  labelText: 'Location',
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: detailController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.info_outline),
                  labelText: 'Details',
                ),
              ),
              SizedBox(height: 40.0),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                ElevatedButton(
                  onPressed: selectImages,
                  child: Text("Select image(s)"),
                  style: ElevatedButton.styleFrom(
                    onPrimary: Colors.white,
                    primary: Color(
                        0xFF325A3E),
                        padding: EdgeInsets.symmetric(horizontal: 65), 
                  ),
                )
              ]),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  onPrimary: Colors.white,
                  primary:
                      Color(0xFF325A3E),
                      padding: EdgeInsets.symmetric(horizontal: 65), 
                ),
                onPressed: () async {
                  await uploadImages();
                  final reportId = await completeReport(
                    titleController.text,
                    imageBase64Strings,
                    detailController.text,
                    selectedPollutionType,
                    selectedMunicipality,
                    locationController.text,
                    widget.geopoint!.latitude,
                    widget.geopoint!.longitude,
                  );
                  /*final Nreport = Report(
                    id: reportId,
                    reportTitle: titleController.text,
                    imageBase64Strings: imageBase64Strings,
                    status: 'Pending',
                    reportDetail: detailController.text,
                    reportType: selectedPollutionType,
                    municipality: selectedMunicipality,
                    date: DateTime.now().toString(),
                  );*/
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ReportSuccesful()));
                  // Used Nreport as needed
                },
                child: Text('Complete report'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<String> completeReport(
  String reportTitle,
  List<String> imageBase64Strings,
  String reportDetail,
  String reportType,
  String municipality,
  String location,
  double latitude,
  double longitude,
) async {
  final docReport = FirebaseFirestore.instance.collection('report').doc();
  final json = {
    'reportTitle': reportTitle,
    'imageBase64Strings': imageBase64Strings,
    'status': 'pending',
    'reportDetail': reportDetail,
    'reportType': reportType,
    'municipality': municipality,
    'location': location,
    'latitude': latitude,
    'longitude': longitude,
    'date': DateTime.now().toString(),
  };
  await docReport.set(json);

  return docReport.id; // Return the ID of the newly created document
}
