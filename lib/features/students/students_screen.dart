import 'dart:async';

import 'package:crm_app/core/database/app_database.dart';
import 'package:crm_app/core/enums/ball_level.dart';
import 'package:crm_app/core/providers/database_provider.dart';
import 'package:crm_app/core/theme/app_theme.dart';
import 'package:crm_app/core/utils/student_notes.dart';
import 'package:crm_app/core/widgets/itf_tennis_ball.dart';
import 'package:crm_app/features/students/widgets/student_form_dialog.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum _StudentsPane { groups, privates, all }

class StudentsScreen extends ConsumerStatefulWidget {
  const StudentsScreen({super.key, required this.coachId});

  final String coachId;

  @override
  ConsumerState<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends ConsumerState<StudentsScreen> {
  _StudentsPane _pane = _StudentsPane.groups;
  final _searchController = TextEditingController();
  String _query = '';
  _RosterData? _roster;
  StreamSubscription<List<StudentProfile>>? _profilesSub;
  StreamSubscription<List<Lesson>>? _lessonsSub;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    final db = ref.read(databaseProvider);
    Future<void> reload([List<StudentProfile>? profiles]) async {
      final list = profiles ?? await db.getStudentsForCoach(widget.coachId);
      final data = await _loadRoster(db, list);
      if (!mounted) return;
      setState(() {
        _roster = data;
        _loading = false;
      });
    }

    _profilesSub = db.watchStudentsForCoach(widget.coachId).listen(reload);
    _lessonsSub = db.watchLessonsForCoach(widget.coachId).listen((_) => reload());
  }

  @override
  void dispose() {
    _profilesSub?.cancel();
    _lessonsSub?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _addStudent() async {
    await showDialog(
      context: context,
      builder: (_) => StudentFormDialog(coachId: widget.coachId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 8, 8),
          child: Row(
            children: [
              Expanded(
                child: SegmentedButton<_StudentsPane>(
                  showSelectedIcon: false,
                  style: const ButtonStyle(
                    visualDensity: VisualDensity.compact,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  segments: const [
                    ButtonSegment(
                      value: _StudentsPane.groups,
                      label: Text('GRUP'),
                    ),
                    ButtonSegment(
                      value: _StudentsPane.privates,
                      label: Text('ÖZEL'),
                    ),
                    ButtonSegment(
                      value: _StudentsPane.all,
                      label: Text('DİĞER'),
                    ),
                  ],
                  selected: {_pane},
                  onSelectionChanged: (s) => setState(() => _pane = s.first),
                ),
              ),
              IconButton(
                tooltip: 'Öğrenci Ekle',
                onPressed: _addStudent,
                icon: const Icon(Icons.person_add_alt_1),
              ),
            ],
          ),
        ),
        Expanded(
          child: _loading && _roster == null
              ? const Center(child: CircularProgressIndicator())
              : _roster == null || _roster!.profiles.isEmpty
                  ? const Center(child: Text('Henüz öğrenci eklenmemiş'))
                  : switch (_pane) {
                      _StudentsPane.groups => _GroupsGrid(
                          clusters: _roster!.groups,
                          coachId: widget.coachId,
                        ),
                      _StudentsPane.privates => _PrivateLessonsList(
                          clusters: _roster!.privates,
                          coachId: widget.coachId,
                        ),
                      _StudentsPane.all => _AllStudentsList(
                          profiles: _roster!.profiles,
                          users: _roster!.users,
                          coachId: widget.coachId,
                          query: _query,
                          searchController: _searchController,
                          onQueryChanged: (v) => setState(() => _query = v),
                          onClearQuery: () {
                            _searchController.clear();
                            setState(() => _query = '');
                          },
                        ),
                    },
        ),
      ],
    );
  }

