import 'package:flutter/material.dart';

class IconCircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  const IconCircleButton({super.key, required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(99),
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Theme.of(context).colorScheme.outlineVariant,
            width: 0.5,
          ),
        ),
        child: Icon(icon, size: 18),
      ),
    );
  }
}
