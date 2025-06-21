import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:grocery_deliverys/Utils/firebase_options.dart';
import 'package:grocery_deliverys/Utils/shared_preference_data.dart';

import 'CustomerPage/customer_pages.dart';
import 'ShopkeeperModule/shop_keeper_page.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(GroceryApp());
}

class GroceryApp extends StatelessWidget {
  const GroceryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<String?>(
        future: SharedPreferenceData().getToken(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasData && snapshot.data != null) {
            if (snapshot.data! != 'token') {
              return  HomeScreen();
            } else {
              return  AuthScreen();
            }
          } else {
            return  AuthScreen(); // Default return widget
          }
        },
      ),
    );
  }
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLogin = true;


  Future<void> _authenticate() async {
    try {
      if (isLogin) {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        // Store UID in SharedPreferences
        SharedPreferenceData().saveToken(userCredential.user!.uid);

      } else {
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        // Store UID in SharedPreferences
        SharedPreferenceData().saveToken(userCredential.user!.uid);

        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'name': nameController.text,
          'email': emailController.text,
          'phone': phoneController.text,
          'uid': userCredential.user!.uid,
        });
      }

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isLogin ? 'Login' : 'Sign Up')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (!isLogin)
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            if (!isLogin)
              TextField(
                controller: phoneController,
                decoration: InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
              ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _authenticate,
              child: Text(isLogin ? 'Login' : 'Sign Up'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  isLogin = !isLogin;
                });
              },
              child: Text(isLogin ? 'Create an account' : 'Already have an account? Login'),
            )
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Grocery Delivery App')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CustomerScreen()),
                );
              },
              child: Text('Customer Module'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ShopkeeperScreen()),
                );
              },
              child: Text('Shopkeeper Module'),
            ),
          ],
        ),
      ),
    );
  }
}









