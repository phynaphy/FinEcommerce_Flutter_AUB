import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomescreenView extends StatefulWidget {
  const HomescreenView({super.key});

  @override
  State<HomescreenView> createState() => _HomescreenViewState();
}

class _HomescreenViewState extends State<HomescreenView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( title: Text("Welcome into FIN-ECMOOERCE screen",style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.bold, fontSize: 18,),),),
      
    );
  }
}