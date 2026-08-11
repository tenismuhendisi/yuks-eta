import 'package:crm_app/core/enums/ball_level.dart';
import 'package:flutter/material.dart';

/// ITF top seviyesi avatarı — gerçek fotoğraflar (arka plansız).
class ItfTennisBallAvatar extends StatelessWidget {
  const ItfTennisBallAvatar({
    super.key,
    required this.level,
    this.size = 44,
  });

  final BallLevel? level;
  final double size;

  static String assetFor(BallLevel level) => switch (level) {
        BallLevel.red => 'assets/balls/ball_red.png',
        BallLevel.orange => 'assets/balls/ball_orange.png',
        BallLevel.green => 'assets/balls/ball_green.png',
        BallLevel.yellow => 'assets/balls/ball_yellow.png',
      };

  @override
  Widget build(BuildContext context) {
    final ball = level ?? BallLevel.yellow;
    return SizedBox(
      width: size,
      height: size,
      child: Image.asset(
        assetFor(ball),
        fit: BoxFit.contain,
        filterQuality: FilterQuality.high,
        errorBuilder: (_, __, ___) => Icon(
          Icons.sports_tennis,
          size: size * 0.7,
          color: Colors.grey.shade600,
        ),
      ),
    );
  }
}
