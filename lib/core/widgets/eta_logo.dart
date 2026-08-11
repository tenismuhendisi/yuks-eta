import 'package:flutter/material.dart';

/// ETA logosu. Koyu zeminlerde (`onDark: true`) açık kapsül ile okunur kalır.
class EtaLogo extends StatelessWidget {
  const EtaLogo({
    super.key,
    this.height = 36,
    this.onDark = false,
  });

  final double height;
  final bool onDark;

  @override
  Widget build(BuildContext context) {
    final image = Image.asset(
      'assets/eta_logo.png',
      height: height,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
    );

    if (!onDark) return image;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(height * 0.28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.22),
            blurRadius: 6,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: height * 0.28,
          vertical: height * 0.14,
        ),
        child: image,
      ),
    );
  }
}
