import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as GeoLocation;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as DeviceLocation;
import 'package:mep/app/views/report/create_report/create_report_view.dart';
import '../profile/profile_page.dart';
import '../report/my_reports/my_reports_page.dart';

class MapsView extends StatefulWidget {
  const MapsView({Key? key}) : super(key: key);

  @override
  State<MapsView> createState() => _MapsViewState();
}

class _MapsViewState extends State<MapsView> {
  GoogleMapController? _controller;
  LatLng _initialCameraPosition = LatLng(37.7749, -122.4194);
  Set<Marker> _markers = {};
  DeviceLocation.Location _locationController = DeviceLocation.Location();
  LatLng? _currentP;
  LatLng? selectedLocation;

  Future<String> getAddressFromLatLng(LatLng location) async {
    try {
      List<GeoLocation.Placemark> placemarks =
          await GeoLocation.placemarkFromCoordinates(
              location.latitude, location.longitude);

      if (placemarks != null && placemarks.isNotEmpty) {
        GeoLocation.Placemark placemark = placemarks[0];
        print(placemark);
        return '${placemark.street}, ${placemark.subLocality}, ${placemark.locality},${placemark.subAdministrativeArea}, ${placemark.administrativeArea}, ${placemark.country}';
      } else {
        return "Address Not Found";
      }
    } catch (e) {
      print("Error: $e");
      return "Unknown Address";
    }
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

  void _onMapTapped(LatLng tappedPoint) {
    setState(() {
      selectedLocation = tappedPoint;
      _markers.clear(); // Clear previous markers
      _markers.add(
        Marker(
          markerId: MarkerId(tappedPoint.latitude.toString()),
          position: tappedPoint,
          icon: BitmapDescriptor.defaultMarker,
        ),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    getLocationUpdates();
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    body: Stack(
      children: [
        _currentP == null
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
                onTap: _onMapTapped,
                markers: _markers,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
              ),
        Positioned(
          left: 50.0,
          right: 50.0,
          bottom: 60.0,
          child: ElevatedButton(
            onPressed: () async {
              // Pass the selected location to the other page
              if (selectedLocation != null) {
                String address = await getAddressFromLatLng(selectedLocation!);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        CreateReport(adress: address, geopoint: selectedLocation),
                  ),
                );
              } else {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Center(
                      child: AlertDialog(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Warning"),
                          ],
                        ),
                        content: Text("Location must be selected on map"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("OK"),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }
            },
            style: ElevatedButton.styleFrom(
              primary: Color(0xFF325A3E), // Background color
              onPrimary: Colors.white, // Text color
              minimumSize: Size(200, 35), // Width and height
            ),
            child: Text("Create a report"),
          ),
        ),
      ],
    ),
  );
}
}
