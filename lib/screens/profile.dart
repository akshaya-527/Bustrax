import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bus_trax/screens/welcome.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? userName;
  String? userEmail;
  String userRole = "Guest"; // Default Role

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  // 🔹 Fetch User Role & Email from Firestore
  Future<void> _loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    String? role = prefs.getString('userRole'); // Get saved role
    String? userId = prefs.getString('userId'); // Get saved User ID

    if (role != null && userId != null) {
      setState(() {
        userRole = role == 'driver' ? "Driver" : "Student";
      });

      // 🔹 Query Firestore to get user details
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection(role == 'driver' ? 'drivers' : 'students')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
        setState(() {
        if (role == 'driver') {
          userEmail = data['id'] ?? "No ID found";  // Show 'id' for drivers
        } else {
          userEmail = data['email'] ?? "No email found";  // Show 'email' for students
        }
      });
      } else {
        setState(() {
          // userName = "User Not Found";
          userEmail = "N/A";
        });
      }
    } else {
      setState(() {
        // userName = "Not Logged In";
        userEmail = "N/A";
      });
    }
  }

  // 🔹 Logout Function
  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WelcomScreen()),
      );
    }
  }

  // 🔹 Open URL in External Browser
  Future<void> _launchURL(String url) async {
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Light Background
      body: Column(
        children: [
          // 🔹 Profile Header
          Stack(
            alignment: Alignment.center,
            children: [
              // 🔹 Background
              Container(
                height: 250,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
              ),

              // 🔹 Profile Avatar & Info
              Column(
                children: [
                  const SizedBox(height: 50),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // 🔹 Circle Avatar
                      const CircleAvatar(
                        radius: 55,
                        backgroundColor: Colors.teal,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: AssetImage('assets/profile.png'),
                        ),
                      ),
                      // 🔹 Status Indicator
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    userEmail ?? "Fetching email...",
                    style: const TextStyle(fontSize: 20, color: Colors.blue),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    userRole,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),

              // 🔹 Top Right Notification & Settings
              Positioned(
                top: 40,
                right: 20,
                child: Row(
                  children: [
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert, size: 30, color: Colors.black),
                      onSelected: (String choice) {
                        if (choice == 'Logout') {
                          _logout();
                        }
                      },
                      itemBuilder: (BuildContext context) => [
                        const PopupMenuItem<String>(
                          value: 'Logout',
                          child: Text('Logout'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // 🔹 Profile Options
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                ProfileOption(
                  icon: Icons.info_outline,
                  text: "Bus Info",
                  onTap: () => _launchURL("https://bvrit.ac.in/transport/"), // 🔹 Open URL
                ),
                ProfileOption(
                  icon: Icons.help_outline,
                  text: "Contact Department",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 🔹 Profile Option Tile
class ProfileOption extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback? onTap;

  const ProfileOption({
    super.key,
    required this.icon,
    required this.text,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(158, 158, 158, 0.2), // Grey color with 20% opacity
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 30, color: Colors.teal),
            const SizedBox(width: 15),
            Text(
              text,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
