
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ProfileInformationController extends GetxController {
  final fullNameController =
      TextEditingController(text: 'Alexander Sterling');

  final emailController =
      TextEditingController(text: 'alexander.s@financecore.io');

  final phoneController =
      TextEditingController(text: '+1 (555) 012-3456');

  final dateOfBirthController =
      TextEditingController(text: '14/05/1992');

  Future<void> selectDateOfBirth(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(1992, 5, 14),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      dateOfBirthController.text =
          DateFormat('dd/MM/yyyy').format(pickedDate);
    }
  }

  void saveChanges() {
    Get.snackbar(
      'Success',
      'Profile information updated successfully',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void cancelChanges() {
    fullNameController.text = 'Alexander Sterling';
    emailController.text = 'alexander.s@financecore.io';
    phoneController.text = '+1 (555) 012-3456';
    dateOfBirthController.text = '14/05/1992';
  }

  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    dateOfBirthController.dispose();

    super.onClose();
  }
}