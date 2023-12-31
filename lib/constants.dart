import 'dart:math';

import 'package:flutter/material.dart';

class ColorConstants {
  //Colors
  static Color globalColor = hexToColor('#2F8CFF');
  static Color secondTextColor = hexToColor('#5D6B98');
  static Color onProgressStatusColor = hexToColor('#039855');
  static Color onProgressTextStatusColor = hexToColor('#039855');
  static Color iconsColor = hexToColor('#6A6F7D');
  static Color greyIconsColor = hexToColor('#807e85');
  static Color darkBlueColor = hexToColor('#272F3F');
  static Color orange = hexToColor('#ffb36b');
  static Color gray50 = hexToColor('#e9e9e9');
  static Color gray100 = hexToColor('#bdbebe');
  static Color gray200 = hexToColor('#929293');
  static Color gray300 = hexToColor('#666667');
  static Color gray400 = hexToColor('#505151');
  static Color gray500 = hexToColor('#242526');
  static Color gray600 = hexToColor('#202122');
  static Color gray700 = hexToColor('#191a1b');
  static Color gray800 = hexToColor('#121313');
  static Color gray900 = hexToColor('#0e0f0f');
  static Color red = hexToColor('#FE3D2F');
}

Color hexToColor(String hex) {
  assert(RegExp(r'^#([0-9a-fA-F]{6})|([0-9a-fA-F]{8})$').hasMatch(hex));
  return Color(int.parse(hex.substring(1), radix: 16) +
      (hex.length == 7 ? 0xFF000000 : 0x00000000));
}


Color generateRandomColor() {
  final random = Random();
  final baseColor = Color.fromARGB(
      255, random.nextInt(200), random.nextInt(200), random.nextInt(200));
  final hsl = HSVColor.fromColor(baseColor);
  final pastelColor = HSLColor.fromAHSL(1.0, hsl.hue,
      0.3 + random.nextDouble() * 0.2, 0.8 + random.nextDouble() * 0.2);
  return pastelColor.toColor();
}

LinearGradient generateRandomGradient() {
  final color1 = generateRandomColor();
  final color2 = generateRandomColor();
  return LinearGradient(
    colors: [color1, color2],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}