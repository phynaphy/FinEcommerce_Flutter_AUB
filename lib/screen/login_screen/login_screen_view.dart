import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/color/Premium_fintech_color.dart';
import 'package:flutter_application_ecommerce/screen/Textfield/custom_textfield.dart';
import 'package:flutter_application_ecommerce/screen/login_screen/login_screen_controller.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreenView extends StatefulWidget {
  LoginScreenView({super.key});

  @override
  State<LoginScreenView> createState() => _LoginScreenViewState();
}

class _LoginScreenViewState extends State<LoginScreenView> {
  final LoginScreenController controller = LoginScreenController();
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8FAFC),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 25,
                    height: 25,
                    // 1. ADD THIS LINE TO CLIP THE IMAGE TO THE BORDER RADIUS
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: PremiumFintechColor.primaryColor,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Image.network(
                      "https://i.pinimg.com/736x/e8/fb/a2/e8fba2f647fa4c0a40d462ef85e91af9.jpg",
                      fit: BoxFit.fill,
                    ),
                  ),
                  SizedBox(width: 20),
                  Text(
                    "FinEcommerce",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: PremiumFintechColor.primaryColor,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40),
              // designmian_login_card_container
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(2),
                  // Crisp border matching Tailwind / Material 3 card outline
                  border: Border.all(color: Color(0xFFE2E8F0), width: 1.2),
                  boxShadow: [
                    // 1. Direct crisp drop shadow (bottom edge outline shadow)
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 2,
                      spreadRadius: 0,
                      offset: Offset(0, 2),
                    ),
                    // 2. Wide ambient glow shadow (creates the floating card effect)
                    BoxShadow(
                      color: Color(0xFF0F172A).withOpacity(0.12),
                      blurRadius: 30,
                      spreadRadius: -4,
                      offset: Offset(0, 12),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome Back",
                        // style: TextStyle(
                        //   fontSize: 25,
                        //   fontWeight: FontWeight.bold,
                        //   color: Colors.black,
                        // ),
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Please enter your credentials to access your secure dashboard",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      SizedBox(height: 15),
                      CustomTextField(
                        controller: controller.emailController,
                        hintText: "Email Adress",
                        keyboardType: TextInputType.emailAddress,
                        suffixIcon: Icon(
                          Icons.email_outlined,
                          color: PremiumFintechColor.primaryColor,
                        ),
                      ),
                      SizedBox(height: 20),
                      CustomTextField(
                        controller: controller
                            .passwordController, // Fixed controller binding
                        hintText: "Password",
                        isObscure: controller.isObsecure,
                        keyboardType: TextInputType.visiblePassword,
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              controller.isObsecure = !controller.isObsecure;
                            });
                          },

                          child: Icon(
                            controller.isObsecure
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: PremiumFintechColor.primaryColor,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,

                        child: TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            minimumSize: Size(0, 36),
                          ),
                          child: Text(
                            "Forget Password?",
                            style: TextStyle(
                              color: PremiumFintechColor.primaryColor,
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      //loginbutton
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: PremiumFintechColor.primaryColor,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadiusGeometry.circular(9),
                            ),
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Login to Account",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 20),
                                Icon(Icons.arrow_forward),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 25),
                      // Row(
                      //   children:
                      // [
                      //     Expanded(child: Divider(color: Color(0xFFE2E8F0))),
                      //     Padding(
                      //       padding: EdgeInsets.symmetric(horizontal: 12),
                      //       child: Text(
                      //         "OR CONTINUE WITH",
                      //         style: TextStyle(
                      //           fontSize: 10,
                      //           fontWeight: FontWeight.bold,
                      //           color: Color(0xFF94A3B8),
                      //           letterSpacing: 0.5,
                      //         ),
                      //       ),
                      //     ),
                      //     Expanded(child: Divider(color: Color(0xFFE2E8F0))),
                      //   ],
                      // ),
                      // SizedBox(height: 25),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.start,
                      //   crossAxisAlignment: CrossAxisAlignment.start,
                      //   children: [
                      //     ElevatedButton(
                      //       onPressed: () {},style: ElevatedButton.styleFrom(

                      //       ),
                      //       child: Row(
                      //         mainAxisAlignment: MainAxisAlignment.start,
                      //         crossAxisAlignment: CrossAxisAlignment.start,
                      //         children: [
                      //           Text(
                      //             "GOOGLE",
                      //             style: GoogleFonts.spaceGrotesk(
                      //               fontSize: 25,
                      //               color: Colors.black,
                      //               fontWeight: FontWeight.normal,
                      //             ),
                      //           ),
                      //           ImageIcon(
                      //             AssetImage("assets/icons/google.png"),
                      //             size: 20,
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      Row(
                        children: [
                          Expanded(
                            child: _buildSocailButton(
                              label: "Google",
                              // Using Network Image (Google Logo URL)
                              icon: Image.network(
                                "https://images.icon-icons.com/2642/PNG/512/google_logo_g_logo_icon_159348.png",
                                height: 25,
                                width: 25,
                                errorBuilder: (context, error, stackTrace) =>
                                    Icon(Icons.g_mobiledata, size: 20),
                              ),
                              onTab: () {},
                            ),
                          ),

                          SizedBox(width: 12),
                          Expanded(
                            child: _buildSocailButton(
                              label: "Apple",

                              // icon:
                              // Icon(
                              //   Icons.apple,
                              //   size: 20,
                              //   color: Color.fromARGB(255, 9, 15, 28),
                              // ),
                              icon: Image.network(
                                "https://1000logos.net/wp-content/uploads/2016/10/Apple-Logo.png",
                                height: 25,
                                width: 25,
                                errorBuilder: (context, error, stackTrace) =>
                                    Icon(Icons.g_mobiledata, size: 20),
                              ),

                              onTab: () {},
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account? ",
                            style: TextStyle(fontSize: 15, color: Colors.black),
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: Text(
                              "Register now",
                              style: TextStyle(
                                fontSize: 15,
                                color: PremiumFintechColor.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 25),
                      const SizedBox(height: 24),

                      // --- SECURITY BADGE (Centered Row) ---
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.lock_outline,
                            size: 13,
                            color: Color(
                              0xFF64748B,
                            ), // Soft muted gray instead of harsh black
                          ),
                          SizedBox(width: 5),
                          Text(
                            "AES-256 Multi-Layered Encryption Enabled",
                            style: TextStyle(
                              fontSize: 11,
                              color: PremiumFintechColor.primaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 4),

                      // --- COPYRIGHT NOTICE (Centered Below) ---
                      const Center(
                        child: Text(
                          "© 2024 FinEcommerce. All rights reserved.",
                          style: TextStyle(
                            fontSize: 11,
                            color: PremiumFintechColor.primaryColor, // Slightly lighter gray for lowest hierarchy
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildSocailButton({
  required String label,
  required Widget icon,
  required VoidCallback onTab,
}) {
  return OutlinedButton(
    onPressed: onTab,
    style: OutlinedButton.styleFrom(
      padding: EdgeInsets.symmetric(vertical: 12),
      side: BorderSide(color: PremiumFintechColor.primaryColor),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        icon,
        SizedBox(width: 8),
        Text(label, style: TextStyle(fontSize: 13, color: Colors.black)),
      ],
    ),
  );
}
