import 'package:crm_app/core/enums/user_role.dart';
import 'package:crm_app/core/services/court_availability_service.dart';
import 'package:crm_app/core/widgets/eta_logo.dart';
import 'package:crm_app/features/attendance/attendance_screen.dart';
import 'package:crm_app/features/calendar/coach_calendar_screen.dart';
import 'package:crm_app/features/courts/court_management_screen.dart';
import 'package:crm_app/features/payments/payments_screen.dart';
import 'package:crm_app/features/students/students_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppShell extends ConsumerStatefulWidget {
  const AppShell({super.key});

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  /// Antrenör: 0 Öğrenciler, 1 Yoklama, 2 Takvim (varsayılan), 3 Kortlar, 4 Muhasebe
  int _index = 2;

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    final role = auth.role!;
    final user = auth.user!;
    final narrow = MediaQuery.sizeOf(context).width < 420;

    // Şimdilik yalnızca antrenör akışı aktif.
    if (role != UserRole.coach) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('ETA Tenis'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () => ref.read(authProvider.notifier).logout(),
            ),
          ],
        ),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'Bu rol için panel yakında gelecek.\nŞimdilik antrenör girişi ile devam edin.',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    final pages = <Widget>[
      StudentsScreen(coachId: user.id),
      AttendanceScreen(role: role, userId: user.id),
      CoachCalendarScreen(coachId: user.id),
      CourtManagementScreen(role: role, userId: user.id),
      PaymentsScreen(role: role, userId: user.id),
    ];

    return Scaffold(
      appBar: AppBar(
        titleSpacing: narrow ? 8 : null,
        title: Row(
          children: [
            EtaLogo(
              height: narrow ? 26 : 32,
              onDark: true,
            ),
            if (!narrow) ...[
              const SizedBox(width: 10),
              const Flexible(
                child: Text(
                  'ETA Tenis',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ],
        ),
        actions: [
          if (!narrow)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Chip(
                backgroundColor: Colors.white.withValues(alpha: 0.12),
                side: BorderSide.none,
                labelStyle: const TextStyle(color: Colors.white, fontSize: 12),
                avatar: CircleAvatar(
                  backgroundColor: const Color(0xFFB8D600),
                  child: Text(
                    user.name.characters.first,
                    style: const TextStyle(
                      color: Color(0xFF0B1C2C),
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ),
                label: Text(user.name),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: CircleAvatar(
                radius: 14,
                backgroundColor: const Color(0xFFB8D600),
                child: Text(
                  user.name.characters.first,
                  style: const TextStyle(
                    color: Color(0xFF0B1C2C),
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Çıkış',
            onPressed: () => ref.read(authProvider.notifier).logout(),
          ),
        ],
      ),
      body: IndexedStack(
        index: _index,
        children: pages,
      ),
      bottomNavigationBar: _CoachBottomNav(
        index: _index,
        onChanged: (i) => setState(() => _index = i),
      ),
    );
  }
}

/// Ortada büyük takvim simgesi olan antrenör alt menüsü.
class _CoachBottomNav extends StatelessWidget {
  const _CoachBottomNav({
    required this.index,
    required this.onChanged,
  });

  final int index;
  final ValueChanged<int> onChanged;

  static const _items = <({IconData icon, String label})>[
    (icon: Icons.people_outline, label: 'Öğrenciler'),
    (icon: Icons.fact_check_outlined, label: 'Yoklama'),
    (icon: Icons.calendar_month, label: 'Takvim'),
    (icon: Icons.sports_tennis, label: 'Kortlar'),
    (icon: Icons.account_balance_wallet_outlined, label: 'Muhasebe'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Material(
      elevation: 8,
      color: theme.colorScheme.surface,
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 58,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.bottomCenter,
            children: [
              Row(
                children: [
                  for (var i = 0; i < _items.length; i++)
                    Expanded(
                      child: i == 2
                          ? const SizedBox.shrink()
                          : _NavItem(
                              icon: _items[i].icon,
                              label: _items[i].label,
                              selected: index == i,
                              onTap: () => onChanged(i),
                              color: primary,
                            ),
                    ),
                ],
              ),
              Positioned(
                top: -18,
                child: _CenterCalendarButton(
                  selected: index == 2,
                  onTap: () => onChanged(2),
                  color: primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
    required this.color,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final fg = selected ? color : Colors.grey.shade600;
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 22, color: fg),
          const SizedBox(height: 2),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 10,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }
}

class _CenterCalendarButton extends StatelessWidget {
  const _CenterCalendarButton({
    required this.selected,
    required this.onTap,
    required this.color,
  });

  final bool selected;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final muted = Colors.grey.shade500;
    final bg = selected ? color : Colors.grey.shade300;
    final labelColor = selected ? color : muted;
    final iconColor = selected ? Colors.white : Colors.grey.shade700;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Sabit boyut: layout kayması yok; sadece renk / gölge animasyonu.
          SizedBox(
            width: 54,
            height: 54,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              decoration: BoxDecoration(
                color: bg,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: (selected ? color : Colors.black).withValues(
                      alpha: selected ? 0.32 : 0.12,
                    ),
                    blurRadius: selected ? 10 : 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Icon(Icons.calendar_month, color: iconColor, size: 26),
            ),
          ),
          const SizedBox(height: 2),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            style: TextStyle(
              fontSize: 10,
              fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
              color: labelColor,
            ),
            child: const Text('Takvim'),
          ),
        ],
      ),
    );
  }
}
