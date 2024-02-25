// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mep/app/core/extensions/build_context_extensions.dart';
import 'package:mep/app/views/report/create_report/report_succesful.dart';
import 'dart:convert';

class CreateReport extends StatefulWidget {
  final String? adress;
  final LatLng? geopoint;

  const CreateReport({Key? key, this.adress, this.geopoint}) : super(key: key);

  @override
  State<CreateReport> createState() => _CreateReportState();
}

class _CreateReportState extends State<CreateReport> {
  List<XFile>? pickedImages;
  List<String> imageBase64Strings = [];

  Future uploadImages() async {
    if (pickedImages != null) {
      for (XFile image in pickedImages!) {
        List<int> bytes = await image.readAsBytes();
        String base64Image = base64Encode(bytes);
        imageBase64Strings.add(base64Image);
      }
    }
  }

  Future selectImageFromCamera() async {
    if (pickedImages != null) {
      setState(() {
        pickedImages!.clear();
      });
    }

    final image = await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 35);
    if (image != null) {
      setState(() {
        pickedImages = [XFile(image.path)];
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
  final List<String> municipalities = ['Kadıköy', 'Avcılar', 'Küçükçekmece', 'Select Municipality'];
  @override
  void dispose() {
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
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const Text("Create a Report", textScaleFactor: 2.5),
              const SizedBox(height: 40.0),
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.edit),
                  labelText: 'Report title',
                ),
              ),
              const SizedBox(height: 20.0),
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
                decoration: const InputDecoration(
                  labelText: 'Municipality',
                  prefixIcon: Icon(Icons.add_business_outlined),
                ),
              ),
              const SizedBox(height: 20.0),
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
                decoration: const InputDecoration(
                  labelText: 'Pollution Type',
                  prefixIcon: Icon(Icons.eco_outlined),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: locationController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.location_on_outlined),
                  labelText: 'Location',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: detailController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.info_outline),
                  labelText: 'Details',
                ),
              ),
              const SizedBox(height: 40.0),
              pickedImages == null
                  ? const Text('Please take a photo of the scene')
                  : const Column(
                children: [
                  Text('Photo successfully added'),
                ],
              ),
              const SizedBox(height: 20.0),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                ElevatedButton(
                  onPressed: selectImageFromCamera,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color(0xFF325A3E),
                    minimumSize: const Size(210, 35),
                  ),
                  child: const Text("Take a photo"),
                )
              ]),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (titleController.text.isEmpty ||
                      locationController.text.isEmpty ||
                      detailController.text.isEmpty ||
                      pickedImages == null ||
                      pickedImages!.isEmpty) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Warning"),
                          content: const Text(
                              "Please fill in all of the report informations and select at least one image."),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text("OK"),
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    await uploadImages();
                    if (imageBase64Strings.isEmpty) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Warning"),
                            content: const Text("Please select at least one image."),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text("OK"),
                              ),
                            ],
                          );
                        },
                      );
                    } else {
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

                      showReportSuccessfulDialog(context);
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFF325A3E),
                  minimumSize: const Size(210, 35),
                ),
                child: const Text("Complete report"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void showReportSuccessfulDialog(BuildContext context) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 150,
              width: 150,
              child: Image.asset(
                'assets/images/basarili.png',
                fit: BoxFit.contain,
              ),
            ),
            const Text(
              "Report Successfully Completed.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF325A3E),
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              "Your report arrived authorities successfully. Just wait ... Municipality will arrive the scene asap.",
              textAlign: TextAlign.center,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color(0xFF325A3E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(38.0),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('Continue'),
            ),
          ],
        ),
      );
    },
  );
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
    'status': 'We have received',
    'reportDetail': reportDetail,
    'reportType': reportType,
    'municipality': municipality,
    'location': location,
    'latitude': latitude,
    'longitude': longitude,
    'date': DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now()),
  };
  await docReport.set(json);
  return docReport.id;
}
