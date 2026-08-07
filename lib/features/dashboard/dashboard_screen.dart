import 'package:crm_app/core/enums/user_role.dart';
import 'package:crm_app/core/providers/database_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({
    super.key,
    required this.role,
    required this.userId,
  });

  final UserRole role;
  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hoş geldiniz',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            _subtitleForRole(role),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey.shade700,
                ),
          ),
          const SizedBox(height: 24),
          ..._cardsForRole(context, ref),
        ],
      ),
    );
  }

  String _subtitleForRole(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return 'Kortları kilitleyebilir, ödemeleri takip edebilir ve kulübü yönetebilirsiniz.';
      case UserRole.coach:
        return 'Takviminizden ders planlayın, öğrencilerinizi yönetin.';
      case UserRole.athlete:
        return 'Boş kortları görüntüleyin ve kiralama yapın.';
      case UserRole.parent:
        return 'Çocuğunuzun ödemelerini ve durumunu takip edin.';
    }
  }

  List<Widget> _cardsForRole(BuildContext context, WidgetRef ref) {
    switch (role) {
      case UserRole.admin:
        return [
          _InfoCard(
            icon: Icons.sports_tennis,
            title: 'Kort Yönetimi',
            subtitle: 'Kortları kilitleyin veya müsaitlik durumunu görün',
          ),
          _InfoCard(
            icon: Icons.fact_check,
            title: 'Yoklama Takibi',
            subtitle: 'Antrenörlerin aldığı yoklamaları görün',
          ),
          _InfoCard(
            icon: Icons.payments,
            title: 'Ödeme Takibi',
            subtitle: 'Tüm ödemeleri yönetin',
          ),
        ];
      case UserRole.coach:
        return [
          _InfoCard(
            icon: Icons.calendar_month,
            title: 'Antrenör Takvimi',
            subtitle: '08:00-24:00 arası ders planlayın, sürükle-bırak ile düzenleyin',
          ),
          _InfoCard(
            icon: Icons.people,
            title: 'Öğrencilerim',
            subtitle: 'Öğrenci ekle/çıkar, seviye ve yaş düzenle',
          ),
          _InfoCard(
            icon: Icons.fact_check,
            title: 'Yoklama',
            subtitle: 'Derslerde yoklama alın, devam durumunu kaydedin',
          ),
        ];
      case UserRole.athlete:
        return [
          _InfoCard(
            icon: Icons.sports_tennis,
            title: 'Kort Kiralama',
            subtitle: 'Boş kortlara rezervasyon yapın',
          ),
          _InfoCard(
            icon: Icons.fact_check,
            title: 'Yoklamalarım',
            subtitle: 'Ders devam durumunuzu görün',
          ),
          _InfoCard(
            icon: Icons.payments,
            title: 'Ödemelerim',
            subtitle: 'Aidat ve ders ödemelerinizi görün',
          ),
        ];
      case UserRole.parent:
        return [
          _ParentAthletesCard(parentId: userId),
          _InfoCard(
            icon: Icons.fact_check,
            title: 'Yoklama',
            subtitle: 'Çocuğunuzun ders devamını takip edin',
          ),
          _InfoCard(
            icon: Icons.payments,
            title: 'Ödemeler',
            subtitle: 'Çocuğunuzun ödeme durumunu takip edin',
          ),
        ];
    }
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, size: 32),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
      ),
    );
  }
}

class _ParentAthletesCard extends ConsumerWidget {
  const _ParentAthletesCard({required this.parentId});

  final String parentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
      future: ref.read(databaseProvider).getAthletesForParent(parentId),
      builder: (context, snapshot) {
        final athletes = snapshot.data ?? [];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.child_care, color: Theme.of(context).colorScheme.primary),
                    const SizedBox(width: 8),
                    Text('Sporcularım', style: Theme.of(context).textTheme.titleMedium),
                  ],
                ),
                const SizedBox(height: 8),
                if (athletes.isEmpty)
                  const Text('Bağlı sporcu bulunamadı')
                else
                  ...athletes.map((a) => ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const CircleAvatar(child: Icon(Icons.person)),
                        title: Text(a.name),
                        subtitle: Text(a.email),
                      )),
              ],
            ),
          ),
        );
      },
    );
  }
}
