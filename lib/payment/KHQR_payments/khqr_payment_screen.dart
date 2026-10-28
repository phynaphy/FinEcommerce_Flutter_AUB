
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class KhqrPaymentScreen extends StatelessWidget {
  final Map<String, dynamic> paymentData;

  const KhqrPaymentScreen({
    super.key,
    required this.paymentData,
  });

  static const Color primaryBlue = Color(0xFF06499F);

  String get qrBase64 =>
      (paymentData['qrBase64'] ?? '').toString();

  String get qrValue =>
      (paymentData['qrValue'] ?? '').toString();

  String get trackingNumber =>
      (paymentData['trackingNumber'] ?? 'N/A').toString();

  String get orderId =>
      (paymentData['orderId'] ?? paymentData['id'] ?? 'N/A')
          .toString();

  double get totalAmount {
    final value = paymentData['totalAmount'] ??
        paymentData['total'] ??
        0;

    return double.tryParse(value.toString()) ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final hasQrImage = qrBase64.isNotEmpty;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F6F0),
      appBar: AppBar(
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Pay with KHQR',
          style: GoogleFonts.spaceGrotesk(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 8),

              const Icon(
                Icons.verified_outlined,
                color: primaryBlue,
                size: 42,
              ),

              const SizedBox(height: 8),

              Text(
                'Scan to Pay',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Open ACLEDA or another supported banking app '
                'and scan this KHQR code.',
                textAlign: TextAlign.center,
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                ),
              ),

              const SizedBox(height: 24),

              // QR CODE IMAGE
             
Container(
  width: double.infinity,
  padding: const EdgeInsets.all(20),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(24),
    border: Border.all(
      color: primaryBlue.withOpacity(0.12),
    ),
    boxShadow: [
      BoxShadow(
        color: primaryBlue.withOpacity(0.07),
        blurRadius: 24,
        offset: const Offset(0, 8),
      ),
    ],
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      // KHQR HEADER
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFEAF2FF),
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Icon(
              Icons.qr_code_2_rounded,
              color: primaryBlue,
              size: 27,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'KHQR PAYMENT',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF172B4D),
                ),
              ),
              const SizedBox(height: 3),
              Text(
                'Scan with your banking app',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ],
      ),

      const SizedBox(height: 22),

      // FULL QR IMAGE
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFD),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.grey.shade200,
          ),
        ),
        child: Center(
          child: hasQrImage
              ? Image.memory(
                  base64Decode(
                    qrBase64.replaceFirst(
                      RegExp(r'^data:image/[^;]+;base64,'),
                      '',
                    ),
                  ),
                  width: 260,
                  height: 260,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const SizedBox(
                      width: 260,
                      height: 200,
                      child: Center(
                        child: Icon(
                          Icons.broken_image_outlined,
                          size: 48,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  },
                )
              : const SizedBox(
                  width: 260,
                  height: 200,
                  child: Center(
                    child: Text('QR code is not available'),
                  ),
                ),
        ),
      ),

      const SizedBox(height: 22),

      // PAYMENT AMOUNT
   

    

      // ORDER INFORMATION
      Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F7FA),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.receipt_long_outlined,
              color: primaryBlue,
              size: 21,
            ),
           
            const Icon(
              Icons.lock_outline_rounded,
              color: Colors.grey,
              size: 17,
            ),
          ],
        ),
      ),

      const SizedBox(height: 16),

      // SCAN INSTRUCTION
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: primaryBlue,
            size: 17,
          ),
          const SizedBox(width: 7),
          Flexible(
            child: Text(
              'Keep the entire QR code visible when scanning.',
              textAlign: TextAlign.center,
              style: GoogleFonts.spaceGrotesk(
                fontSize: 11,
                color: Colors.grey.shade600,
              ),
            ),
          ),
        ],
      ),
    ],
  ),
),


              const SizedBox(height: 20),

              // ORDER DETAILS
              // Container(
              //   width: double.infinity,
              //   padding: const EdgeInsets.all(16),
              //   decoration: BoxDecoration(
              //     color: Colors.white,
              //     borderRadius: BorderRadius.circular(16),
              //   ),
              //   child: Column(
              //     children: [
              //       _detailRow('Tracking number', trackingNumber),
              //       const Divider(height: 24),
              //       _detailRow(
              //         'Payment status',
              //         (paymentData['status'] ?? 'PENDING').toString(),
              //       ),
              //       const Divider(height: 24),
              //       _detailRow('Payment method', 'ACLEDA KHQR'),
              //     ],
              //   ),
              // ),

              const SizedBox(height: 20),

              // COPY KHQR STRING
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton.icon(
                  onPressed: qrValue.isEmpty
                      ? null
                      : () async {
                          await Clipboard.setData(
                            ClipboardData(text: qrValue),
                          );

                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'KHQR payment string copied.',
                                ),
                              ),
                            );
                          }
                        },
                  icon: const Icon(Icons.copy),
                  label: Text(
                    'Copy KHQR Payment String',
                    style: GoogleFonts.spaceGrotesk(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              Text(
                'Please verify the amount in your banking app '
                'before confirming payment.',
                textAlign: TextAlign.center,
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 12,
                  color: Colors.grey.shade700,
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryBlue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    'Back to Checkout',
                    style: GoogleFonts.spaceGrotesk(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.spaceGrotesk(
              color: Colors.grey.shade600,
              fontSize: 13,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: GoogleFonts.spaceGrotesk(
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }
}
