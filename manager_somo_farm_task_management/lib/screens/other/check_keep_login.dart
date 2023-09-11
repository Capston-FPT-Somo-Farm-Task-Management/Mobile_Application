import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../manager/manager_home_page.dart';
import 'login_page.dart';

class CheckKeepLogin extends StatefulWidget {
  const CheckKeepLogin({super.key});

  @override
  CheckKeepLoginState createState() => CheckKeepLoginState();
}

class CheckKeepLoginState extends State<CheckKeepLogin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasData) {
              return const ManagerHomePage();
            } else if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong!'));
            } else {
              return const LoginPage();
            }
          }),
    );
  }
}