  Future<_RosterData> _loadRoster(
    AppDatabase db,
    List<StudentProfile> profiles,
  ) async {
    final users = {
      for (final u in await db.getUsersByIds(profiles.map((p) => p.userId).toList()))
        u.id: u,
    };

    final profileByUser = {for (final p in profiles) p.userId: p};
    final byGroup = <String, List<_RosterMember>>{};
    final privateByNotes = <_RosterMember>[];
    for (final p in profiles) {
      final user = users[p.userId];
      if (user == null) continue;
      final member = _RosterMember(profile: p, user: user);
      final code = StudentNotes.groupCode(p.notes);
      if (code != null && code.isNotEmpty) {
        byGroup.putIfAbsent(code, () => []).add(member);
      } else if (StudentNotes.looksLikePrivate(p.notes)) {
        privateByNotes.add(member);
      }
    }

    final now = DateTime.now();
    final lessons = await db.watchLessonsForCoach(widget.coachId).first;
    final concrete = lessons.where((l) => !l.isTemplate).toList();
    final past = concrete.where((l) => !l.startTime.isAfter(now)).toList();

    final groupDone = <String, int>{};
    for (final l in past.where((l) => l.type == 'group')) {
      final key = (l.title ?? '').trim().toLowerCase();
      if (key.isEmpty) continue;
      groupDone[key] = (groupDone[key] ?? 0) + 1;
    }

    final privateParts = await db.getParticipantsForLessons(
      past.where((l) => l.type == 'private').map((l) => l.id).toList(),
    );
    final privateIdsByLesson = <String, List<String>>{};
    for (final p in privateParts) {
      privateIdsByLesson.putIfAbsent(p.lessonId, () => []).add(p.userId);
    }

    _LessonStats statsForMembers(List<String> memberIds) {
      final want = [...memberIds]..sort();
      final wantKey = want.join('|');
      Lesson? last;
      var count = 0;
      for (final l in past.where((l) => l.type == 'private')) {
        final ids = [...(privateIdsByLesson[l.id] ?? const <String>[])]..sort();
        if (ids.join('|') != wantKey) continue;
        count++;
        if (last == null || l.startTime.isAfter(last.startTime)) last = l;
      }
      return _LessonStats(
        doneCount: count,
        lastAt: last?.startTime,
        lastNote: _coachFocusNote(last?.notes),
        lastLessonId: last?.id,
      );
    }

    final groupClusters = byGroup.entries.map((e) {
      final members = [...e.value]
        ..sort((a, b) => firstNameOf(a.user.name).toLowerCase().compareTo(
              firstNameOf(b.user.name).toLowerCase(),
            ));
      final level = _groupBallLevel(members);
      final codeKey = e.key.toLowerCase();
      return _RosterCluster(
        title: e.key.toUpperCase(),
        members: members,
        ballLevel: level,
        stats: _LessonStats(doneCount: groupDone[codeKey] ?? 0),
      );
    }).toList()
      ..sort((a, b) => a.title.compareTo(b.title));

    final privateClusters = <_RosterCluster>[];
    final clusteredIds = <String>{};
    final idSets = await db.getPrivateLessonClusters(widget.coachId);
    final extraUserIds = <String>[
      for (final ids in idSets)
        for (final id in ids)
          if (!users.containsKey(id)) id,
    ];
    if (extraUserIds.isNotEmpty) {
      for (final u in await db.getUsersByIds(extraUserIds)) {
        users[u.id] = u;
      }
    }

    for (final ids in idSets) {
      final members = <_RosterMember>[];
      for (final id in ids) {
        final user = users[id];
        if (user == null) continue;
        members.add(_RosterMember(profile: profileByUser[id], user: user));
        clusteredIds.add(id);
      }
      if (members.isEmpty) continue;
      members.sort((a, b) => firstNameOf(a.user.name).toLowerCase().compareTo(
            firstNameOf(b.user.name).toLowerCase(),
          ));
      privateClusters.add(
        _RosterCluster(
          title: 'ÖZEL',
          members: members,
          ballLevel: _groupBallLevel(members),
          stats: statsForMembers(members.map((m) => m.user.id).toList()),
        ),
      );
    }

    for (final member in privateByNotes) {
      if (clusteredIds.contains(member.user.id)) continue;
      privateClusters.add(
        _RosterCluster(
          title: 'ÖZEL',
          members: [member],
          ballLevel: BallLevel.tryParse(member.profile?.level),
          stats: statsForMembers([member.user.id]),
        ),
      );
    }

    privateClusters.sort((a, b) {
      final da = b.stats.lastAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final db_ = a.stats.lastAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      return da.compareTo(db_);
    });

    return _RosterData(
      profiles: profiles,
      users: users,
      groups: groupClusters,
      privates: privateClusters,
    );
  }
}

