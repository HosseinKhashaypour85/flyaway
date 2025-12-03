import 'dart:io';
import 'package:get/get.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';

import '../services/buy_ticket_services.dart';

class BuyTicketController extends GetxController {
  final BuyTicketServices _service = BuyTicketServices();

  var isLoading = false.obs;
  var errorMessage = ''.obs;

  /// وضعیت پرداخت بعد از برگشت از درگاه
  var paymentStatus = ''.obs;
  var trackingCode = ''.obs;

  // -----------------------------------------------------------
  //                  BUY TICKET API
  // -----------------------------------------------------------
  Future<Map<String, dynamic>?> buyTicket({
    required String id,
    required String buyerEmail,
    required String origin,
    required String destination,
    required String ticketTime,
    required int amountPaid,
    required String ticketType,
    required int passengersAmount,
  }) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await _service.callBuyTicketApi(
        id: id,
        buyerEmail: buyerEmail,
        origin: origin,
        destination: destination,
        ticketTime: ticketTime,
        amountPaid: amountPaid,
        ticketType: ticketType,
        passengersAmount: passengersAmount,
      );

      isLoading.value = false;

      if (response == null) {
        errorMessage.value = "Server not responding!";
        return null;
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Map<String, dynamic>.from(response.data);
      } else {
        errorMessage.value =
            response.data?["message"]?.toString() ?? "Request failed!";
        return null;
      }
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = e.toString();
      return null;
    }
  }

  // -----------------------------------------------------------
  //                  GENERATE PDF
  // -----------------------------------------------------------
  Future<File?> generateTicketPdf({
    required String buyerEmail,
    required String origin,
    required String destination,
    required String ticketTime,
    required int amountPaid,
    required String ticketType,
    required int passengersAmount,
    required String trackingCode,
  }) async {
    try {
      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Container(
              padding: const pw.EdgeInsets.all(20),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    "FlyAway Ticket",
                    style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 20),
                  pw.Text("Passenger email: $buyerEmail"),
                  pw.Text("Origin: $origin"),
                  pw.Text("Destination: $destination"),
                  pw.Text("Travel date: $ticketTime"),
                  pw.Text("Ticket type: $ticketType"),
                  pw.Text("Passengers: $passengersAmount"),
                  pw.Text("Amount paid: $amountPaid تومان"),
                  pw.Text("Tracking code: $trackingCode"),
                ],
              ),
            );
          },
        ),
      );

      final dir = await getTemporaryDirectory();
      final file = File("${dir.path}/FlyAway_Ticket_$trackingCode.pdf");
      await file.writeAsBytes(await pdf.save());
      return file;
    } catch (e) {
      print("❌ PDF create error: $e");
      return null;
    }
  }

  // -----------------------------------------------------------
  //                  SHARE PDF
  // -----------------------------------------------------------
  Future<void> sharePdfFile(File file) async {
    await Printing.sharePdf(
      bytes: await file.readAsBytes(),
      filename: file.path.split("/").last,
    );
  }
}
