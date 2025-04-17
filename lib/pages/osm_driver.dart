import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DriverMapScreen extends StatefulWidget {
  const DriverMapScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DriverMapScreenState createState() => _DriverMapScreenState();
}

class _DriverMapScreenState extends State<DriverMapScreen> {
  final MapController _mapController = MapController();
  late DatabaseReference _dbRef;
  Timer? _timer;
  LatLng _driverLocation = const LatLng(0, 0); // Track driver’s current location
  String? busName; // Store the bus name
  @override
  void initState() {
    super.initState();
    _dbRef = FirebaseDatabase.instance.ref("driver_location"); // 🔥 Reference to Firebase
    _startLocationUpdates();
    _loadBusName(); // Load the bus name from shared preferences
  }

   Future<void> _loadBusName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      busName = prefs.getString('busName') ?? "DefaultBus";
    });

    _dbRef = FirebaseDatabase.instance.ref("bus_routes/$busName"); // 🔥 Store in bus_routes/{busName}
    _startLocationUpdates();
  }

  Future<void> _updateLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 0,
      ),
    );

    LatLng currentLocation = LatLng(position.latitude, position.longitude);

    // ✅ Update Firebase Database
    await _dbRef.set({
      "busName": busName,
      "latitude": position.latitude,
      "longitude": position.longitude,
      "timestamp": DateTime.now().millisecondsSinceEpoch
    });

    // ✅ Update UI & Animate Camera to Driver Location
    if (mounted) {
      setState(() {
        _driverLocation = currentLocation; // Store updated location
        _mapController.move(currentLocation, 18); // 🔥 Adjusted Zoom Level
      });
    }
  }

  void _startLocationUpdates() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _updateLocation();
    });
  }

  // 🔹 Follow Driver's Current Location when FAB is pressed
  void _followCurrentLocation() {
    _mapController.move(_driverLocation, 48);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Location - $busName"),
        backgroundColor: Colors.blue,
      ),
      body: FlutterMap(
        mapController: _mapController,
        options: const MapOptions(
          initialCenter: LatLng(0, 0), // Default location before GPS update
          initialZoom: 18, // ✅ Default zoom level
        ),
        children: [
          TileLayer(
            urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
          ),
          CurrentLocationLayer(
            style: LocationMarkerStyle(
              marker: const DefaultLocationMarker(
                child: Icon(
                  Icons.location_pin,
                  color: Colors.white,
                ),
              ),
              markerSize: const Size(40, 40),
              markerDirection: MarkerDirection.heading,
            ),
          ),
        ],
      ),
      // 🔹 Floating Action Button to Follow Driver’s Location
      floatingActionButton: FloatingActionButton(
        onPressed: _followCurrentLocation,
        backgroundColor: Colors.blue,
        child: const Icon(Icons.my_location, color: Colors.white),
      ),
    );
  }
}
