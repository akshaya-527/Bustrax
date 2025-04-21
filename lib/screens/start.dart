import 'package:bus_trax/pages/osm_driver.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);  
          },
        ),
        backgroundColor: Colors.transparent, 
        elevation: 0, 
      ),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.45, 
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF88C9F9), Color.fromARGB(255, 220, 235, 247), Colors.white], // Light to dark blue
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // 🔹 Main Content
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),

                const SizedBox(height: 15),

                // 🔹 Illustration Image
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Image.asset(
                    'mid.png', // Replace with actual image
                    height: 400,
                    fit: BoxFit.cover,
                  ),
                ),

                const SizedBox(height: 20),

                // 🔹 Slogan Text
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Text.rich(
                    TextSpan(
                      text: "Brig you ",
                      style: TextStyle(fontSize: 20, color: Colors.black87),
                      children: [
                        TextSpan(
                          text: "closer to your ride",
                          style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
                        ),
                        TextSpan(text: " One Stop at a Time."),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 30),

                // 🔹 Login Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DriverMapScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Update Location",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
