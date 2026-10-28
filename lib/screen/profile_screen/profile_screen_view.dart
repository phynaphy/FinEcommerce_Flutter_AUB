import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/screen/change&forget_password/email_input_view.dart';
import 'package:flutter_application_ecommerce/screen/login_screen/login_screen_view.dart';
import 'package:flutter_application_ecommerce/screen/profile_information/profile_information_view.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProfileApiConfig {
  // For Flutter Windows/Desktop or Web when Spring Boot runs on this computer:
  static const String baseUrl = 'http://192.168.56.1:8080';

  // For Android Emulator, change the line above to:
  // static const String baseUrl = 'http://10.0.2.2:8080';

  // For a physical phone, use your computer's LAN IP address instead.
  static const String profileUrl =
      '$baseUrl/api/v1/mobile/auth/get-profile';

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString('token') ??
        prefs.getString('authToken') ??
        prefs.getString('accessToken');

    if (token == null || token.trim().isEmpty) {
      return null;
    }

    return token.replaceFirst(RegExp(r'^Bearer\s+', caseSensitive: false), '');
  }

  static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();

    // Prefer the username passed through GetX navigation.
    final arguments = Get.arguments;

    if (arguments is Map && arguments['username'] != null) {
      final username = arguments['username'].toString().trim();

      if (username.isNotEmpty) {
        await prefs.setString('username', username);
        return username;
      }
    }

    // Use the username saved during login.
    final savedUsername = prefs.getString('username');

    if (savedUsername != null && savedUsername.trim().isNotEmpty) {
      return savedUsername.trim();
    }

    // Fallback: try reading the username from the JWT.
    final token = await getToken();

    if (token == null) {
      return null;
    }

    try {
      final parts = token.split('.');

      if (parts.length != 3) {
        return null;
      }

      final normalizedPayload = base64Url.normalize(parts[1]);
      final decodedPayload = jsonDecode(
        utf8.decode(base64Url.decode(normalizedPayload)),
      );

      if (decodedPayload is! Map) {
        return null;
      }

      final username = decodedPayload['username'] ??
          decodedPayload['preferred_username'] ??
          decodedPayload['sub'];

      if (username != null && username.toString().trim().isNotEmpty) {
        final value = username.toString().trim();
        await prefs.setString('username', value);
        return value;
      }
    } catch (e) {
      debugPrint('Could not read username from token: $e');
    }

    return null;
  }

  static Map<String, String> getHeaders(String? token) {
    return {
      'Accept': 'application/json',
      if (token != null && token.isNotEmpty)
        'Authorization': 'Bearer $token',
    };
  }

  static String? getImageUrl(dynamic imagePath) {
    if (imagePath == null) {
      return null;
    }

    final path = imagePath.toString().trim();

    if (path.isEmpty) {
      return null;
    }

    if (path.startsWith('http://') || path.startsWith('https://')) {
      return path;
    }

    return '$baseUrl${path.startsWith('/') ? '' : '/'}$path';
  }
}

class ProfileScreenView extends StatefulWidget {
  // Kept optional for compatibility with existing navigation calls.
  // Email is not displayed on this screen.
  final String email;

  const ProfileScreenView({
    super.key,
    this.email = '',
  });

  @override
  State<ProfileScreenView> createState() => _ProfileScreenViewState();
}

class _ProfileScreenViewState extends State<ProfileScreenView> {
  bool _biometricEnabled = true;

  bool _isLoading = false;
  String? _errorMessage;

  String _fullName = '';
  String? _profilePictureUrl;

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final token = await ProfileApiConfig.getToken();
      final username = await ProfileApiConfig.getUsername();

      if (token == null) {
        throw Exception('Your login session has expired. Please log in again.');
      }

      if (username == null || username.trim().isEmpty) {
        throw Exception(
          'Username was not found. Please log in again.',
        );
      }

      final uri = Uri.parse(
        '${ProfileApiConfig.profileUrl}/'
        '${Uri.encodeComponent(username)}',
      );

      debugPrint('GET profile URL: $uri');

      final response = await http
          .get(
            uri,
            headers: ProfileApiConfig.getHeaders(token),
          )
          .timeout(const Duration(seconds: 20));

      debugPrint('Profile API status: ${response.statusCode}');
      debugPrint('Profile API response: ${response.body}');

      if (response.statusCode == 401 || response.statusCode == 403) {
        throw Exception(
          'Authentication failed. Please log in again.',
        );
      }

      if (response.statusCode == 404) {
        throw Exception(
          'Profile not found. Please check the username.',
        );
      }

      if (response.statusCode != 200) {
        throw Exception(
          'Unable to load profile. Server status: '
          '${response.statusCode}.',
        );
      }

      final dynamic decoded = jsonDecode(response.body);

      if (decoded is! Map) {
        throw const FormatException(
          'The server returned an invalid profile response.',
        );
      }

      final data = Map<String, dynamic>.from(decoded);

      if (!mounted) return;

