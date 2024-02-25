import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mep/app/data/models/report_model.dart';
import 'package:mep/app/views/profile/profile_admin_page.dart';
import 'package:mep/app/views/report/my_reports/my_reports_admin_page.dart';
import 'package:geocoding/geocoding.dart' as GeoLocation;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as DeviceLocation;
import 'package:mep/app/views/report/report_detail/report_detail_admin_page.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({Key? key}) : super(key: key);

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  int _selectedIndex = 1;
  GoogleMapController? _controller;
  Set<Marker> _markers = {};
  DeviceLocation.Location _locationController = new DeviceLocation.Location();
  LatLng? _currentP = null;

  void _fetchMarkers() async {
    final markers = await FirebaseFirestore.instance.collection('report').get();
    setState(() {
      _markers = markers.docs.map((doc) {
        final data = doc.data();
        final reportId = doc.id;
        final double latitude = data['latitude']?.toDouble() ??
            0.0; // Veriyi double türüne dönüştür, hata olursa 0.0 olarak varsay
        final double longitude = data['longitude']?.toDouble() ?? 0.0;
        return Marker(
          markerId: MarkerId(data['latitude'].toString()),
          position: LatLng(latitude, longitude),
          icon: BitmapDescriptor.defaultMarker,
          onTap: () async {
            DocumentSnapshot reportSnapshot = await FirebaseFirestore.instance
                .collection('report')
                .doc(reportId)
                .get();
            Report report = Report.fromSnapshot(reportSnapshot);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ReportDetailAdminPage(report: report),
              ),
            );
          },
          // İstediğiniz diğer marker özelliklerini buraya ekleyebilirsiniz
        );
      }).toSet();
    });
  }

  Future<void> getLocationUpdates() async {
    bool _serviceEnabled;
    DeviceLocation.PermissionStatus _permissionGranted;

    _serviceEnabled = await _locationController.serviceEnabled();

    if (_serviceEnabled) {
      _serviceEnabled = await _locationController.requestService();
      print(_serviceEnabled);
    } else {
      return;
    }

    _permissionGranted = await _locationController.hasPermission();
    if (_permissionGranted == DeviceLocation.PermissionStatus.denied) {
      _permissionGranted = await _locationController.requestPermission();
      if (_permissionGranted != DeviceLocation.PermissionStatus.granted) {
        return;
      }
      print(_permissionGranted);
    }

    _locationController.onLocationChanged
        .listen((DeviceLocation.LocationData currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        setState(() {
          _currentP =
              LatLng(currentLocation.latitude!, currentLocation.longitude!);
          print(_currentP);
        });
      }
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _controller = controller;
    });
  }

  @override
  void initState() {
    super.initState();
    getLocationUpdates();
    _fetchMarkers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentP == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : GoogleMap(
              mapType: MapType.normal,
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _currentP!,
                zoom: 12,
              ),
              markers: _markers,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
            ),
    );
  }
}
