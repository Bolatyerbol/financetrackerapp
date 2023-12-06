import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:habit/screens/login_screen.dart';
import 'package:habit/widgets/add_transactions_form.dart';
import 'package:habit/widgets/hero_card.dart';
import 'package:habit/widgets/transactions_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String username = "";

  @override
  void initState() {
    super.initState();
    loadUsername();
  }

  Future<void> loadUsername() async {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      String usernameValue = userSnapshot['username'];

      setState(() {
        username = usernameValue;
      });
    } catch (e) {
      print("Error loading username: $e");
    }
  }

  var isLogoutLoading = false;

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

  final userId = FirebaseAuth.instance.currentUser!.uid;

  _dialogBuilder(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          content: AddTransactionsForm(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue.shade900,
        onPressed: () {
          _dialogBuilder(context);
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.blue.shade900,
        title: Text(
          'Hello, $username! ',
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {
              logOut();
            },
            icon: isLogoutLoading
                ? const CircularProgressIndicator()
                : const Icon(
                    Icons.exit_to_app,
                    color: Colors.white,
                  ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeroCard(
              userId: userId,
            ),
            TransactionsCard(),
          ],
        ),
      ),
    );
  }
}
