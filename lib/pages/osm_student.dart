import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentMapScreen extends StatefulWidget {
  const StudentMapScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _StudentMapScreenState createState() => _StudentMapScreenState();
}

class _StudentMapScreenState extends State<StudentMapScreen> {
  final MapController _mapController = MapController();
  LatLng _driverLocation = const LatLng(0, 0);
  LatLng _studentLocation = const LatLng(0, 0);
  double _distance = 0.0;
  double _estimatedTime = 0.0; 
  String? busName;
  StreamSubscription<DatabaseEvent>? _locationSubscription;

  @override
  void initState() {
    super.initState();
    _getStudentLocation();
    _listenToDriverLocation();
    _loadBusName();
  }

  Future<void> _loadBusName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      busName = prefs.getString('busName') ?? "DefaultBus";
    });

    // _dbRef = FirebaseDatabase.instance.ref("bus_routes/$busName"); // 🔥 Fetch from bus_routes/{busName}
    // _startLocationUpdates();
  }

  // 🔹 Fetch Student's Location
  Future<void> _getStudentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 0,
      ),
    );
    setState(() {
      _studentLocation = LatLng(position.latitude, position.longitude);
    });
  }

  // 🔹 Listen for Driver Location Updates from Firebase
  void _listenToDriverLocation() {
    DatabaseReference dbRef = FirebaseDatabase.instance.ref("driver_location");

    _locationSubscription = dbRef.onValue.listen((event) {
      if (event.snapshot.value != null) {
        final data = event.snapshot.value as Map;
        LatLng updatedLocation = LatLng(
          double.parse(data["latitude"].toString()),
          double.parse(data["longitude"].toString()),
        );

        if (mounted) {
          setState(() {
            _driverLocation = updatedLocation;
          });

          // ✅ Update distance when driver moves
          _updateDistance();

          // ✅ Move the map dynamically to the new driver location
          _mapController.move(updatedLocation, 19.5);
        }
      }
    });
  }

  // 🔹 Calculate Distance Between Student and Driver
  void _updateDistance() {
    double distanceInMeters = Geolocator.distanceBetween(
      _studentLocation.latitude,
      _studentLocation.longitude,
      _driverLocation.latitude,
      _driverLocation.longitude,
    );

    setState(() {
      _distance = distanceInMeters / 1000; // Convert meters to kilometers
    double avgSpeed = 80.0; // Average speed in km/h (adjust if needed)
    _estimatedTime = (_distance / avgSpeed) * 60; // Convert to minutes
    });
  }

  // 🔹 Follow Student's Current Location
  void _followStudentLocation() {
    _mapController.move(_studentLocation, 28.5); // Move to student's location
  }
  // 🔹 Move to Driver's Location Instead of Student's
// void _followDriverLocation() {
//   if (_driverLocation.latitude != 0 && _driverLocation.longitude != 0) {
//     _mapController.move(_driverLocation, 18.5); // Move to driver's location
//   }
// }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Track Driver"),
        backgroundColor: Color.fromARGB(255, 24, 79, 182),
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: const MapOptions(
              initialCenter: LatLng(0, 0),
              initialZoom: 16, // ✅ Start with a closer zoom level
            ),
            children: [
              TileLayer(
                urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
              ),
              MarkerLayer(
                markers: [
                  // 🔹 Student's Location Marker (Blue) with Label
                  Marker(
                    point: _studentLocation,
                    width: 80,
                    height: 80,
                    child: Column(
                      children: [
                        const Icon(Icons.person_pin_circle, color: Colors.blue, size: 40),
                        const SizedBox(height: 2),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            "Student",
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // 🔹 Driver's Location Marker (Red) with Label
                  Marker(
                    point: _driverLocation,
                    width: 80,
                    height: 80,
                    child: Column(
                      children: [
                        const Icon(Icons.directions_bus, color: Colors.red, size: 40),
                        const SizedBox(height: 2),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            "Driver",
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          // 🔹 Distance Display Box
          Positioned(
            top: 20,
            left: 20,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Color.fromRGBO(0, 0, 0, 0.7) ,// Black color with 70% opacity
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "Distance fromo Driver: ${_distance.toStringAsFixed(2)} km",
                style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      // 🔹 Floating Action Button to Follow Student Location
      floatingActionButton: FloatingActionButton(
        onPressed:_followStudentLocation,
        backgroundColor: Colors.blue,
        child: const Icon(Icons.my_location, color: Colors.white),
      ),
    );
  }
}