BallLevel? _groupBallLevel(List<_RosterMember> members) {
  final counts = <BallLevel, int>{};
  for (final m in members) {
    final level = BallLevel.tryParse(m.profile?.level);
    if (level == null) continue;
    counts[level] = (counts[level] ?? 0) + 1;
  }
  if (counts.isEmpty) return null;
  return counts.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
}

String? _coachFocusNote(String? raw) {
  if (raw == null) return null;
  final t = raw.trim();
  if (t.isEmpty) return null;
  final lower = t.toLowerCase();
  if (lower == 'haftalık özel ders' || lower == 'haftalık grup dersi') return null;
  return t;
}

class _LessonStats {
  const _LessonStats({
    required this.doneCount,
    this.lastAt,
    this.lastNote,
    this.lastLessonId,
  });

  final int doneCount;
  final DateTime? lastAt;
  final String? lastNote;
  final String? lastLessonId;
}

class _RosterMember {
  const _RosterMember({required this.user, this.profile});
  final User user;
  final StudentProfile? profile;
}

class _RosterCluster {
  const _RosterCluster({
    required this.title,
    required this.members,
    this.ballLevel,
    this.stats = const _LessonStats(doneCount: 0),
  });

  final String title;
  final List<_RosterMember> members;
  final BallLevel? ballLevel;
  final _LessonStats stats;
}

class _RosterData {
  const _RosterData({
    required this.profiles,
    required this.users,
    required this.groups,
    required this.privates,
  });
  final List<StudentProfile> profiles;
  final Map<String, User> users;
  final List<_RosterCluster> groups;
  final List<_RosterCluster> privates;
}

String _formatShortTrDate(DateTime d) {
  final months = [
    'oca', 'şub', 'mar', 'nis', 'may', 'haz',
    'tem', 'ağu', 'eyl', 'eki', 'kas', 'ara',
  ];
  return '${d.day} ${months[d.month - 1]}';
}

/// Tercihen 5 sütun; sığmazsa 4 (geniş ekranda 6).
int _groupColumnCount(double width) {
  const pad = 16.0;
  const gap = 6.0;
  const minCell = 68.0;
  double cellW(int cols) => (width - pad - gap * (cols - 1)) / cols;

  if (width >= 980 && cellW(6) >= minCell) return 6;
  if (cellW(5) >= minCell) return 5;
  return 4;
}

class _GroupsGrid extends StatelessWidget {
  const _GroupsGrid({
    required this.clusters,
    required this.coachId,
  });

  final List<_RosterCluster> clusters;
  final String coachId;

  @override
  Widget build(BuildContext context) {
    if (clusters.isEmpty) {
      return const Center(child: Text('Henüz grup yok'));
    }

    final maxMembers = clusters.fold<int>(
      0,
      (m, c) => c.members.length > m ? c.members.length : m,
    );
    // Başlık + isimler; ekranı doldurmaz, içeriğe göre kısa kalır.
    final cellH = (30.0 + 6 + maxMembers * 14.5 + 8).clamp(92.0, 128.0);

    return LayoutBuilder(
      builder: (context, constraints) {
        final cols = _groupColumnCount(constraints.maxWidth);
        const spacing = 8.0;
        const padding = 10.0;

        return GridView.builder(
          padding: const EdgeInsets.fromLTRB(padding, 0, padding, padding),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: cols,
            mainAxisSpacing: spacing,
            crossAxisSpacing: spacing,
            mainAxisExtent: cellH,
          ),
          itemCount: clusters.length,
          itemBuilder: (context, index) {
            final cluster = clusters[index];
            return _GroupCard(
              cluster: cluster,
              onTap: () => _showClusterSheet(context, cluster, coachId),
            );
          },
        );
      },
    );
  }
}

