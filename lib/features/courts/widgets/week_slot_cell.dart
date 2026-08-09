import 'package:crm_app/core/services/court_availability_service.dart';
import 'package:crm_app/core/widgets/schedule_lesson_slot.dart';
import 'package:flutter/material.dart';

/// Haftalık grid için hafif hücre.
class WeekSlotCell extends StatelessWidget {
  const WeekSlotCell({
    super.key,
    required this.slot,
    this.onTap,
  });

  final CourtSlot slot;
  final VoidCallback? onTap;

  /// 2+ kişilik özelde: ah-os-al; tek kişide tam ad.
  static String compactPrivateLabel(CourtSlot slot) {
    final raw = slot.participantNames ?? slot.primaryLabel;
    if (raw == null || raw.isEmpty) return '';
    final parts = raw
        .split(RegExp(r'[-·]'))
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    if (parts.isEmpty) return raw;
    if (parts.length == 1) {
      final p = parts.first;
      return p.length <= 6 ? p : p.substring(0, 6);
    }
    return parts.map((p) {
      final lower = p.toLowerCase();
      return lower.length <= 2 ? lower : lower.substring(0, 2);
    }).join('-');
  }

  @override
  Widget build(BuildContext context) {
    final canTap = onTap != null &&
        (slot.status == SlotStatus.available || slot.status == SlotStatus.blocked);

    if (slot.status == SlotStatus.lesson) {
      final primary = slot.isPrivateLesson
          ? compactPrivateLabel(slot)
          : (slot.primaryLabel ?? '');
      return ScheduleLessonSlot(
        coachId: slot.coachId,
        isGroup: slot.isGroupLesson,
        isTentative: false,
        primary: primary,
        groupCount: slot.isGroupLesson ? slot.participantCount : null,
        compact: true,
        onTap: canTap ? onTap : null,
        enabled: canTap,
      );
    }

    final Color bg;
    final Color border;
    switch (slot.status) {
      case SlotStatus.available:
        bg = const Color(0xFFF7F8F7);
        border = const Color(0xFFE6E8E6);
      case SlotStatus.rental:
        bg = const Color(0xFFFFF6EB);
        border = const Color(0xFFFFE0B8);
      case SlotStatus.blocked:
        bg = const Color(0xFFF8F1F1);
        border = const Color(0xFFE8CACA);
      case SlotStatus.lesson:
        bg = Colors.transparent;
        border = Colors.transparent;
    }

    final child = DecoratedBox(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: border),
      ),
    );

    if (!canTap) return child;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: child,
    );
  }
}
