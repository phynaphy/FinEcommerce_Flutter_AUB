import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ProfileInformationController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final dateOfBirthController = TextEditingController();

  final Rx<File?> selectedImage = Rx<File?>(null);
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadInitialUserData();
  }

  void _loadInitialUserData() {
    if (Get.arguments != null && Get.arguments is Map<String, dynamic>) {
      final args = Get.arguments as Map<String, dynamic>;
      fullNameController.text = args['fullName'] ?? '';
      emailController.text = args['email'] ?? '';
      phoneController.text = args['phone'] ?? '';
      dateOfBirthController.text = args['dob'] ?? '';
    }
  }

  void onNotificationPressed() {
    Get.snackbar(
      'Notice',
      'Notification screen is not configured yet.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void onBackButtonPressed() {
    Get.back(result: null);
  }

  void cancelChanges() {
    Get.back(result: null);
  }

  Future<void> pickProfileImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (image != null) {
        selectedImage.value = File(image.path);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick image: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }

  Future<void> selectDateOfBirth(BuildContext context) async {
    DateTime initialDate = DateTime(2000);
    if (dateOfBirthController.text.isNotEmpty) {
      try {
        initialDate = DateTime.parse(dateOfBirthController.text);
      } catch (_) {
        initialDate = DateTime(2000);
      }
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1940),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      dateOfBirthController.text =
          "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
    }
  }

  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name cannot be empty';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || !GetUtils.isEmail(value.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Enter a valid phone number';
    }
    return null;
  }

  Future<void> saveChanges() async {
    final currentState = formKey.currentState;
    if (currentState == null || !currentState.validate()) return;

    isLoading.value = true;

    try {
      String? uploadedImageUrl;

      if (selectedImage.value != null) {
        final uri = Uri.parse('https://your-backend-api.com/api/profile/upload-image');
        final request = http.MultipartRequest('POST', uri);

        final multipartFile = await http.MultipartFile.fromPath(
          'image',
          selectedImage.value!.path,
        );
        request.files.add(multipartFile);

        final streamedResponse = await request.send();
        final response = await http.Response.fromStream(streamedResponse);

        if (response.statusCode == 200 || response.statusCode == 201) {
          final responseData = jsonDecode(response.body);
          uploadedImageUrl = responseData['imageUrl'] ?? responseData['data']?['url'];
        } else {
          throw Exception('Failed to upload image. Status: ${response.statusCode}');
        }
      }

      isLoading.value = false;

      final updatedProfileData = {
        'fullName': fullNameController.text.trim(),
        'email': emailController.text.trim(),
        'phone': phoneController.text.trim(),
        'dob': dateOfBirthController.text.trim(),
        'image': selectedImage.value,
        'imageUrl': uploadedImageUrl,
      };

      Get.back(result: updatedProfileData);

      Get.snackbar(
        'Success',
        'Profile updated successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF16A34A),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(16),
      );
    } catch (e) {
      isLoading.value = false;

      Get.snackbar(
        'Error',
        'Failed to save profile: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
    }
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