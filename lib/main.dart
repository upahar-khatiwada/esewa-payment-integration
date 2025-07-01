import 'package:esewa_flutter_sdk/esewa_flutter_sdk.dart';
import 'package:esewa_flutter_sdk/esewa_payment.dart';
import 'package:esewa_flutter_sdk/esewa_payment_success_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:esewa_flutter_sdk/esewa_config.dart';
import 'package:logger/logger.dart';

final Logger logger = Logger();

void main() async {
  await dotenv.load(fileName: '.env');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final String CLIENT_ID = dotenv.env['CLIENT_ID']!;
  final String SECRET_KEY = dotenv.env['SECRET_KEY']!;

  @override
  Widget build(BuildContext context) {
    EsewaConfig config = EsewaConfig(
      environment: Environment.test, // or Environment.live
      clientId: CLIENT_ID,
      secretId: SECRET_KEY,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: ElevatedButton.icon(
            onPressed: () {
              EsewaFlutterSdk.initPayment(
                esewaConfig: EsewaConfig(
                  environment: Environment.test,
                  clientId: CLIENT_ID,
                  secretId: SECRET_KEY,
                ),
                esewaPayment: EsewaPayment(
                  productId: "1234",
                  productName: "Demo Product",
                  productPrice: "1000",
                  callbackUrl: "https://example.com/callback",
                ),
                onPaymentSuccess: (data) {
                  logger.i('--Success: $data', time: DateTime.now());
                },
                onPaymentFailure: (error) {
                  logger.e('--Failure: $error', time: DateTime.now());
                },
                onPaymentCancellation: () {
                  logger.i('Cancelled!');
                },
              );
            },

            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            label: Text('Esewa Payment'),
            icon: Icon(Icons.payment),
          ),
        ),
      ),
    );
  }
}