      setState(() {
        // Only display the full name and profile picture.
        // Other API fields are not shown in the UI.
        _fullName = data['fullName']?.toString() ?? '';

        _profilePictureUrl = ProfileApiConfig.getImageUrl(
          data['profilePictureUrl'],
        );
      });
    } catch (e) {
      debugPrint('Fetch profile error: $e');

      if (!mounted) return;

      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _openPersonalInformation() async {
    await Get.to(() => const ProfileInformationView());

    if (mounted) {
      await fetchProfile();
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove('token');
    await prefs.remove('authToken');
    await prefs.remove('accessToken');
    await prefs.remove('username');

    if (!mounted) return;

    Get.offAll(() => LoginScreenView());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Row(
          children: [
            Icon(
              Icons.account_balance,
              color: Color(0xFF0F172A),
              size: 22,
            ),
            SizedBox(width: 10),
            Text(
              'FinanceCore',
              style: TextStyle(
                color: Color(0xFF0F172A),
                fontWeight: FontWeight.bold,
                fontSize: 20,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(
                Icons.notifications_none_rounded,
                color: Color(0xFF0F172A),
                size: 22,
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: fetchProfile,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 12,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_isLoading && _fullName.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (_errorMessage != null && _fullName.isEmpty)
                _buildErrorCard()
              else
                _buildProfileHeader(),

              const SizedBox(height: 28),

              _buildSectionTitle('Account'),
              _buildCardGroup([
                _buildMenuTile(
                  icon: Icons.person_outline_rounded,
                  title: 'Personal Information',
                  subtitle: 'Update your details and personal data',
                  onTap: _openPersonalInformation,
                ),
                _buildCustomDivider(),
                _buildMenuTile(
                  icon: Icons.location_on_outlined,
                  title: 'Shipping Addresses',
                  subtitle: 'Manage your saved delivery locations',
                  onTap: () {},
                ),
              ]),

              const SizedBox(height: 22),

              _buildSectionTitle('Payments'),
              _buildCardGroup([
                _buildMenuTile(
                  icon: Icons.credit_card_rounded,
                  title: 'Saved Cards',
                  subtitle: 'Manage your saved payment cards',
                  onTap: () {},
                ),
                _buildCustomDivider(),
                _buildMenuTile(
                  icon: Icons.account_balance_outlined,
                  title: 'Bank Accounts',
                  subtitle: 'Connect accounts for direct transfers',
                  onTap: () {},
                ),
              ]),

              const SizedBox(height: 22),

              _buildSectionTitle('Security'),
              _buildCardGroup([
                _buildMenuTile(
                  icon: Icons.lock_outline_rounded,
                  title: 'Change Password',
                  subtitle: 'Update your account password',
                  onTap: () {
                    Get.to(() => EmailInputView());
                  },
                ),
                _buildCustomDivider(),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  leading: _buildIconBox(
                    Icons.fingerprint_rounded,
                  ),
                  title: const Text(
                    'Biometric Login',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  subtitle: const Text(
                    'Face ID or Touch ID',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF64748B),
                    ),
                  ),
                  trailing: Switch.adaptive(
                    value: _biometricEnabled,
                    activeColor: const Color(0xFF22C55E),
                    onChanged: (value) {
                      setState(() {
                        _biometricEnabled = value;
                      });
                    },
                  ),
                ),
              ]),

              const SizedBox(height: 22),

              _buildSectionTitle('Preferences'),
              _buildCardGroup([
                _buildMenuTile(
                  icon: Icons.language_rounded,
                  title: 'Language',
                  subtitle: 'English (United States)',
                  onTap: () {},
                ),
                _buildCustomDivider(),
                _buildMenuTile(
                  icon: Icons.notifications_none_rounded,
                  title: 'Notifications',
                  subtitle: 'Manage notification preferences',
                  onTap: () {},
                ),
              ]),

              const SizedBox(height: 30),

              _buildLogOutButton(),

              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.cloud_off_outlined,
            size: 42,
            color: Color(0xFF64748B),
          ),
          const SizedBox(height: 12),
          const Text(
            'Could not load your profile',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _errorMessage ?? 'Please try again.',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: fetchProfile,
            icon: const Icon(Icons.refresh),
            label: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  // Profile header displays only the user's photo and full name.
  Widget _buildProfileHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: 28,
        horizontal: 20,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF0284C7),
            Color(0xFF0369A1),
            Color(0xFF0F172A),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0369A1).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF38BDF8),
                      Colors.white.withOpacity(0.2),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF38BDF8).withOpacity(0.4),
                      blurRadius: 16,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
              Container(
                width: 88,
                height: 88,
                decoration: const BoxDecoration(
                  color: Color(0xFFE0F2FE),
                  shape: BoxShape.circle,
                ),
                child: ClipOval(
                  child: _profilePictureUrl != null
                      ? Image.network(
                          _profilePictureUrl!,
                          width: 88,
                          height: 88,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) {
                            return const Icon(
                              Icons.person,
                              size: 48,
                              color: Color(0xFF0369A1),
                            );
                          },
                        )
                      : const Icon(
                          Icons.person,
                          size: 48,
                          color: Color(0xFF0369A1),
                        ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            _fullName.isNotEmpty ? _fullName : 'Your Profile',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 16),
          if (_isLoading)
            const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 10,
        left: 4,
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Color(0xFF0F172A),
          letterSpacing: -0.3,
        ),
      ),
    );
  }

  Widget _buildCardGroup(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildMenuTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 4,
      ),
      leading: _buildIconBox(icon),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
          color: Color(0xFF0F172A),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 12,
          color: Color(0xFF64748B),
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right_rounded,
        size: 22,
        color: Color(0xFF94A3B8),
      ),
    );
  }

  Widget _buildIconBox(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFE0F2FE),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        icon,
        color: const Color(0xFF0369A1),
        size: 20,
      ),
    );
  }

  Widget _buildCustomDivider() {
    return const Divider(
      height: 1,
      thickness: 1,
      indent: 64,
      endIndent: 16,
      color: Color(0xFFF1F5F9),
    );
  }

  Widget _buildLogOutButton() {
    return Container(
      width: double.infinity,
      height: 52,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFEF4444),
            Color(0xFFB91C1C),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFEF4444).withOpacity(0.35),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: _logout,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.logout_rounded,
                color: Colors.white,
                size: 18,
              ),
              SizedBox(width: 8),
              Text(
                'Log Out',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
