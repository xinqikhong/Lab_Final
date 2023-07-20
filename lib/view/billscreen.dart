import 'dart:async';

import 'package:barterit/model/config.dart';
import 'package:barterit/model/user.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BillScreen extends StatefulWidget {
  final User user;
  final int sellerid;
  final double totalprice;

  const BillScreen({super.key, required this.user, required this.totalprice, required this.sellerid,});

  @override
  State<BillScreen> createState() => _BillScreenState();
}

class _BillScreenState extends State<BillScreen> {
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
          child: WebView(
            initialUrl:
                '${Config.server}/barterit/php/payment.php?sellerid=${widget.sellerid}&userid=${widget.user.id}&email=${widget.user.email}&name=${widget.user.name}&amount=${widget.totalprice}',
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              _controller.complete(webViewController);
            },
            navigationDelegate: (NavigationRequest request) {
              // Check if the URL contains 'payment_update.php' and 'html'
              if (request.url.contains('payment_update.php') &&
                  request.url.contains('html')) {
                // Process the HTML response from payment_update.php
                // Extract the response using JavaScript and send it to Dart
                _processPaymentUpdateResponse(request.url);
              }
              return NavigationDecision.navigate;
            },
            onProgress: (int progress) {
              // prg = progress as double;
              // setState(() {});
              // print('WebView is loading (progress : $progress%)');
            },
            onPageStarted: (String url) {
              // print('Page started loading: $url');
            },
            onPageFinished: (String url) {
              //print('Page finished loading: $url');
              setState(() {
                //isLoading = false;
              });
            },
          ),
        ));
  }
  // Function to extract and process the payment update response
  void _processPaymentUpdateResponse(String url) async {
    final Uri uri = Uri.parse(url);
    final Map<String, dynamic> queryParams = uri.queryParameters;

    if (queryParams.containsKey('html')) {
      // Fetch the HTML content from the 'html' query parameter
      String htmlContent = queryParams['html'] ?? '';

      // Process the HTML content as needed
      print(htmlContent); // Check the HTML content in the console
    }
  }
}