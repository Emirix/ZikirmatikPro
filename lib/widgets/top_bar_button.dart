import 'package:flutter/material.dart';

class TopBarButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const TopBarButton({super.key, required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        // hover effect simulation in flutter typically done with InkWell,
        // but sticking to visual similarity
      ),
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: onPressed,
          customBorder: const CircleBorder(),
          hoverColor: Colors.white.withOpacity(0.1),
          child: Icon(icon, color: Colors.grey[300], size: 24),
        ),
      ),
    );
  }
}
