import 'package:bus_trax/screens/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Dummy home screen after login


class HomePage extends StatefulWidget {
  final String role; // 'driver' or 'student'
  const HomePage({super.key, required this.role});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // final _formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> loginUser() async {
    final prefs = await SharedPreferences.getInstance();
    String username = usernameController.text.trim();
    String password = passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    try {
      String collection = widget.role == 'driver' ? 'drivers' : 'students';
      String field = widget.role == 'driver' ? 'id' : 'email';
      String idToMatch = widget.role == 'student' ? '$username@bvrit.ac.in' : username;

      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection(collection)
          .where(field, isEqualTo: idToMatch)
          .get();

      if (snapshot.docs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${widget.role} not found')),
        );
        return;
      }

      DocumentSnapshot doc = snapshot.docs.first;
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      if (!data.containsKey('password') || data['password'] != password) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Incorrect password')),
        );
        return;
      }

      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('userRole', widget.role);
      await prefs.setString('userId', doc.id);
      await prefs.setString('userEmail', widget.role == 'student' ? idToMatch : data['email'] ?? '');

      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePageScreen()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
	        child: Column(
	          children: <Widget>[
	            Container(
	              height: 400,
	              decoration: const BoxDecoration(
	                image: DecorationImage(
	                  image: AssetImage('assets/background.png'),
	                  fit: BoxFit.fill
	                )
	              ),
	              child: Stack(
	                children: <Widget>[
	                  Positioned(
	                    left: 30,
	                    width: 80,
	                    height: 200,
	                    child: FadeInUp(duration: const Duration(seconds: 1), child: Container(
	                      decoration: const BoxDecoration(
	                        image: DecorationImage(
	                          image: AssetImage('assets/light-1.png')
	                        )
	                      ),
	                    )),
	                  ),
	                  Positioned(
	                    left: 140,
	                    width: 80,
	                    height: 150,
	                    child: FadeInUp(duration: const Duration(milliseconds: 1200), child: Container(
	                      decoration: const BoxDecoration(
	                        image: DecorationImage(
	                          image: AssetImage('assets/light-2.png')
	                        )
	                      ),
	                    )),
	                  ),
	                  Positioned(
	                    right: 40,
	                    top: 40,
	                    width: 80,
	                    height: 150,
	                    child: FadeInUp(duration: const Duration(milliseconds: 1300), child: Container(
	                      decoration: const BoxDecoration(
	                        image: DecorationImage(
	                          image: AssetImage('assets/clock.png')
	                        )
	                      ),
	                    )),
	                  ),
	                  Positioned(
	                    child: FadeInUp(duration: const Duration(milliseconds: 1600), child: Container(
	                      margin: const EdgeInsets.only(top: 50),
	                      child:  Center(
	                        child: Text( "${widget.role.toUpperCase()} ", style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),),
	                      ),
	                    )),
	                  )
	                ],
	              ),
	            ),
	            Padding(
	              padding: const EdgeInsets.all(30.0),
	              child: Column(
	                children: <Widget>[
	                  FadeInUp(duration: const Duration(milliseconds: 1800), child: Container(
	                    padding: const EdgeInsets.all(5),
	                    decoration: BoxDecoration(
	                      color: Colors.white,
	                      borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color.fromRGBO(143, 148, 251, 1)),
	                      boxShadow: const [
	                        BoxShadow(
	                          color: Color.fromRGBO(143, 148, 251, .2),
	                          blurRadius: 20.0,
	                          offset: Offset(0, 10)
	                        )
	                      ]
	                    ),
	                    child: Column(
	                      children: <Widget>[
	                        Container(
	                          padding: const EdgeInsets.all(8.0),
	                          decoration: const BoxDecoration(
	                            border: Border(bottom: BorderSide(color:  Color.fromRGBO(143, 148, 251, 1)))
	                          ),
	                          child: TextField(
                              controller: usernameController,
	                            decoration: InputDecoration(
	                              border: InputBorder.none,
	                              hintText: widget.role == 'driver' ? 'Username' : 'Email',
                                prefixText: widget.role== 'student' ? '   ' : null, // Add space only for student
                                suffixText: widget.role== 'student' ? '@bvrit.ac.in' : null,
	                              hintStyle: TextStyle(color: Colors.grey[700])
	                            ),
	                          ),
	                        ),
	                        Container(
	                          padding: const EdgeInsets.all(8.0),
	                          child: TextField(
                              obscureText: true,
                              controller: passwordController,
	                            decoration: InputDecoration(
	                              border: InputBorder.none,
	                              hintText: "Password",
	                              hintStyle: TextStyle(color: Colors.grey[700])
	                            ),
	                          ),
	                        )
	                      ],
	                    ),
	                  )),
	                  const SizedBox(height: 30,),
	                  FadeInUp(duration: const Duration(milliseconds: 1900),child: GestureDetector(
    onTap: loginUser, child: Container(
	                    height: 50,
	                    decoration: BoxDecoration(
	                      borderRadius: BorderRadius.circular(10),
	                      gradient: const LinearGradient(
	                        colors: [
	                          Color.fromRGBO(143, 148, 251, 1),
	                          Color.fromRGBO(143, 148, 251, .6),
	                        ]
	                      )
	                    ),
	                    child: const Center(
	                      child: Text("Login", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
	                    ),
	                  )),
                    ),
	                  const SizedBox(height: 70,),
	                  // FadeInUp(duration: const Duration(milliseconds: 2000), child: const Text("Forgot Password?", style: TextStyle(color: Color.fromRGBO(143, 148, 251, 1)),)),
	                ],
	              ),
	            )
	          ],
	        ),
	      ),
    );
  }
}