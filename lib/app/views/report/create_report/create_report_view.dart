import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:io';
import 'package:mep/app/data/models/report_model.dart';
import 'package:mep/app/data/database/Reports_DB.dart';

class CreateReport extends StatefulWidget {
  @override
  State<CreateReport> createState() => _CreateReportState();
}

class _CreateReportState extends State<CreateReport> {
  TextEditingController titleController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController detailController = TextEditingController();

  String? selectedPollutionType;
  String? selectedMunicipality;
  File? imageFile;

  final List<String> pollutionTypes = ['Air Pollution', 'Water Pollution', 'Land Pollution'];
  final List<String> municipalities = ['Kadikoy', 'Avcilar', 'Kucukcekmece'];

  Future<void> getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      imageFile = File(pickedFile!.path);
    });
  }

  void createReport() async {
    // Create a new report object
    Report report = Report(
      imageUrl: imageFile != null ? imageFile!.path : '', // Store image path if available
      reportTitle: titleController.text,
      reportDetail: detailController.text,
      reportType: selectedPollutionType ?? '',
      municipality: selectedMunicipality ?? '',
      date: DateTime.now().toString(), // Store current date
      status: 'Pending', // Assuming all reports start with 'Pending' status
    );

    // Save the report to the database
    await ReportsDB().createReport(report);

    // Navigate back to the previous screen
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create a report")),
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
                    selectedMunicipality = newValue;
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
                    selectedPollutionType = newValue;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Pollution Type',
                  prefixIcon: Icon(Icons.eco_outlined),
                ),
              ),
              SizedBox(height: 20,),
              TextFormField(
                controller: locationController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.location_on_outlined),
                  labelText: 'Location',
                ),
              ),
              SizedBox(height: 20,),
              TextFormField(
                controller: detailController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.info_outline),
                  labelText: 'Details',
                ),
              ),
              SizedBox(height: 20,),
              GestureDetector(
                onTap: getImage,
                child: Container(
                  width: double.infinity,
                  height: 100,
                  color: Colors.grey[200],
                  child: imageFile != null
                      ? Image.file(
                    imageFile!,
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
              ElevatedButton(
                onPressed: createReport,
                child: Text('Complete report'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
