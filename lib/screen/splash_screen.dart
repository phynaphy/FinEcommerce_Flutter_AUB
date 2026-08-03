import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/app/routes/approutes.dart';
import 'package:flutter_application_ecommerce/color/Premium_fintech_color.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
  
}

class _SplashScreenState extends State<SplashScreen> {
    void initState() {
    super.initState();

    Timer(
       Duration(seconds: 5),
      () {
        Get.offNamed(AppRoutes.splash2);
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: PremiumFintechColor.primaryColor,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(150),


                  
                

                ),
                child: Image.network("https://cdn-icons-png.flaticon.com/512/10149/10149443.png"),
                



                
              ),
              SizedBox( height: 20,),
              Text("FINECOMMERCE",style: GoogleFonts.spaceGrotesk(fontSize: 24,fontWeight: FontWeight.bold),),
              Text("INSTITUTIONAL TRUST,MODERN FLUIDITY",style: GoogleFonts.inter(fontSize: 18,color: PremiumFintechColor.neutral),)
              
            ],
            
            
          ),
        ),
       
        
        
      ),
    );
  }
}