import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SocialSignInButton extends StatelessWidget {
  final IconData? icon;
  final String text;
  final VoidCallback onPressed;
  final Color? color;
  final String? imageString;
  final Color? iconColor;

  const SocialSignInButton({
    super.key,
    this.icon,
    required this.text,
    required this.onPressed,
    this.color,
    this.imageString,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56, // h-14
      width: double.infinity, // w-full
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFF8FAFC),
          foregroundColor: color, // For icon color
          elevation: 2, // shadow-md
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Color.fromARGB(163, 162, 173, 182)),
            borderRadius: BorderRadius.circular(16.0), // rounded-2xl
          ),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            (imageString != null)
                ? Image.asset(imageString!, width: 24, height: 24)
                : FaIcon(icon, size: 24, color: iconColor),
            const SizedBox(width: 16), // mr-4
            Text(text, style: Theme.of(context).textTheme.labelLarge),
          ],
        ),
      ),
    );
  }
}
