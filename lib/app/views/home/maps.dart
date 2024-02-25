// ignore_for_file: library_prefixes, use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as GeoLocation;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as DeviceLocation;
import 'package:mep/app/views/report/create_report/create_report_view.dart';

class MapsView extends StatefulWidget {
  const MapsView({Key? key}) : super(key: key);

  @override
  State<MapsView> createState() => _MapsViewState();
}

class _MapsViewState extends State<MapsView> {
  final Set<Marker> _markers = {};
  final DeviceLocation.Location _locationController = DeviceLocation.Location();
  LatLng? _currentP;
  LatLng? selectedLocation;

  @override
  void dispose() {
    super.dispose();
  }

  Future<String> getAddressFromLatLng(LatLng location) async {
    try {
      List<GeoLocation.Placemark> placemarks =
      await GeoLocation.placemarkFromCoordinates(location.latitude, location.longitude);

      if (placemarks.isNotEmpty) {
        GeoLocation.Placemark placemark = placemarks[0];
        if (kDebugMode) {
          print(placemark);
        }
        return '${placemark.street}, ${placemark.subLocality}, ${placemark.locality},${placemark.subAdministrativeArea}, ${placemark.administrativeArea}, ${placemark.country}';
      } else {
        return "Address Not Found";
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error: $e");
      }
      return "Unknown Address";
    }
  }

  Future<void> getLocationUpdates() async {
    bool serviceEnabled;
    DeviceLocation.PermissionStatus permissionGranted;

    serviceEnabled = await _locationController.serviceEnabled();

    if (serviceEnabled) {
      serviceEnabled = await _locationController.requestService();
      print(serviceEnabled);
    } else {
      return;
    }

    permissionGranted = await _locationController.hasPermission();
    if (permissionGranted == DeviceLocation.PermissionStatus.denied) {
      permissionGranted = await _locationController.requestPermission();
      if (permissionGranted != DeviceLocation.PermissionStatus.granted) {
        return;
      }
      if (kDebugMode) {
        print(permissionGranted);
      }
    }

    _locationController.onLocationChanged.listen((DeviceLocation.LocationData currentLocation) {
      if (currentLocation.latitude != null && currentLocation.longitude != null) {
        if (mounted) {
          setState(() {
            _currentP = LatLng(currentLocation.latitude!, currentLocation.longitude!);
            if (kDebugMode) {
              print(_currentP);
            }
          });
        }
      }
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {});
  }

  void _onMapTapped(LatLng tappedPoint) {
    setState(() {
      selectedLocation = tappedPoint;
      _markers.clear();
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
                          title: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Warning"),
                            ],
                          ),
                          content: const Text("Location must be selected on map"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Row(
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
                foregroundColor: Colors.white,
                backgroundColor: const Color(0xFF325A3E),
                minimumSize: const Size(200, 35),
              ),
              child: const Text("Create a report"),
            ),
          ),
        ],
      ),
    );
  }
}
