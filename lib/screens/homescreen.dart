import 'package:bus_trax/pages/osm_student.dart';
import 'package:bus_trax/screens/notification.dart';
import 'package:bus_trax/screens/profile.dart';
import 'package:bus_trax/screens/start.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

// **Main App**
class Homee extends StatelessWidget {
  const Homee({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      home: const HomePageScreen(),
    );
  }
}

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  int selected = 0;
  final PageController controller = PageController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,

      body: SafeArea(
        child: PageView(
          controller: controller,
          children: const [
            HScreen(),
            ProfileScreen(),
          ],
        ),
      ),

      bottomNavigationBar: StylishBottomBar(
        option: AnimatedBarOptions(
          iconStyle: IconStyle.animated,
        ),
        items: [
          BottomBarItem(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home_rounded),
            selectedColor: Colors.blue[600]!,
            unSelectedColor: Colors.grey,
            title: const Text('Home'),
          ),
          BottomBarItem(
            icon: const Icon(Icons.person_outline),
            selectedIcon: const Icon(Icons.person),
            selectedColor: Colors.blue[600]!,
            title: const Text('Profile'),
          ),
        ],
        hasNotch: true,
        fabLocation: StylishBarFabLocation.center,
        currentIndex: selected,
        notchStyle: NotchStyle.square,
        onTap: (index) {
          if (index == selected) return;
          controller.jumpToPage(index);
          setState(() {
            selected = index;
          });
        },
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

// **Home Page Content**
class HScreen extends StatelessWidget {
  const HScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
       body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // **Top Bar with Profile and Notification**
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(33, 150, 243, 0.1) ,// Same as Colors.blue with 10% opacity
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.directions_bus,
                        size: 28,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'BusTrax',
                      style: TextStyle(
                        fontSize: 36,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 152, 0, 0.1), // Same as Colors.orange with 10% opacity
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Stack(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.notifications_none_rounded,
                              size: 28,
                              color: Color(0xFF1E3A8A),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const NotificationScreen(),
                                ),
                              );
                            },
                          ),
                          Positioned(
                            right: 8,
                            top: 8,
                            child: Container(
                              width: 12,
                              height: 12,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Profile and Settings
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Good Morning,',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Text(
                    'Welcome Back',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),

              // Notification Card
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue[600]!, Colors.blue[400]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color:Color.fromRGBO(33, 150, 243, 0.2) ,// Same as Colors.blue with 20% opacity
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.white),
                    SizedBox(width: 15),
                    Expanded(
                      child: Text(
                        'Live tracking enabled for all routes. Track your bus in real-time',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Grid of Options
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  children: [
                    _buildGridItem(
                      context,
                      'Route 1J',
                      const Color(0xFF4A90E2),
                      Icons.location_on,
                    ),
                    _buildGridItem(
                      context,
                      'Route 5M',
                      const Color(0xFF9B51E0),
                      Icons.location_on,
                    ),
                    _buildGridItem(
                      context,
                      'Route 3S',
                      const Color(0xFF2AC7A8),
                      Icons.location_on,
                    ),
                    _buildGridItem(
                      context,
                      'Route 6B',
                      const Color(0xFFFF9500),
                      Icons.location_on,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// **Grid Item Builder**
Widget _buildGridItem(
  BuildContext context,
  String title,
  Color color,
  IconData icon,
) {
  return GestureDetector(
    onTap: () async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('busName', title);
      String? userRole = prefs.getString('userRole');

      if (userRole == 'driver') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const WelcomeScreen()), 
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const StudentMapScreen()), 
        );
      }
    },
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 32,
              color: color,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    ),
  );
}


