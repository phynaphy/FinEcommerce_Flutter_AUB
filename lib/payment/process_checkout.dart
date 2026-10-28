import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/payment/KHQR_payments/khqr_payment_screen.dart';
import 'package:flutter_application_ecommerce/payment/process_check_controller.dart';
import 'package:flutter_application_ecommerce/screen/add-to-cart/cart_screen.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  // ============================================================
  // COLORS
  // ============================================================

  static const Color primaryBlue = Color(0xFF06499F);

  // ============================================================
  // CONTROLLER
  // ============================================================

  late final ProcessCheckoutController processCheckoutController;

  // ============================================================
  // SELECTED PAYMENT METHOD
  // ============================================================

  final Rx<String?> selectedMethod = Rx<String?>(null);

  // ============================================================
  // INIT
  // ============================================================

@override
void initState() {
  super.initState();

  processCheckoutController = Get.isRegistered<ProcessCheckoutController>()
      ? Get.find<ProcessCheckoutController>()
      : Get.put(ProcessCheckoutController());

  selectedMethod.value =
      processCheckoutController.selectedPaymentMethod.value;
}

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    selectedMethod.close();
    super.dispose();
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F6F0),

      // ========================================================
      // APP BAR
      // ========================================================

      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),

        child: AppBar(
          backgroundColor: primaryBlue,
          elevation: 0,

          leading: IconButton(
            icon: Container(
              padding: const EdgeInsets.all(4),

              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),

              child: const Icon(
                Icons.close,
                color: primaryBlue,
                size: 20,
              ),
            ),

            onPressed: () {
              if (Get.key.currentState?.canPop() ?? false) {
                Get.back();
              } else {
                Get.off(
                  () => const CartScreen(),
                );
              }
            },
          ),

          title: Text(
            'Payment',
            style: GoogleFonts.spaceGrotesk(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),

          centerTitle: true,
        ),
      ),

      // ========================================================
      // BODY
      // ========================================================

      body: SafeArea(
        child: Obx(() {
          // ----------------------------------------------------
          // LOADING
          // ----------------------------------------------------

          if (processCheckoutController.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // ----------------------------------------------------
          // ERROR
          // ----------------------------------------------------

          if (processCheckoutController.errorMessage.value.isNotEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 50,
                    ),

                    const SizedBox(height: 16),

                    Text(
                      processCheckoutController.errorMessage.value,
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 16),

                    ElevatedButton(
                      onPressed: () {
                        processCheckoutController.loadCheckout();
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          // ----------------------------------------------------
          // CHECKOUT DATA
          // ----------------------------------------------------

          final checkout =
              processCheckoutController.checkout.value;

          if (checkout == null) {
            return const Center(
              child: Text(
                'No checkout data available',
              ),
            );
          }

          // ----------------------------------------------------
          // MAIN UI
          // ----------------------------------------------------

          return RefreshIndicator(
            onRefresh: () {
              return processCheckoutController.refreshCheckout();
            },

            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),

              padding: const EdgeInsets.all(16),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  // ==================================================
                  // DELIVERY
                  // ==================================================

                  Text(
                    'Delivery information',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade700,
                    ),
                  ),

                  const SizedBox(height: 8),

                  _buildDeliveryCard(checkout),

                  const SizedBox(height: 20),

                  // ==================================================
                  // ORDER SUMMARY
                  // ==================================================

                  Text(
                    'Order summary',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade700,
                    ),
                  ),

                  const SizedBox(height: 12),

                  _buildOrderItems(checkout),

                  const SizedBox(height: 20),

                  // ==================================================
                  // PAYMENT
                  // ==================================================

                  Text(
                    'Payment method',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade700,
                    ),
                  ),

                  const SizedBox(height: 12),

                  _buildPaymentOption(
                    id: 'ACLEDA_KHQR',
                    title: 'ACLEDA KHQR',
                    subtitle:
                        'Pay by ACLEDA App / Other bank App',
                    iconWidget: _buildPaymentIcon(
                      'assets/icons/khqr.png',
                    ),
                  ),

                  const SizedBox(height: 12),

                  _buildPaymentOption(
                    id: 'ACLEDA_MOBILE',
                    title: 'ACLEDA Mobile',
                    subtitle:
                        'Pay from bank / wallet account',
                    iconWidget: _buildPaymentIcon(
                      'assets/icons/acleda.png',
                    ),
                  ),

                  const SizedBox(height: 12),

                  _buildPaymentOption(
                    id: 'ABA_BANK',
                    title: 'ABA Bank',
                    subtitle:
                        'Pay directly in the ABA Mobile App',
                    iconWidget: _buildPaymentIcon(
                      'assets/icons/aba_round.png',
                    ),
                  ),

                  const SizedBox(height: 30),

                  // ==================================================
                  // CONFIRM
                  // ==================================================

                  Text(
                    'Confirm payment',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade700,
                    ),
                  ),

                  const SizedBox(height: 12),

                  _buildConfirmButton(),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  // ============================================================
  // DELIVERY CARD
  // ============================================================

  Widget _buildDeliveryCard(dynamic checkout) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(16),

        border: Border.all(
          color: primaryBlue.withOpacity(0.15),
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          // ADDRESS

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              const Icon(
                Icons.location_on_rounded,
                color: primaryBlue,
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      'Delivery address',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      checkout.shippingAddress,
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // PHONE

          Row(
            children: [
              const Icon(
                Icons.phone,
                color: primaryBlue,
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      'Phone number',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      checkout.phoneNumber,
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // NOTES

          if (checkout.notes.isNotEmpty) ...[
            const SizedBox(height: 16),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                const Icon(
                  Icons.notes,
                  color: primaryBlue,
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(
                        'Notes',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        checkout.notes,
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  // ============================================================
  // ORDER ITEMS
  // ============================================================

  Widget _buildOrderItems(dynamic checkout) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(16),

        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),

      child: Column(
        children: [
          ...checkout.items.map<Widget>(
            (item) {
              return Padding(
                padding: const EdgeInsets.only(
                  bottom: 12,
                ),

                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,

                        children: [
                          Text(
                            item.name,
                            style:
                                GoogleFonts.spaceGrotesk(
                              fontWeight:
                                  FontWeight.w600,
                            ),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            'Qty: ${item.quantity}',
                            style:
                                GoogleFonts.spaceGrotesk(
                              fontSize: 12,
                              color:
                                  Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Text(
                      '\$${(item.price * item.quantity).toStringAsFixed(2)}',
                      style:
                          GoogleFonts.spaceGrotesk(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          const Divider(),

          _buildPriceRow(
            'Subtotal',
            checkout.subtotal,
          ),

          const SizedBox(height: 8),

          _buildPriceRow(
            'Shipping',
            checkout.shippingFee,
          ),

          const SizedBox(height: 8),

          const Divider(),

          const SizedBox(height: 8),

          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,

            children: [
              Text(
                'Total',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),

              Text(
                '\$${checkout.total.toStringAsFixed(2)}',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: primaryBlue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // PRICE ROW
  // ============================================================

  Widget _buildPriceRow(
    String title,
    double value,
  ) {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,

      children: [
        Text(
          title,
          style: GoogleFonts.spaceGrotesk(
            color: Colors.grey.shade700,
          ),
        ),

        Text(
          '\$${value.toStringAsFixed(2)}',
          style: GoogleFonts.spaceGrotesk(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // PAYMENT ICON
  // ============================================================

  Widget _buildPaymentIcon(String asset) {
    return Container(
      width: 48,
      height: 48,

      padding: const EdgeInsets.all(6),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(12),

        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),

      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),

        child: Image.asset(
          asset,
          width: 36,
          height: 36,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  // ============================================================
  // PAYMENT OPTION
  // ============================================================

  Widget _buildPaymentOption({
    required String id,
    required String title,
    required String subtitle,
    required Widget iconWidget,
  }) {
    return Obx(() {
      final bool isSelected =
          selectedMethod.value == id;

      return GestureDetector(
        onTap: () {
          selectedMethod.value = id;
        },

        child: Container(
          padding: const EdgeInsets.all(16),

          decoration: BoxDecoration(
            color: Colors.white,

            borderRadius:
                BorderRadius.circular(16),

            border: Border.all(
              color: isSelected
                  ? primaryBlue
                  : Colors.grey.shade200,

              width: isSelected ? 2 : 1,
            ),

            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.05),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),

          child: Row(
            children: [
              iconWidget,

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [
                    Text(
                      title,
                      style:
                          GoogleFonts.spaceGrotesk(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      subtitle,
                      style:
                          GoogleFonts.spaceGrotesk(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),

              Radio<String>(
                value: id,

                groupValue:
                    selectedMethod.value,

                activeColor: primaryBlue,

                onChanged: (String? value) {
                  selectedMethod.value = value;
                },
              ),
            ],
          ),
        ),
      );
    });
  }

  // ============================================================
  // CONFIRM BUTTON
  // ============================================================

  Widget _buildConfirmButton() {
    return Obx(() {
      final bool isSelected =
          selectedMethod.value != null;

      final bool isSubmitting =
          processCheckoutController.isSubmitting.value;

      return GestureDetector(
        onTap: (!isSelected || isSubmitting)
            ? null
            : _processCheckout,

        child: Container(
          width: double.infinity,
          height: 56,

          decoration: BoxDecoration(
            color: isSelected
                ? primaryBlue
                : Colors.grey.shade200,

            borderRadius:
                BorderRadius.circular(28),

            border: Border.all(
              color: isSelected
                  ? Colors.transparent
                  : Colors.grey.shade300,
            ),
          ),

          child: Center(
            child: isSubmitting
                ? const SizedBox(
                    width: 24,
                    height: 24,

                    child:
                        CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center,

                    children: [
                      Text(
                        isSelected
                            ? 'Confirm & Proceed'
                            : 'Select a payment method above',

                        style:
                            GoogleFonts.spaceGrotesk(
                          color: isSelected
                              ? Colors.white
                              : Colors.grey.shade600,

                          fontSize: 16,

                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      const SizedBox(width: 8),

                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16,

                        color: isSelected
                            ? Colors.white
                            : Colors.grey.shade600,
                      ),
                    ],
                  ),
          ),
        ),
      );
    });
  }

  // ============================================================
  // PROCESS CHECKOUT
  // ============================================================

  
Future<void> _processCheckout() async {
  final String? method = selectedMethod.value;

  if (method == null) {
    Get.snackbar(
      'Select Payment',
      'Please select a payment method.',
    );
    return;
  }

  // Only this method is currently connected to the
  // ACLEDA KHQR payment-session API.
  if (method != 'ACLEDA_KHQR') {
    Get.snackbar(
      'Payment Not Available',
      'Only ACLEDA KHQR is currently connected.',
      snackPosition: SnackPosition.BOTTOM,
    );
    return;
  }

  final result = await processCheckoutController
      .submitCheckout(method);

  if (!mounted || result == null) {
    return;
  }

  debugPrint('CHECKOUT AND PAYMENT RESPONSE: $result');

  final qrBase64 = (result['qrBase64'] ?? '').toString();
  final qrValue = (result['qrValue'] ?? '').toString();

  if (qrBase64.isEmpty && qrValue.isEmpty) {
    Get.snackbar(
      'KHQR Not Available',
      'The order was created, but the payment API did not return QR data.',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 5),
    );
    return;
  }

  Get.to(
    () => KhqrPaymentScreen(
      paymentData: Map<String, dynamic>.from(result),
    ),
  );
}

}