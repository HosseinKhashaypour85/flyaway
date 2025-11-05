import 'package:flutter/material.dart';
import 'package:flyaway/config/app_config/app_theme_config/theme_service.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class BuyTicketScreen extends StatefulWidget {
  const BuyTicketScreen({super.key});

  @override
  State<BuyTicketScreen> createState() => _BuyTicketScreenState();
}

class _BuyTicketScreenState extends State<BuyTicketScreen> {
  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments;
    final ticketType = arguments['ticket_type'];
    final ThemeService themeService = ThemeService();
    return Scaffold(appBar: AppBar(backgroundColor: Theme.of(context).appBarTheme.backgroundColor,),);
  }
}
