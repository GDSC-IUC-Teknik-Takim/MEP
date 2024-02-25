// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as DeviceLocation;
import 'package:mep/app/data/models/report_model.dart';
import 'package:mep/app/views/report/report_detail/report_detail_admin_page.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({Key? key}) : super(key: key);

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  GoogleMapController? _controller;
  Set<Marker> _markers = {};
  final DeviceLocation.Location _locationController = DeviceLocation.Location();
  LatLng? _currentP;

  @override
  void initState() {
    super.initState();
    getLocationUpdates();
    _fetchMarkers();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _fetchMarkers() async {
    final markers = await FirebaseFirestore.instance.collection('report').get();
    setState(() {
      _markers = markers.docs.map((doc) {
        final data = doc.data();
        final reportId = doc.id;
        final double latitude = data['latitude']?.toDouble() ?? 0.0;
        final double longitude = data['longitude']?.toDouble() ?? 0.0;
        return Marker(
          markerId: MarkerId(data['latitude'].toString()),
          position: LatLng(latitude, longitude),
          icon: BitmapDescriptor.defaultMarker,
          onTap: () async {
            DocumentSnapshot reportSnapshot =
            await FirebaseFirestore.instance.collection('report').doc(reportId).get();
            Report report = Report.fromSnapshot(reportSnapshot);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ReportDetailAdminPage(report: report),
              ),
            );
          },
        );
      }).toSet();
    });
  }

  Future<void> getLocationUpdates() async {
    bool _serviceEnabled;
    DeviceLocation.PermissionStatus _permissionGranted;

    _serviceEnabled = await _locationController.serviceEnabled();

    if (!_serviceEnabled) {
      _serviceEnabled = await _locationController.requestService();
    }

    _permissionGranted = await _locationController.hasPermission();
    if (_permissionGranted == DeviceLocation.PermissionStatus.denied) {
      _permissionGranted = await _locationController.requestPermission();
    }

    _locationController.onLocationChanged.listen((DeviceLocation.LocationData currentLocation) {
      if (mounted) {
        setState(() {
          _currentP = LatLng(currentLocation.latitude!, currentLocation.longitude!);
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentP == null
          ? const Center(
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
