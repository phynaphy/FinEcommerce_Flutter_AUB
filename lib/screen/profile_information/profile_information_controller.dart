      // 'http://192.168.56.1:8080/api/v1/mobile';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileInformationController extends GetxController {
  // Android emulator. For a physical phone, use your computer's LAN IP.
  // Make sure this IP is reachable from the device running the app.
  static const String baseUrl =
      'http://192.168.56.1:8080/api/v1/mobile';

  final formKey = GlobalKey<FormState>();

  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  final Rxn<File> selectedImage = Rxn<File>();
  final RxnString profilePictureUrl = RxnString();

  final profileName = ''.obs;
  final profileEmail = ''.obs;

  final isLoading = false.obs;
  final isSaving = false.obs;

  final ImagePicker _imagePicker = ImagePicker();

  String username = '';
  String originalFullName = '';
  String originalEmail = '';
  String originalPhone = '';
  String? originalProfilePictureUrl;

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  Future<String?> _getUsername(SharedPreferences prefs) async {
    final arguments = Get.arguments;

    if (arguments is Map && arguments['username'] != null) {
      final value = arguments['username'].toString().trim();
      if (value.isNotEmpty) return value;
    }

    final savedUsername = prefs.getString('username');
    if (savedUsername != null && savedUsername.trim().isNotEmpty) {
      return savedUsername.trim();
    }

    // Fallback if the JWT stores the username in the "sub" claim.
    final token = prefs.getString('token');
    if (token == null || token.isEmpty) return null;

    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;

      final payload = base64Url.normalize(parts[1]);
      final decoded = jsonDecode(
        utf8.decode(base64Url.decode(payload)),
      );

      if (decoded is! Map<String, dynamic>) return null;

      final subject = decoded['sub'];
      if (subject == null || subject.toString().trim().isEmpty) {
        return null;
      }

      return subject.toString().trim();
    } catch (e) {
      debugPrint('Could not read username from JWT: $e');
      return null;
    }
  }

  Map<String, String> _headers(String token) => {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

  void _showMessage(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 4),
    );
  }

  String _serverMessage(http.Response response) {
    try {
      final body = jsonDecode(response.body);
      if (body is Map) {
        return body['message']?.toString() ??
            body['error']?.toString() ??
            response.body;
      }
    } catch (_) {
      // The response may not be JSON.
    }

    return response.body.isNotEmpty
        ? response.body
        : 'HTTP ${response.statusCode}';
  }

  String? _readString(Map<String, dynamic> data, List<String> keys) {
    for (final key in keys) {
      final value = data[key];
      if (value != null && value.toString().trim().isNotEmpty) {
        return value.toString();
      }
    }
    return null;
  }

  Future<void> loadProfile() async {
    if (isLoading.value) return;

    isLoading.value = true;

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final currentUsername = await _getUsername(prefs);

      if (token == null || token.trim().isEmpty) {
        _showMessage(
          'Login required',
          'Your login token was not found. Please log in again.',
        );
        return;
      }

      if (currentUsername == null || currentUsername.isEmpty) {
        _showMessage(
          'Login required',
          'Username was not found. Please log in again.',
        );
        return;
      }

      username = currentUsername;

      final uri = Uri.parse(
        '$baseUrl/auth/get-profile/${Uri.encodeComponent(username)}',
      );

      final response = await http
          .get(uri, headers: _headers(token))
          .timeout(const Duration(seconds: 20));

      debugPrint('GET profile URL: $uri');
      debugPrint('GET profile status: ${response.statusCode}');
      debugPrint('GET profile response: ${response.body}');

      if (response.statusCode == 401 || response.statusCode == 403) {
        _showMessage(
          'Authentication failed',
          'The server rejected the request. Please sign in again, '
              'and check your Spring Security rules if this continues.',
        );
        return;
      }

      if (response.statusCode != 200) {
        throw Exception(_serverMessage(response));
      }

      final dynamic decoded = jsonDecode(response.body);
      if (decoded is! Map) {
        throw const FormatException(
          'The server returned an unexpected profile format.',
        );
      }

      final data = Map<String, dynamic>.from(decoded);

      // Read profile values, including phoneNumber, from the API response.
      fullNameController.text =
          _readString(data, ['fullName', 'name']) ?? '';
      emailController.text = _readString(data, ['email']) ?? '';
      phoneController.text =
          _readString(data, ['phoneNumber', 'phone']) ?? '';

      profileName.value = fullNameController.text;
      profileEmail.value = emailController.text;

      final picture = _readString(
        data,
        ['profilePictureUrl', 'profileImageUrl', 'profilePicture'],
      );
      profilePictureUrl.value = _resolveImageUrl(picture);

      originalFullName = fullNameController.text;
      originalEmail = emailController.text;
      originalPhone = phoneController.text;
      originalProfilePictureUrl = profilePictureUrl.value;
    } on SocketException catch (e) {
      debugPrint('loadProfile network error: $e');
      _showMessage(
        'Connection error',
        'Cannot reach the server. Check the API host, port, and network.',
      );
    } catch (e) {
      debugPrint('loadProfile error: $e');
      _showMessage(
        'Unable to load profile',
        'Check the API URL, server status, and response format.',
      );
    } finally {
      isLoading.value = false;
    }
  }

  String? _resolveImageUrl(String? value) {
    if (value == null || value.trim().isEmpty) return null;

    final path = value.trim();
    final uri = Uri.tryParse(path);

    if (uri != null && uri.hasScheme) return path;

    final serverOrigin = Uri.parse(baseUrl).origin;
    return path.startsWith('/')
        ? '$serverOrigin$path'
        : '$serverOrigin/$path';
  }

  Future<void> pickProfileImage() async {
    try {
      final image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1200,
      );

      if (image != null) {
        selectedImage.value = File(image.path);
      }
    } catch (e) {
      debugPrint('pickProfileImage error: $e');
      _showMessage('Image error', 'Could not select the image.');
    }
  }

  String? validateName(String? value) {
    if (value == null || value.trim().length < 2) {
      return 'Enter a name with at least 2 characters.';
    }
    return null;
  }

  String? validateEmail(String? value) {
    final email = value?.trim() ?? '';

    if (!RegExp(
      r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$',
    ).hasMatch(email)) {
      return 'Enter a valid email address.';
    }
    return null;
  }

  String? validatePhone(String? value) {
    // Phone number is optional. If provided, validate 8–15 digits.
    if (value == null || value.trim().isEmpty) return null;

    final digits = value.replaceAll(RegExp(r'[\s()+-]'), '');
    if (!RegExp(r'^\d{8,15}$').hasMatch(digits)) {
      return 'Enter 8–15 digits for the phone number.';
    }
    return null;
  }

  Future<void> saveChanges() async {
    if (isSaving.value) return;
    if (!(formKey.currentState?.validate() ?? false)) return;

    if (username.isEmpty) {
      _showMessage(
        'Profile not ready',
        'Wait for the profile to load, then try again.',
      );
      return;
    }

    isSaving.value = true;

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null || token.trim().isEmpty) {
        _showMessage(
          'Login required',
          'Your login token is missing. Please log in again.',
        );
        return;
      }

      final uri = Uri.parse(
        '$baseUrl/auth/${Uri.encodeComponent(username)}',
      );

      final request = http.MultipartRequest('PUT', uri);
      request.headers.addAll(_headers(token));

      final updateData = <String, dynamic>{
        'username': username,
        'fullName': fullNameController.text.trim(),
        'email': emailController.text.trim(),
        'phoneNumber': phoneController.text.trim(),
      };

      // 1. Send JSON data as a form field (matches @RequestParam("requestJson"))
      request.fields['requestJson'] = jsonEncode(updateData);

      // 2. Send image file as a multipart file (matches @RequestParam("file"))
      final image = selectedImage.value;
      if (image != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'file',
            image.path,
            contentType: MediaType('application', 'octet-stream'),
          ),
        );
      }

      debugPrint('PUT profile URL: $uri');
      debugPrint('PUT profile JSON: ${jsonEncode(updateData)}');

      final streamedResponse = await request
          .send()
          .timeout(const Duration(seconds: 30));

      final response = await http.Response.fromStream(streamedResponse);

      debugPrint('Update profile status: ${response.statusCode}');
      debugPrint('Update profile response: ${response.body}');

      if (response.statusCode == 401 || response.statusCode == 403) {
        _showMessage(
          'Update rejected (${response.statusCode})',
          'Check that the token is valid and the authenticated user '
              'has permission to update this profile.',
        );
        return;
      }

      if (response.statusCode < 200 || response.statusCode >= 300) {
        _showMessage(
          'Update failed (${response.statusCode})',
          _serverMessage(response),
        );
        return;
      }

      profileName.value = fullNameController.text.trim();
      profileEmail.value = emailController.text.trim();

      originalFullName = fullNameController.text.trim();
      originalEmail = emailController.text.trim();
      originalPhone = phoneController.text.trim();

      selectedImage.value = null;

      // Refresh from the server so the displayed data matches the database.
      await loadProfile();

      _showMessage('Success', 'Your profile has been updated.');
    } on SocketException catch (e) {
      debugPrint('saveChanges network error: $e');
      _showMessage(
        'Connection error',
        'Cannot reach the server. Check the API host, port, and network.',
      );
    } catch (e) {
      debugPrint('saveChanges error: $e');
      _showMessage(
        'Update error',
        'Could not save your profile. Check the console for details.',
      );
    } finally {
      isSaving.value = false;
    }
  }
  void cancelChanges() {
    fullNameController.text = originalFullName;
    emailController.text = originalEmail;
    phoneController.text = originalPhone;

    profileName.value = originalFullName;
    profileEmail.value = originalEmail;
    profilePictureUrl.value = originalProfilePictureUrl;
    selectedImage.value = null;

    Get.back();
  }

  void onNotificationPressed() {
    _showMessage(
      'Notifications',
      'Notification settings are not connected yet.',
    );
  }

  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}