class _GroupCard extends StatelessWidget {
  const _GroupCard({
    required this.cluster,
    required this.onTap,
  });

  final _RosterCluster cluster;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final names = cluster.members.map((m) => firstNameOf(m.user.name)).toList();
    final level = cluster.ballLevel ?? BallLevel.yellow;
    final done = cluster.stats.doneCount;

    return Material(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.navy.withValues(alpha: 0.08)),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ColoredBox(
              color: level.strong,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        cluster.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: level.onStrong,
                          fontWeight: FontWeight.w800,
                          fontSize: 11,
                          letterSpacing: 0.2,
                          height: 1.1,
                        ),
                      ),
                    ),
                    if (done > 0)
                      Container(
                        margin: const EdgeInsets.only(left: 3),
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                        decoration: BoxDecoration(
                          color: level.onStrong.withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          '$done',
                          style: TextStyle(
                            color: level.onStrong,
                            fontWeight: FontWeight.w800,
                            fontSize: 10,
                            height: 1.1,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(7, 5, 7, 5),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.topLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (final name in names)
                        Text(
                          name,
                          style: TextStyle(
                            color: AppColors.navy.withValues(alpha: 0.88),
                            fontSize: 12,
                            height: 1.28,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PrivateLessonsList extends ConsumerWidget {
  const _PrivateLessonsList({
    required this.clusters,
    required this.coachId,
  });

  final List<_RosterCluster> clusters;
  final String coachId;

  Future<void> _editNote(BuildContext context, WidgetRef ref, _RosterCluster cluster) async {
    final lessonId = cluster.stats.lastLessonId;
    if (lessonId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Henüz yapılmış özel ders yok')),
      );
      return;
    }
    final controller = TextEditingController(text: cluster.stats.lastNote ?? '');
    final saved = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Son ders notu'),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLength: 40,
          decoration: const InputDecoration(
            hintText: 'ör. servis ritmi',
            helperText: '2–3 kelime yeter',
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('İptal')),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, controller.text.trim()),
            child: const Text('Kaydet'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (saved == null) return;
    await ref.read(databaseProvider).updateLesson(
          lessonId,
          LessonsCompanion(notes: Value(saved.isEmpty ? null : saved)),
        );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (clusters.isEmpty) {
      return const Center(child: Text('Aktif özel ders öğrencisi yok'));
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
      itemCount: clusters.length,
      separatorBuilder: (_, __) => const SizedBox(height: 6),
      itemBuilder: (context, index) {
        final cluster = clusters[index];
        final stats = cluster.stats;
        final meta = <String>[
          '${stats.doneCount} ders',
          if (stats.lastAt != null) _formatShortTrDate(stats.lastAt!),
        ];
        final note = stats.lastNote;

        return Material(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: AppColors.navy.withValues(alpha: 0.10)),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () => _showClusterSheet(context, cluster, coachId),
            onLongPress: () => _editNote(context, ref, cluster),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 8, 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ItfTennisBallAvatar(
                              level: cluster.ballLevel,
                              size: 18,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                cluster.members
                                    .map((m) => firstNameOf(m.user.name))
                                    .join(', '),
                                style: const TextStyle(
                                  color: AppColors.navy,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          meta.join(' · '),
                          style: TextStyle(
                            color: AppColors.navy.withValues(alpha: 0.65),
                            fontSize: 12.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (note != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            note,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: AppColors.navy.withValues(alpha: 0.85),
                              fontSize: 12.5,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: 'Son ders notu',
                    visualDensity: VisualDensity.compact,
                    onPressed: () => _editNote(context, ref, cluster),
                    icon: Icon(
                      note == null ? Icons.note_add_outlined : Icons.edit_note,
                      color: AppColors.navyMuted,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

Future<void> _showClusterSheet(
  BuildContext context,
  _RosterCluster cluster,
  String coachId,
) {
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (ctx) {
      return SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          shrinkWrap: true,
          children: [
            Text(
              cluster.title,
              style: Theme.of(ctx).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              [
                '${cluster.members.length} öğrenci',
                if (cluster.stats.doneCount > 0) '${cluster.stats.doneCount} ders yapıldı',
                if (cluster.stats.lastAt != null)
                  'Son: ${_formatShortTrDate(cluster.stats.lastAt!)}',
              ].join(' · '),
              style: Theme.of(ctx).textTheme.bodySmall?.copyWith(
                    color: AppColors.navyMuted,
                  ),
            ),
            const SizedBox(height: 12),
            for (final member in cluster.members)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: ItfTennisBallAvatar(
                  level: BallLevel.tryParse(member.profile?.level),
                  size: 36,
                ),
                title: Text(member.user.name),
                subtitle: member.profile?.age != null
                    ? Text('${member.profile!.age} yaş')
                    : null,
                trailing: member.profile == null
                    ? null
                    : IconButton(
                        tooltip: 'Düzenle',
                        icon: const Icon(Icons.edit_outlined),
                        onPressed: () async {
                          Navigator.pop(ctx);
                          await showDialog(
                            context: context,
                            builder: (_) => StudentFormDialog(
                              coachId: coachId,
                              existingProfile: member.profile,
                              existingUser: member.user,
                            ),
                          );
                        },
                      ),
              ),
          ],
        ),
      );
    },
  );
}

class _AllStudentsList extends StatelessWidget {
  const _AllStudentsList({
    required this.profiles,
    required this.users,
    required this.coachId,
    required this.query,
    required this.searchController,
    required this.onQueryChanged,
    required this.onClearQuery,
  });

  final List<StudentProfile> profiles;
  final Map<String, User> users;
  final String coachId;
  final String query;
  final TextEditingController searchController;
  final ValueChanged<String> onQueryChanged;
  final VoidCallback onClearQuery;

  @override
  Widget build(BuildContext context) {
    final q = query.trim().toLowerCase();
    final filtered = [...profiles]..sort((a, b) {
        final na = users[a.userId]?.name ?? '';
        final nb = users[b.userId]?.name ?? '';
        return na.toLowerCase().compareTo(nb.toLowerCase());
      });
    final visible = filtered.where((p) {
      if (q.isEmpty) return true;
      final user = users[p.userId];
      final name = user?.name.toLowerCase() ?? '';
      final email = user?.email.toLowerCase() ?? '';
      final group = (StudentNotes.groupCode(p.notes) ?? '').toLowerCase();
      return name.contains(q) || email.contains(q) || group.contains(q);
    }).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
          child: TextField(
            controller: searchController,
            onChanged: onQueryChanged,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: 'İsim veya grup ara…',
              prefixIcon: const Icon(Icons.search),
              isDense: true,
              suffixIcon: query.isEmpty
                  ? null
                  : IconButton(
                      tooltip: 'Temizle',
                      onPressed: onClearQuery,
                      icon: const Icon(Icons.close),
                    ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '${visible.length}/${profiles.length} öğrenci',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Colors.grey.shade600,
                  ),
            ),
          ),
        ),
        Expanded(
          child: visible.isEmpty
              ? const Center(child: Text('Bu aramaya uygun öğrenci yok'))
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
                  itemCount: visible.length,
                  itemBuilder: (context, index) {
                    final profile = visible[index];
                    final user = users[profile.userId];
                    if (user == null) return const SizedBox.shrink();
                    return _StudentTile(
                      profile: profile,
                      user: user,
                      coachId: coachId,
                      groupCode: StudentNotes.groupCode(profile.notes),
                    );
                  },
                ),
        ),
      ],
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
              if (groupCode != null) 'Grup ${groupCode!.toUpperCase()}',
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
