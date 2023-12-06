import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:habit/screens/home_screen.dart';
import 'package:habit/screens/login_screen.dart';
import 'package:habit/screens/transaction_screen.dart';
import 'package:habit/widgets/navbar.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  var isLogoutLoading = false;
  int currentIndex = 0;
  var PageViewList = [
    const HomeScreen(),
    const TransactionScreen(),
  ];

  logOut() async {
    setState(() {
      isLogoutLoading = true;
    });
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => LoginView(),
      ),
    );

    setState(() {
      isLogoutLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Navbar(
        selectedIndex: currentIndex,
        onDestinationSelected: (int value) {
          setState(() {
            currentIndex = value;
          });
        },
      ),
      body: PageViewList[currentIndex],
    );
  }
}
