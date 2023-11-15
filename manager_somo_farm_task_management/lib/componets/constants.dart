import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const kBackgroundColor = Colors.white;
const kPrimaryColor = Color(0xFF83AB48);
const kSecondColor = Color(0xFF455A64);
const kSecondLightColor = Color(0xFF8CAAB9);
const kTextBlackColor = Colors.black;
const kTextGreyColor = Color.fromARGB(255, 135, 135, 135);
const kTextWhiteColor = Colors.white;
const kTextBlueColor = Color(0xFF0582CA);
const String baseUrl = "https://farmtasksomo.azurewebsites.net/api";
TextStyle get subHeadingStyle {
  return GoogleFonts.lato(
    textStyle: const TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Colors.grey,
    ),
  );
}

TextStyle get headingStyle {
  return TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.w600,
    color: kSecondColor,
  );
}

TextStyle get titileStyle {
  return GoogleFonts.lato(
    textStyle: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
    ),
  );
}

TextStyle get subTitileStyle {
  return GoogleFonts.lato(
    textStyle: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: Colors.black,
    ),
  );
}
