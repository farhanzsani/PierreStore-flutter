import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const kBgGreen    = Color(0xFF4A7340);
const kWoodDark   = Color(0xFF3D2B1F);
const kWoodMid    = Color(0xFF6B4A2A);
const kParchment  = Color(0xFFF5E0A8);
const kCream      = Color(0xFFFFF8E7);
const kGold       = Color(0xFFE8C44A);
const kGreenBtn   = Color(0xFF5A8A3A);
const kMaroon     = Color(0xFF8B2020);
const kStoneGray  = Color(0xFF9BA89B);

TextStyle sdTitle({double size = 28, Color color = kGold}) =>
    GoogleFonts.vt323(fontSize: size, color: color, letterSpacing: 1.5);

TextStyle sdBody({double size = 20, Color color = kWoodDark}) =>
    GoogleFonts.vt323(fontSize: size, color: color, letterSpacing: 0.5);

TextStyle sdHint({double size = 18}) =>
    GoogleFonts.vt323(fontSize: size, color: kWoodMid.withOpacity(0.5));

BoxDecoration sdBox({Color bg = kParchment, int borderWidth = 4}) =>
    BoxDecoration(
      color: bg,
      border: Border.all(color: kWoodDark, width: borderWidth.toDouble()),
      boxShadow: const [
        BoxShadow(color: kWoodDark, offset: Offset(4, 4), blurRadius: 0),
      ],
    );

InputDecoration sdInput({required String hint, String? errorMsg}) =>
    InputDecoration(
      hintText: hint,
      hintStyle: sdHint(),
      filled: true,
      fillColor: kCream,
      contentPadding:
          const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
      errorStyle: GoogleFonts.vt323(fontSize: 16, color: kMaroon),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: kWoodDark, width: 2),
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: kWoodDark, width: 2),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: kGold, width: 3),
      ),
      errorBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: kMaroon, width: 2),
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: kMaroon, width: 3),
      ),
    );

class SdButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool isLoading;
  final Color color;
  final double fontSize;

  const SdButton({
    super.key,
    required this.label,
    this.onTap,
    this.isLoading = false,
    this.color = kGreenBtn,
    this.fontSize = 24,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isLoading ? kStoneGray : color,
          border: Border.all(color: kWoodDark, width: 3),
          boxShadow: const [
            BoxShadow(color: kWoodDark, offset: Offset(3, 3), blurRadius: 0),
          ],
        ),
        alignment: Alignment.center,
        child: isLoading
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2),
                  ),
                  const SizedBox(width: 10),
                  Text('Please wait...',
                      style: sdBody(size: 20, color: Colors.white)),
                ],
              )
            : Text(label,
                style: sdTitle(size: fontSize, color: Colors.white)),
      ),
    );
  }
}
