import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dinetime_mobile_mvp/services/services.dart';
import 'package:dinetime_mobile_mvp/theme/designsystem.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../../blocs/preorderbag/preorderbag_bloc.dart';

import 'package:dinetime_mobile_mvp/.env';

Future<void> makePayment(String amount) async {
  try {
    //STEP 1: Create Payment Intent
    // All payments are in cents, so 1000 = $ 10
    var paymentIntent = await createPaymentIntent('1000', 'USD');

    //STEP 2: Initialize Payment Sheet
    await Stripe.instance
        .initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
                paymentIntentClientSecret: paymentIntent![
                    'client_secret'], //Gotten from payment intent
                style: ThemeMode.light,
                merchantDisplayName: 'DineTime'))
        .then((value) {});
    //STEP 3: Display Payment sheet
    displayPaymentSheet();
  } catch (err) {
    throw Exception(err);
  }
}

createPaymentIntent(String amount, String currency) async {
  try {
    Map<String, dynamic> body = {
      'amount': amount,
      'currency': currency,
    };

    var response = await http.post(
      Uri.parse('https://api.stripe.com/v1/payment_intents'),
      headers: {
        'Authorization': 'Bearer $stripeSecretKey',
        'Content-Type': 'application/x-www-form-urlencoded'
      },
      body: body,
    );
    return json.decode(response.body);
  } catch (err) {
    throw Exception(err.toString());
  }
}

displayPaymentSheet() async {
  try {
    await Stripe.instance.presentPaymentSheet().then((value) {
      print("Payment Successful");
      // Add logic for handling preorder backend
    });
  } catch (e) {
    // Do nothing
    print('$e');
    print("Payment unsuccessful");
  }
}
