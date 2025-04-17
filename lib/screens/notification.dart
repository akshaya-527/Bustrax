import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool isDriver = false; // 🔹 Default to false

  // 🔹 Notification List
  final List<Map<String, String>> _notifications = [
    {
      "title": "Transport Department",
      "message": "Transport Fee Dues Have To Be Cleared On Or Before 15th July.",
      "time": "4:09 PM",
    },
    {
      "title": "Transport Department",
      "message": "Buses will depart from college by 5 PM.",
      "time": "10:30 AM",
    },
    {
      "title": "Transport Department",
      "message": "Today 5J bus is not available. Please adjust in any other buses.",
      "time": "8:00 AM",
    },
    {
      "title": "Transport Department",
      "message": "10J is allocated to another route. Students must board other buses.",
      "time": "6:45 AM",
    },
  ];

  @override
  void initState() {
    super.initState();
    _checkUserRole();
  }

  // 🔹 Check User Role from SharedPreferences
  Future<void> _checkUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    String? role = prefs.getString('userRole'); // 🔹 Get saved role

    setState(() {
      isDriver = (role == 'driver'); // ✅ Set isDriver to true if user is a driver
    });

    // print("User Role: $role, isDriver: $isDriver"); // ✅ Debugging
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications",style: TextStyle(
                        fontSize: 26,
                        color: Colors.white,
                        fontWeight: FontWeight.w100,
                      ),),
        backgroundColor: const Color.fromARGB(255, 24, 79, 182),
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // 🔹 Display All Notifications
              for (var notification in _notifications)
                _buildNotificationCard(notification),

              const SizedBox(height: 20),

              // 🔹 Show Send Notification Card ONLY if the user is a driver
              if (isDriver) _buildSendNotificationCard(),
            ],
          ),
        ),
      ),
    );
  }

  // 🔹 Notification Card Widget
  Widget _buildNotificationCard(Map<String, String> notification) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.1),
            blurRadius: 5,
            spreadRadius: 2,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const CircleAvatar(
                backgroundColor: Colors.grey,
                radius: 25,
                child: Icon(
    Icons.person, // 🔹 Person Icon
    color: Colors.white, // 🔹 White Icon for contrast
    size: 30, // Adjust size if needed
  ),
              ),
              Text(
                notification["time"]!,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            notification["title"]!,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            notification["message"]!,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  // 🔹 Send Notification Card (Only for Drivers)
  Widget _buildSendNotificationCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 24, 79, 182),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Send Notifications",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            decoration: InputDecoration(
              hintText: "Enter Message",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                vertical: 15,
                horizontal: 30,
              ),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              "Send",
              style: TextStyle(color: Color.fromARGB(255, 24, 79, 182)),
            ),
          ),
        ],
      ),
    );
  }
}
