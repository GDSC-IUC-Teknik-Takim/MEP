import 'package:flutter/material.dart';
import 'package:mep/app/views/report/create_report/create_report_view.dart';
import 'package:geocoding/geocoding.dart' as GeoLocation;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as DeviceLocation;
import '../profile/profile_page.dart';
import '../report/my_reports/my_reports_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 1;
  GoogleMapController? _controller;
  LatLng _initialCameraPosition = LatLng(37.7749, -122.4194);
  Set<Marker> _markers = {};
  DeviceLocation.Location _locationController = new DeviceLocation.Location();
  LatLng? _currentP = null;
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
        return "Adres Bulunamadı";
      }
    } catch (e) {
      print("Hata: $e");
      return "Bilinmeyen Adres";
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
      _markers.clear(); // Önceki marker'ları temizle
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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    top: 50.0,
                    bottom: 8.0), // Yazının üstünde ve altında boşluk oluşturur
                child: Text(
                  "           Home",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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
              onTap: _onMapTapped,
              markers: _markers,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
            ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 60.0),
        child: ElevatedButton(
          onPressed: () async {
            // Seçilen konumu diğer sayfaya aktar
            if (selectedLocation != null) {
              String address = await getAddressFromLatLng(selectedLocation!);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      CreateReport(adress: address, geopoint: selectedLocation),
                ),
              );
            }
            else
            {
              
              showDialog(context: context,
                  builder: (BuildContext context)
                  {
                    return Center(
                      child: AlertDialog(
                        title: Row(mainAxisAlignment: MainAxisAlignment.center,
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
                            child: Row(mainAxisAlignment:MainAxisAlignment.center ,
                              children: [
                                Text("OK"),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }
              );
            }
          },
          child: Text("Create a Report"),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.article_outlined),
            label: 'Reports',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF325A3E),
        unselectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyReportsPage()),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProfilePage()),
      );
    }
  }
}
