import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'profile_information_controller.dart';

class ProfileInformationView extends StatelessWidget {
  const ProfileInformationView({super.key});

  static const Color primaryBlue = Color(0xFF06499F);
  static const Color backgroundColor = Color(0xFFF8F9FB);
  static const Color borderColor = Color(0xFFD9DEE7);
  static const Color textColor = Color(0xFF111827);
  static const Color grayText = Color(0xFF6B7280);

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<ProfileInformationController>()
        ? Get.find<ProfileInformationController>()
        : Get.put(ProfileInformationController());

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: Get.back,
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 20,
            color: grayText,
          ),
        ),
        title: const Text(
          'Personal Info',
          style: TextStyle(
            color: primaryBlue,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            onPressed: controller.onNotificationPressed,
            icon: const Icon(
              Icons.notifications_none_outlined,
              color: grayText,
              size: 24,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
            child: Form(
              key: controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Stack(
                      children: [
                        Obx(() {
                          final File? imageFile =
                              controller.selectedImage.value;
                          final String? imageUrl =
                              controller.profilePictureUrl.value;

                          return Container(
                            width: 88,
                            height: 88,
                            decoration: const BoxDecoration(
                              color: Color(0xFFDCE8FF),
                              shape: BoxShape.circle,
                            ),
                            child: ClipOval(
                              child: imageFile != null
                                  ? Image.file(
                                      imageFile,
                                      width: 88,
                                      height: 88,
                                      fit: BoxFit.cover,
                                    )
                                  : (imageUrl != null && imageUrl.isNotEmpty)
                                      ? Image.network(
                                          imageUrl,
                                          width: 88,
                                          height: 88,
                                          fit: BoxFit.cover,
                                          loadingBuilder:
                                              (context, child, progress) {
                                            if (progress == null) return child;
                                            return const Center(
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                              ),
                                            );
                                          },
                                          errorBuilder: (_, __, ___) {
                                            return const Icon(
                                              Icons.person,
                                              size: 48,
                                              color: primaryBlue,
                                            );
                                          },
                                        )
                                      : const Icon(
                                          Icons.person,
                                          size: 48,
                                          color: primaryBlue,
                                        ),
                            ),
                          );
                        }),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: GestureDetector(
                            onTap: controller.pickProfileImage,
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: primaryBlue,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: backgroundColor,
                                  width: 2,
                                ),
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                size: 15,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Center(
                    child: Text(
                      'Profile Details',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Center(
                    child: Text(
                      'Update your account information to keep your profile secure and accurate.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.4,
                        color: grayText,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  _buildLabel('Full Name'),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: controller.fullNameController,
                    validator: controller.validateName,
                    textCapitalization: TextCapitalization.words,
                    suffixIcon: const Icon(
                      Icons.edit_outlined,
                      size: 20,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),

                  const SizedBox(height: 20),
                  _buildLabel('Email Address'),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: controller.emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: controller.validateEmail,
                    suffixIcon: const Icon(
                      Icons.email_outlined,
                      size: 20,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Use an email address you can access.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),

                  const SizedBox(height: 20),
                  _buildLabel('Phone Number'),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: controller.phoneController,
                    keyboardType: TextInputType.phone,
                    validator: controller.validatePhone,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'[0-9+\-\s()]'),
                      ),
                    ],
                    suffixIcon: const Icon(
                      Icons.phone_outlined,
                      size: 20,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Enter 8–15 digits, including your country code if needed.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),

                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: Obx(
                      () => ElevatedButton.icon(
                        onPressed: controller.isSaving.value
                            ? null
                            : controller.saveChanges,
                        icon: controller.isSaving.value
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.save_outlined, size: 20),
                        label: Text(
                          controller.isSaving.value
                              ? 'Saving...'
                              : 'Save Changes',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryBlue,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor:
                              primaryBlue.withValues(alpha: 0.6),
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton(
                      onPressed: controller.isSaving.value
                          ? null
                          : controller.cancelChanges,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: primaryBlue,
                        side: const BorderSide(
                          color: Color(0xFFD5E0F5),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F3F6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.shield_outlined,
                          size: 22,
                          color: primaryBlue,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Privacy & Security',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: textColor,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Keep your account information accurate and protect your login credentials.',
                                style: TextStyle(
                                  fontSize: 12,
                                  height: 1.4,
                                  color: grayText,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    Widget? suffixIcon,
    TextInputType? keyboardType,
    TextCapitalization textCapitalization = TextCapitalization.none,
    String? Function(String?)? validator,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      validator: validator,
      inputFormatters: inputFormatters,
      style: const TextStyle(
        fontSize: 15,
        color: textColor,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: primaryBlue,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Colors.redAccent,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}
