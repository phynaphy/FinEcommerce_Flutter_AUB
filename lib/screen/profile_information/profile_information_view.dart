import 'package:flutter/material.dart';
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
    // Inject the controller here so it is guaranteed to exist
    final controller = Get.put(ProfileInformationController());

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: true,
       leading: IconButton(
  onPressed: () {
    Navigator.pop(context);
  },
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // PROFILE AVATAR WITH EDIT TRIGGER
                Center(
                  child: Stack(
                    children: [
                      Obx(() {
                        final imageFile = controller.selectedImage.value;
                        return Container(
                          width: 80,
                          height: 80,
                          decoration: const BoxDecoration(
                            color: Color(0xFFDCE8FF),
                            shape: BoxShape.circle,
                          ),
                          child: ClipOval(
                            child: imageFile != null
                                ? Image.file(
                                    imageFile,
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
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
                            width: 28,
                            height: 28,
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
                              size: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // TITLE & SUBTITLE
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

                // FULL NAME
                _buildLabel('Full Name'),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: controller.fullNameController,
                  validator: controller.validateName,
                  suffixIcon: const Icon(
                    Icons.edit_outlined,
                    size: 20,
                    color: Color(0xFF9CA3AF),
                  ),
                ),

                const SizedBox(height: 20),

                // EMAIL ADDRESS
                _buildLabel('Email Address'),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: controller.emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: controller.validateEmail,
                  suffixIcon: Container(
                    margin: const EdgeInsets.only(right: 8, top: 6, bottom: 6),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8FAF1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.verified,
                          size: 14,
                          color: Color(0xFF16A34A),
                        ),
                        SizedBox(width: 4),
                        Text(
                          'VERIFIED',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF16A34A),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Primary contact method for security alerts.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF9CA3AF),
                  ),
                ),

                const SizedBox(height: 20),

                // PHONE NUMBER
                _buildLabel('Phone Number'),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: controller.phoneController,
                  keyboardType: TextInputType.phone,
                  validator: controller.validatePhone,
                  suffixIcon: const Icon(
                    Icons.phone_outlined,
                    size: 20,
                    color: Color(0xFF9CA3AF),
                  ),
                ),

                const SizedBox(height: 20),

                // DATE OF BIRTH
                _buildLabel('Date of Birth'),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: controller.dateOfBirthController,
                  readOnly: true,
                  onTap: () => controller.selectDateOfBirth(context),
                  suffixIcon: const Icon(
                    Icons.calendar_today_outlined,
                    size: 20,
                    color: Color(0xFF6B7280),
                  ),
                ),

                const SizedBox(height: 32),

                // SAVE BUTTON WITH LOADING STATE
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: Obx(() {
                    return ElevatedButton.icon(
                      onPressed: controller.isLoading.value
                          ? null
                          : controller.saveChanges,
                      icon: controller.isLoading.value
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
                        controller.isLoading.value ? 'Saving...' : 'Save Changes',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryBlue,
                        foregroundColor: Colors.white,
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                  }),
                ),

                const SizedBox(height: 12),

                // CANCEL BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton(
                    onPressed: controller.cancelChanges,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: primaryBlue,
                      side: const BorderSide(color: Color(0xFFD5E0F5)),
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

                // PRIVACY CARD
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
                              'Your data is encrypted using AES-256 standards. We never share your personal details with third-party marketers.',
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
        ),
      ),
      // bottomNavigationBar: _buildBottomNavigationBar(),
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
    bool readOnly = false,
    VoidCallback? onTap,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      readOnly: readOnly,
      onTap: onTap,
      validator: validator,
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
          borderSide: const BorderSide(color: primaryBlue, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      height: 68,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Color(0xFFE5E7EB)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildBottomItem(
            icon: Icons.home_outlined,
            title: 'Home',
            selected: false,
            onTap: () => Get.offNamed('/home'),
          ),
          _buildBottomItem(
            icon: Icons.grid_view_outlined,
            title: 'Categories',
            selected: false,
            onTap: () => Get.offNamed('/categories'),
          ),
          _buildBottomItem(
            icon: Icons.person,
            title: 'Profile',
            selected: true,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildBottomItem({
    required IconData icon,
    required String title,
    required bool selected,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 30,
              decoration: selected
                  ? BoxDecoration(
                      color: const Color(0xFFDCE8FF),
                      borderRadius: BorderRadius.circular(16),
                    )
                  : null,
              child: Icon(
                icon,
                size: 22,
                color: selected ? primaryBlue : const Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              title,
              style: TextStyle(
                fontSize: 11,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                color: selected ? primaryBlue : const Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ),
    );
  }
}