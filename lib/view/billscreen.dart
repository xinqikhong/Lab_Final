import 'dart:async';

import 'package:barterit/model/config.dart';
import 'package:barterit/model/user.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BillScreen extends StatefulWidget {
  final User user;
  final int sellerid;
  final double totalprice;
   final Function() onPaymentSuccess;

  const BillScreen({super.key, required this.user, required this.totalprice, required this.sellerid, required this.onPaymentSuccess,});

  @override
  State<BillScreen> createState() => _BillScreenState();
}

class _BillScreenState extends State<BillScreen> {
  bool _paymentSuccessful = false;
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bill"),
      ),
      body: Center(
        child: _paymentSuccessful
            ? _buildSuccessMessage()
            : WebView(
                initialUrl:
                    '${Config.server}/barterit/php/payment.php?sellerid=${widget.sellerid}&userid=${widget.user.id}&email=${widget.user.email}&name=${widget.user.name}&amount=${widget.totalprice}',
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (WebViewController webViewController) {
                  _controller.complete(webViewController);
                },
                onPageFinished: (String url) {
                  // Detect if the payment details are being displayed on the Billplz page
                  if (url.contains("billplz_payment_faker/faker/checkout")) {
                    // Set a timer to simulate the payment process (adjust the duration if needed)
                    Timer(Duration(seconds: 5), () {
                      setState(() {
                        _paymentSuccessful = true;
                      });
                    });
                  }
                },
              ),
      ),
    );
  }

  Widget _buildSuccessMessage() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        "Payment Successful",
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 16),
      Text(
        "Amount Paid: RM ${widget.totalprice.toStringAsFixed(2)}",
        style: TextStyle(fontSize: 16),
      ),
      SizedBox(height: 16),
      ElevatedButton(
        onPressed: () {
          // Call the callback function to update the cart and order status
          widget.onPaymentSuccess();
          
          // Redirect back to the main screen when the "OK" button is pressed
          Navigator.pop(context); // Go back to the previous screen
        },
        child: Text("OK"),
      ),
    ],
  );
}

}