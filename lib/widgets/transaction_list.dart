import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:habit/widgets/transaction_car.dart';

class TransectionList extends StatelessWidget {
  TransectionList(
      {super.key,
      required this.category,
      required this.type,
      required this.monthYear});
  final userId = FirebaseAuth.instance.currentUser!.uid;

  final String type;
  final String category;
  final String monthYear;

  @override
  Widget build(BuildContext context) {
    Query query = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('transactions')
        .orderBy('timestamp', descending: true)
        .where('monthyear', isEqualTo: monthYear)
        .where('type', isEqualTo: type);

    if (category != 'All') {
      query = query.where('category', isEqualTo: category);
    }

    return FutureBuilder<QuerySnapshot>(
      future: query.limit(150).get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text('No transactions found.'),
          );
        }
        var data = snapshot.data!.docs;
        return ListView.builder(
          shrinkWrap: true,
          itemCount: data.length,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            var cardData = data[index];
            return TransactionCard(
              data: cardData,
            );
          },
        );
      },
    );
  }
}
