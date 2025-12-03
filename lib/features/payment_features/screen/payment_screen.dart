import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentPage extends StatefulWidget {
  final int amount;

  const PaymentPage({super.key, required this.amount});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  late final WebViewController _controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    final callbackUrl = "myapp://payment-result";
    final paymentUrl =
        "https://flyaway.codeplusdev.ir/api/pay?amount=${widget.amount}&callback=$callbackUrl";

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            final url = request.url;

            // وقتی درگاه دیپ‌لینک رو صدا زد:
            // myapp://payment-result?status=success&amount=...&trackingCode=...
            if (url.startsWith("myapp://payment-result")) {
              Navigator.pop(context, url); // URL را به صفحه قبل برمی‌گردانیم
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
          onPageStarted: (_) {
            setState(() => isLoading = true);
          },
          onPageFinished: (_) {
            setState(() => isLoading = false);
          },
        ),
      )
      ..loadRequest(Uri.parse(paymentUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
