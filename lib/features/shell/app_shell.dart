import 'package:crm_app/core/constants/app_constants.dart';
import 'package:crm_app/core/enums/user_role.dart';
import 'package:crm_app/core/services/court_availability_service.dart';
import 'package:crm_app/features/calendar/coach_calendar_screen.dart';
import 'package:crm_app/features/courts/court_management_screen.dart';
import 'package:crm_app/features/dashboard/dashboard_screen.dart';
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
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    final role = auth.role!;
    final user = auth.user!;

    final destinations = _destinationsForRole(role);
    final pages = _pagesForRole(role, user.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppConstants.appName),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Chip(
              avatar: CircleAvatar(
                child: Text(user.name.characters.first),
              ),
              label: Text('${user.name} (${role.label})'),
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
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: destinations,
      ),
    );
  }

  List<NavigationDestination> _destinationsForRole(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return const [
          NavigationDestination(icon: Icon(Icons.dashboard), label: 'Panel'),
          NavigationDestination(icon: Icon(Icons.sports_tennis), label: 'Kortlar'),
          NavigationDestination(icon: Icon(Icons.payments), label: 'Ödemeler'),
        ];
      case UserRole.coach:
        return const [
          NavigationDestination(icon: Icon(Icons.dashboard), label: 'Panel'),
          NavigationDestination(icon: Icon(Icons.calendar_month), label: 'Takvim'),
          NavigationDestination(icon: Icon(Icons.people), label: 'Öğrenciler'),
          NavigationDestination(icon: Icon(Icons.sports_tennis), label: 'Kortlar'),
          NavigationDestination(icon: Icon(Icons.payments), label: 'Ödemeler'),
        ];
      case UserRole.athlete:
        return const [
          NavigationDestination(icon: Icon(Icons.dashboard), label: 'Panel'),
          NavigationDestination(icon: Icon(Icons.sports_tennis), label: 'Kort Kirala'),
          NavigationDestination(icon: Icon(Icons.payments), label: 'Ödemelerim'),
        ];
      case UserRole.parent:
        return const [
          NavigationDestination(icon: Icon(Icons.dashboard), label: 'Panel'),
          NavigationDestination(icon: Icon(Icons.payments), label: 'Ödemeler'),
        ];
    }
  }

  List<Widget> _pagesForRole(UserRole role, String userId) {
    switch (role) {
      case UserRole.admin:
        return [
          DashboardScreen(role: role, userId: userId),
          CourtManagementScreen(role: role, userId: userId),
          PaymentsScreen(role: role, userId: userId),
        ];
      case UserRole.coach:
        return [
          DashboardScreen(role: role, userId: userId),
          CoachCalendarScreen(coachId: userId),
          StudentsScreen(coachId: userId),
          CourtManagementScreen(role: role, userId: userId),
          PaymentsScreen(role: role, userId: userId),
        ];
      case UserRole.athlete:
        return [
          DashboardScreen(role: role, userId: userId),
          CourtManagementScreen(role: role, userId: userId),
          PaymentsScreen(role: role, userId: userId),
        ];
      case UserRole.parent:
        return [
          DashboardScreen(role: role, userId: userId),
          PaymentsScreen(role: role, userId: userId),
        ];
    }
  }
}
