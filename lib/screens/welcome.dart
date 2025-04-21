import 'package:bus_trax/screens/loginscreen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomScreen extends StatelessWidget {
  const WelcomScreen({super.key});
  Future<void> saveUserData(String email, String role) async {
    final prefs = await SharedPreferences.getInstance();
    QuerySnapshot userQuery = await FirebaseFirestore.instance
        .collection(role == 'driver' ? 'drivers' : 'students')
        .where('email', isEqualTo: email)
        .get();

    if (userQuery.docs.isNotEmpty) {
      String userId = userQuery.docs.first.id;
      await prefs.setString('userRole', role);
      await prefs.setString('userId', userId);
      await prefs.setString('userEmail', email);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: SizedBox(
            width: screenWidth,
            height: screenHeight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: screenHeight * 0.1),
                Image.asset(
                  'main.png',
                  gaplessPlayback: true,
                  width: screenWidth * 0.7,
                ),

                SizedBox(height: screenHeight * 0.04),
                Column(
                  children: [
                    Text(
                      "Know where your ride is,",
                      style: TextStyle(
                        fontSize: screenWidth * 0.065,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "Skip the waiting!",
                      style: TextStyle(
                        fontSize: screenWidth * 0.065,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),

                SizedBox(height: screenHeight * 0.05),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomePage(role: 'student'),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 24, 79, 182),
                    padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.2, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'STUDENT LOGIN',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),

                SizedBox(height: screenHeight * 0.02),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomePage(role: 'driver'),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 24, 79, 182),
                    padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.2, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'DRIVER LOGIN',
                    style: TextStyle(color: Colors.white, fontSize: 22),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
