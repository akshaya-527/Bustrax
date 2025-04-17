import 'package:bus_trax/screens/loginscreen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

// 🔹 Call this function when login is successful
Future<void> saveUserData(String email, String role) async {
  final prefs = await SharedPreferences.getInstance();

  // 🔹 Find User Document in Firestore
  QuerySnapshot userQuery = await FirebaseFirestore.instance
      .collection(role == 'driver' ? 'drivers' : 'students')
      .where('email', isEqualTo: email)
      .get();

  if (userQuery.docs.isNotEmpty) {
    String userId = userQuery.docs.first.id; // Get the document ID

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
      body: Stack(
        children: [
          
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: screenHeight * 0.13),
                //  const Image(
                //           image: AssetImage('main.png'),
                //         ),
                      Image.asset('main.png'),
                        SizedBox(height: screenHeight * 0.03),
                        const Text(
                      "   Know where your ride is,",
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    const Text(
                      "    skip the waiting!",
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                SizedBox(height: screenHeight * 0.03), 
                ElevatedButton(
                  onPressed: () {
                    // await _saveUserRole("student"); 
                    Navigator.push(
                  context,
                  MaterialPageRoute(
                      // builder: (context) => const DriverLogin()),
                      builder: (context) => const HomePage(role: 'student',)),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black, backgroundColor: Color.fromARGB(255, 24, 79, 182),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.2, vertical: 15),
                  ),
                  child: const Text(
                    'STUDENT LOGIN',
                    style: TextStyle(
                      color:Colors.white,
                      fontSize: 20, 
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02), 
                ElevatedButton(
                  onPressed: (){
                    Navigator.push(
                  context,
                  MaterialPageRoute(
                      // builder: (context) => const DriverLogin()),
                      builder: (context) => const HomePage(role: 'driver',)),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black, backgroundColor: Color.fromARGB(255, 24, 79, 182),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.2, vertical: 15), 
                  ),
                  child: const Text(
                    'DRIVER LOGIN',
                    style: TextStyle(
                      color:Colors.white,
                      fontSize: 22, 
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02), 
               
              ],
            ),
          ),
        ],
      ),
    );
  }
}
