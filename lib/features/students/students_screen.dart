import 'package:crm_app/core/database/app_database.dart';
import 'package:crm_app/core/enums/ball_level.dart';
import 'package:crm_app/core/providers/database_provider.dart';
import 'package:crm_app/core/widgets/itf_tennis_ball.dart';
import 'package:crm_app/features/students/widgets/student_form_dialog.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum _StudentSort {
  name,
  ageAsc,
  ageDesc,
  ballLevel,
  group,
}

class StudentsScreen extends ConsumerStatefulWidget {
  const StudentsScreen({super.key, required this.coachId});

  final String coachId;

  @override
  ConsumerState<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends ConsumerState<StudentsScreen> {
  _StudentSort _sort = _StudentSort.name;
  BallLevel? _levelFilter;
  String? _groupFilter; // null = tümü, '' = grupsuz
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  static String? groupFromNotes(String? notes) {
    if (notes == null || notes.isEmpty) return null;
    final m = RegExp(r'Grup:\s*([^\s,;]+)', caseSensitive: false).firstMatch(notes);
    return m?.group(1);
  }

  int _ballRank(String? level) {
    final b = BallLevel.tryParse(level);
    if (b == null) return 99;
    return b.index;
  }

  List<StudentProfile> _apply(
    List<StudentProfile> raw, {
    required Map<String, User> users,
  }) {
    final q = _query.trim().toLowerCase();
    var list = raw.where((p) {
      if (_levelFilter != null) {
        final b = BallLevel.tryParse(p.level);
        if (b != _levelFilter) return false;
      }
      if (_groupFilter != null) {
        final g = groupFromNotes(p.notes);
        if (_groupFilter!.isEmpty) {
          if (g != null) return false;
        } else if (g != _groupFilter) {
          return false;
        }
      }
      if (q.isNotEmpty) {
        final user = users[p.userId];
        final name = user?.name.toLowerCase() ?? '';
        final email = user?.email.toLowerCase() ?? '';
        final group = (groupFromNotes(p.notes) ?? '').toLowerCase();
        final level = BallLevel.normalizeLabel(p.level).toLowerCase();
        final age = p.age?.toString() ?? '';
        if (!name.contains(q) &&
            !email.contains(q) &&
            !group.contains(q) &&
            !level.contains(q) &&
            !age.contains(q)) {
          return false;
        }
      }
      return true;
    }).toList();

    int cmpName(StudentProfile a, StudentProfile b) {
      final na = users[a.userId]?.name ?? '';
      final nb = users[b.userId]?.name ?? '';
      return na.toLowerCase().compareTo(nb.toLowerCase());
    }

    list.sort((a, b) {
      switch (_sort) {
        case _StudentSort.name:
          return cmpName(a, b);
        case _StudentSort.ageAsc:
          final c = (a.age ?? 999).compareTo(b.age ?? 999);
          return c != 0 ? c : cmpName(a, b);
        case _StudentSort.ageDesc:
          final c = (b.age ?? -1).compareTo(a.age ?? -1);
          return c != 0 ? c : cmpName(a, b);
        case _StudentSort.ballLevel:
          final c = _ballRank(a.level).compareTo(_ballRank(b.level));
          return c != 0 ? c : cmpName(a, b);
        case _StudentSort.group:
          final ga = groupFromNotes(a.notes) ?? 'ÿÿÿ';
          final gb = groupFromNotes(b.notes) ?? 'ÿÿÿ';
          final c = ga.toLowerCase().compareTo(gb.toLowerCase());
          return c != 0 ? c : cmpName(a, b);
      }
    });
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final db = ref.watch(databaseProvider);
    final profilesStream = db.watchStudentsForCoach(widget.coachId);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Öğrencilerim',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              FilledButton.icon(
                onPressed: () async {
                  await showDialog(
                    context: context,
                    builder: (_) => StudentFormDialog(coachId: widget.coachId),
                  );
                },
                icon: const Icon(Icons.person_add),
                label: const Text('Öğrenci Ekle'),
              ),
            ],
          ),
        ),
        Expanded(
          child: StreamBuilder<List<StudentProfile>>(
            stream: profilesStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              final profiles = snapshot.data ?? [];
              if (profiles.isEmpty) {
                return const Center(child: Text('Henüz öğrenci eklenmemiş'));
              }

              return FutureBuilder<Map<String, User>>(
                future: () async {
                  final users = await db.getUsersByIds(
                    profiles.map((p) => p.userId).toList(),
                  );
                  return {for (final u in users) u.id: u};
                }(),
                builder: (context, userSnap) {
                  final users = userSnap.data ?? {};
                  final groups = <String>{
                    for (final p in profiles)
                      if (groupFromNotes(p.notes) != null) groupFromNotes(p.notes)!,
                  }.toList()
                    ..sort();

                  final filtered = _apply(profiles, users: users);

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: TextField(
                          controller: _searchController,
                          onChanged: (v) => setState(() => _query = v),
                          textInputAction: TextInputAction.search,
                          decoration: InputDecoration(
                            hintText: 'İsim, e-posta, grup veya seviye ara…',
                            prefixIcon: const Icon(Icons.search),
                            isDense: true,
                            suffixIcon: _query.isEmpty
                                ? null
                                : IconButton(
                                    tooltip: 'Temizle',
                                    onPressed: () {
                                      _searchController.clear();
                                      setState(() => _query = '');
                                    },
                                    icon: const Icon(Icons.close),
                                  ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<_StudentSort>(
                                value: _sort,
                                isDense: true,
                                isExpanded: true,
                                decoration: const InputDecoration(
                                  labelText: 'Sırala',
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                ),
                                items: const [
                                  DropdownMenuItem(
                                    value: _StudentSort.name,
                                    child: Text('İsim'),
                                  ),
                                  DropdownMenuItem(
                                    value: _StudentSort.ageAsc,
                                    child: Text('Yaş (küçük → büyük)'),
                                  ),
                                  DropdownMenuItem(
                                    value: _StudentSort.ageDesc,
                                    child: Text('Yaş (büyük → küçük)'),
                                  ),
                                  DropdownMenuItem(
                                    value: _StudentSort.ballLevel,
                                    child: Text('Top seviyesi'),
                                  ),
                                  DropdownMenuItem(
                                    value: _StudentSort.group,
                                    child: Text('Grup'),
                                  ),
                                ],
                                onChanged: (v) {
                                  if (v == null) return;
                                  setState(() => _sort = v);
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${filtered.length}/${profiles.length}',
                              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                    color: Colors.grey.shade600,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      _HorizontalChipScroller(
                        children: [
                          FilterChip(
                            label: const Text('Tümü'),
                            selected: _levelFilter == null,
                            onSelected: (_) => setState(() => _levelFilter = null),
                          ),
                          for (final level in BallLevel.values)
                            FilterChip(
                              avatar: ItfTennisBallAvatar(level: level, size: 18),
                              label: Text(level.label[0]),
                              selected: _levelFilter == level,
                              onSelected: (_) => setState(() {
                                _levelFilter =
                                    _levelFilter == level ? null : level;
                              }),
                            ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      _HorizontalChipScroller(
                        children: [
                          FilterChip(
                            label: const Text('Tüm gruplar'),
                            selected: _groupFilter == null,
                            onSelected: (_) => setState(() => _groupFilter = null),
                          ),
                          FilterChip(
                            label: const Text('Grupsuz'),
                            selected: _groupFilter == '',
                            onSelected: (_) => setState(() {
                              _groupFilter = _groupFilter == '' ? null : '';
                            }),
                          ),
                          for (final g in groups)
                            FilterChip(
                              label: Text(g),
                              selected: _groupFilter == g,
                              onSelected: (_) => setState(() {
                                _groupFilter = _groupFilter == g ? null : g;
                              }),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: filtered.isEmpty
                            ? const Center(child: Text('Bu arama/filtreye uygun öğrenci yok'))
                            : ListView.builder(
                                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                                itemCount: filtered.length,
                                itemBuilder: (context, index) {
                                  final profile = filtered[index];
                                  final user = users[profile.userId];
                                  if (user == null) return const SizedBox.shrink();
                                  return _StudentTile(
                                    profile: profile,
                                    user: user,
                                    coachId: widget.coachId,
                                    groupCode: groupFromNotes(profile.notes),
                                  );
                                },
                              ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Masaüstü / önizlemede fare ile yatay sürüklemeyi açar.
class _DragScrollBehavior extends MaterialScrollBehavior {
  const _DragScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.stylus,
      };
}

class _HorizontalChipScroller extends StatelessWidget {
  const _HorizontalChipScroller({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: const _DragScrollBehavior(),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        primary: false,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            for (var i = 0; i < children.length; i++) ...[
              if (i > 0) const SizedBox(width: 6),
              children[i],
            ],
          ],
        ),
      ),
    );
  }
}

class _StudentTile extends ConsumerWidget {
  const _StudentTile({
    required this.profile,
    required this.user,
    required this.coachId,
    this.groupCode,
  });

  final StudentProfile profile;
  final User user;
  final String coachId;
  final String? groupCode;

  Future<bool> _confirmRemove(BuildContext context, String name) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Öğrenciyi Çıkar'),
        content: Text('$name listenizden çıkarılsın mı?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('İptal')),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
            ),
            child: const Text('Çıkar'),
          ),
        ],
      ),
    );
    return confirm == true;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dismissible(
      key: ValueKey('student-${profile.userId}-${profile.coachId}'),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) => _confirmRemove(context, user.name),
      onDismissed: (_) {
        ref.read(databaseProvider).removeStudentFromCoach(profile.userId, coachId);
      },
      background: Container(
        alignment: Alignment.centerRight,
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.error,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'Çıkar',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
            SizedBox(width: 8),
            Icon(Icons.delete_outline, color: Colors.white),
          ],
        ),
      ),
      child: Card(
        margin: const EdgeInsets.only(bottom: 8),
        child: ListTile(
          leading: ItfTennisBallAvatar(
            level: BallLevel.tryParse(profile.level),
            size: 44,
          ),
          title: Text(user.name),
          subtitle: Text(
            [
              if (profile.age != null) '${profile.age} yaş',
              if (groupCode != null) 'Grup $groupCode',
              user.email,
            ].join(' · '),
          ),
          trailing: PopupMenuButton<String>(
            onSelected: (action) async {
              if (action == 'edit') {
                await showDialog(
                  context: context,
                  builder: (_) => StudentFormDialog(
                    coachId: coachId,
                    existingProfile: profile,
                    existingUser: user,
                  ),
                );
              } else if (action == 'remove') {
                final confirmed = await _confirmRemove(context, user.name);
                if (confirmed) {
                  await ref
                      .read(databaseProvider)
                      .removeStudentFromCoach(profile.userId, coachId);
                }
              }
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'edit', child: Text('Düzenle')),
              PopupMenuItem(value: 'remove', child: Text('Listeden Çıkar')),
            ],
          ),
        ),
      ),
    );
  }
}
