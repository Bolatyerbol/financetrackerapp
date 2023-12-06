import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:habit/utils/appvalidator.dart';
import 'package:habit/widgets/category_dropdown.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class AddTransactionsForm extends StatefulWidget {
  const AddTransactionsForm({super.key});

  @override
  State<AddTransactionsForm> createState() => _AddTransactionsFormState();
}

class _AddTransactionsFormState extends State<AddTransactionsForm> {
  var type = 'credit';
  var category = 'Others';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var isLoader = false;
  var appValidator = AppValidator();
  var amountEditController = TextEditingController();
  var titleEditController = TextEditingController();
  var uid = const Uuid();

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoader = true;
      });
      final user = FirebaseAuth.instance.currentUser;
      int timestamp = DateTime.now().millisecondsSinceEpoch;
      var amount = int.parse(amountEditController.text);
      DateTime date = DateTime.now();

      var id = uid.v4();
      String monthyear = DateFormat('MMM y').format(date);

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();
      int remainingAmount = userDoc['remainingAmount'];
      int totalCredit = userDoc['totalCredit'];
      int totalDebit = userDoc['totalDebit'];

      if (type == 'credit') {
        remainingAmount += amount;
        totalCredit += amount;
      } else {
        remainingAmount -= amount;
        totalDebit -= amount;
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'remainingAmount': remainingAmount,
        'totalCredit': totalCredit,
        'totalDebit': totalDebit,
        'updatedAt': timestamp,
      });

      var data = {
        'id': id,
        'title': titleEditController.text,
        'amount': amount,
        'type': type,
        'timestamp': timestamp,
        'totalCredit': totalCredit,
        'totalDebit': totalDebit,
        'remainingAmount': remainingAmount,
        'monthyear': monthyear,
        'category': category,
      };

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('transactions')
          .doc(id)
          .set(data);

      // await authService.login(data, context);

      Navigator.pop(context);

      setState(
        () {
          isLoader = false;
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: titleEditController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: appValidator.isEmptyCheck,
              decoration: const InputDecoration(
                labelText: 'Title',
              ),
            ),
            TextFormField(
              controller: amountEditController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: appValidator.isEmptyCheck,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Amount',
              ),
            ),
            CategoryDropDown(
              cattype: category,
              onChanged: (String? value) {
                if (value != null) {
                  setState(() {
                    category = value;
                  });
                }
              },
            ),
            DropdownButtonFormField(
              value: 'credit',
              items: const [
                DropdownMenuItem(
                  value: 'credit',
                  child: Text('Credit'),
                ),
                DropdownMenuItem(
                  value: 'debit',
                  child: Text('Debit'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(
                    () {
                      type = value;
                    },
                  );
                }
              },
            ),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton(
              onPressed: () {
                if (isLoader == false) {
                  _submitForm();
                }
              },
              child: isLoader
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : const Text('Add Transaction'),
            ),
          ],
        ),
      ),
    );
  }
}
