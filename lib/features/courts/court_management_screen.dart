import 'dart:math' as math;

import 'package:crm_app/core/constants/app_constants.dart';
import 'package:crm_app/core/enums/user_role.dart';
import 'package:crm_app/core/providers/database_provider.dart';
import 'package:crm_app/core/services/court_availability_service.dart';
import 'package:crm_app/core/theme/app_theme.dart';
import 'package:crm_app/core/utils/app_date_format.dart';
import 'package:crm_app/features/courts/widgets/block_court_dialog.dart';
import 'package:crm_app/features/courts/widgets/court_slot_cell.dart';
import 'package:crm_app/features/courts/widgets/rent_court_dialog.dart';
import 'package:crm_app/features/courts/widgets/week_slot_cell.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum _CourtViewMode { day, week }

class CourtManagementScreen extends ConsumerStatefulWidget {
  const CourtManagementScreen({
    super.key,
    required this.role,
    required this.userId,
  });

  final UserRole role;
  final String userId;

  @override
  ConsumerState<CourtManagementScreen> createState() => _CourtManagementScreenState();
}

class _CourtManagementScreenState extends ConsumerState<CourtManagementScreen> {
  DateTime _selectedDay = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  _CourtViewMode _mode = _CourtViewMode.day;

  DateTime get _weekMonday {
    return _selectedDay.subtract(Duration(days: _selectedDay.weekday - DateTime.monday));
  }

  void _prev() {
    setState(() {
      _selectedDay = _selectedDay.subtract(
        Duration(days: _mode == _CourtViewMode.day ? 1 : 7),
      );
    });
  }

  void _next() {
    setState(() {
      _selectedDay = _selectedDay.add(
        Duration(days: _mode == _CourtViewMode.day ? 1 : 7),
      );
    });
  }

  void _goToday() {
    final now = DateTime.now();
    setState(() => _selectedDay = DateTime(now.year, now.month, now.day));
  }

  Future<void> _pickDay() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDay,
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 90)),
      locale: const Locale('tr', 'TR'),
    );
    if (picked != null) {
      setState(() => _selectedDay = DateTime(picked.year, picked.month, picked.day));
    }
  }

  Future<void> _refresh() async => setState(() {});

  @override
  Widget build(BuildContext context) {
    final service = ref.watch(courtAvailabilityServiceProvider);
    final isWeek = _mode == _CourtViewMode.week;
    final rangeLabel = isWeek
        ? AppDateFormat.weekRange(_weekMonday, _weekMonday.add(const Duration(days: 6)))
        : AppDateFormat.fullDay(_selectedDay);
    final narrow = MediaQuery.sizeOf(context).width < 420;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(narrow ? 8 : 12, 12, narrow ? 8 : 12, 4),
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              Text(
                widget.role == UserRole.athlete ? 'Kort Kiralama' : 'Kort Yönetimi',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SegmentedButton<_CourtViewMode>(
                segments: const [
                  ButtonSegment(
                    value: _CourtViewMode.day,
                    label: Text('Gün', style: TextStyle(fontSize: 12)),
                    icon: Icon(Icons.view_day_outlined, size: 16),
                  ),
                  ButtonSegment(
                    value: _CourtViewMode.week,
                    label: Text('7 Gün', style: TextStyle(fontSize: 12)),
                    icon: Icon(Icons.view_week_outlined, size: 16),
                  ),
                ],
                selected: {_mode},
                onSelectionChanged: (s) => setState(() => _mode = s.first),
                style: const ButtonStyle(
                  visualDensity: VisualDensity.compact,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            children: [
              IconButton(
                tooltip: isWeek ? 'Önceki hafta' : 'Önceki gün',
                onPressed: _prev,
                icon: const Icon(Icons.chevron_left),
              ),
              Expanded(
                child: InkWell(
                  onTap: _pickDay,
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                    child: Text(
                      rangeLabel,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ),
                ),
              ),
              IconButton(
                tooltip: isWeek ? 'Sonraki hafta' : 'Sonraki gün',
                onPressed: _next,
                icon: const Icon(Icons.chevron_right),
              ),
              TextButton(onPressed: _goToday, child: const Text('Bugün')),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: _LegendBar(),
        ),
        const SizedBox(height: 6),
        Expanded(
          child: FutureBuilder<List<CourtSlot>>(
            future: isWeek
                ? service.getSlotsForWeek(_weekMonday)
                : service.getSlotsForDay(_selectedDay),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              final slots = snapshot.data ?? [];
              if (slots.isEmpty) {
                return const Center(child: Text('Kort bulunamadı'));
              }

              return RefreshIndicator(
                onRefresh: _refresh,
                child: isWeek
                    ? _WeekCourtGrid(slots: slots, onSlotTap: _onSlotTap)
                    : _DayCourtGrid(slots: slots, onSlotTap: _onSlotTap),
              );
            },
          ),
        ),
      ],
    );
  }

  Future<void> _onSlotTap(CourtSlot slot) async {
    if (widget.role == UserRole.admin && slot.status == SlotStatus.available) {
      final result = await showDialog<bool>(
        context: context,
        builder: (_) => BlockCourtDialog(
          courtId: slot.courtId,
          courtName: slot.courtName,
          startTime: slot.startTime,
          endTime: slot.endTime,
          adminId: widget.userId,
        ),
      );
      if (result == true) _refresh();
    } else if (widget.role == UserRole.admin && slot.status == SlotStatus.blocked) {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Kilidi Kaldır'),
          content: Text('${slot.courtName} - ${AppDateFormat.time(slot.startTime)} kilidi kaldırılsın mı?'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('İptal')),
            FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Kaldır')),
          ],
        ),
      );
      if (confirm == true && slot.referenceId != null) {
        await ref.read(databaseProvider).deleteCourtBlock(slot.referenceId!);
        _refresh();
      }
    } else if (widget.role == UserRole.athlete && slot.status == SlotStatus.available) {
      final result = await showDialog<bool>(
        context: context,
        builder: (_) => RentCourtDialog(
          courtId: slot.courtId,
          courtName: slot.courtName,
          startTime: slot.startTime,
          endTime: slot.endTime,
          athleteId: widget.userId,
        ),
      );
      if (result == true) _refresh();
    }
  }
}

ScrollConfiguration _scrollConfig(BuildContext context, {required Widget child}) {
  return ScrollConfiguration(
    behavior: ScrollConfiguration.of(context).copyWith(
      dragDevices: {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.stylus,
      },
      scrollbars: true,
    ),
    child: child,
  );
}

/// Günlük: satır=saat, sütun=kort.
class _DayCourtGrid extends StatefulWidget {
  const _DayCourtGrid({required this.slots, required this.onSlotTap});

  final List<CourtSlot> slots;
  final Future<void> Function(CourtSlot slot) onSlotTap;

  @override
  State<_DayCourtGrid> createState() => _DayCourtGridState();
}

class _DayCourtGridState extends State<_DayCourtGrid> {
  static const _timeColWidth = 44.0;
  static const _minCourtColWidth = 88.0;
  static const _rowHeight = 56.0;
  static const _headerHeight = 36.0;

  final _hController = ScrollController();
  final _vController = ScrollController();

  @override
  void dispose() {
    _hController.dispose();
    _vController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final courtNames = <String>[];
    final hours = <int>[];
    final byKey = <String, CourtSlot>{};

    for (final slot in widget.slots) {
      if (!courtNames.contains(slot.courtName)) courtNames.add(slot.courtName);
      if (!hours.contains(slot.startTime.hour)) hours.add(slot.startTime.hour);
      byKey['${slot.courtName}|${slot.startTime.hour}'] = slot;
    }
    hours.sort();

    final theme = Theme.of(context);
    final courtCount = math.max(courtNames.length, 1);

    return _scrollConfig(
      context,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final available = constraints.maxWidth;
          final minTable = _timeColWidth + courtCount * _minCourtColWidth;
          final courtColWidth = available >= minTable
              ? (available - _timeColWidth) / courtCount
              : _minCourtColWidth;
          final contentWidth = _timeColWidth + courtCount * courtColWidth;

          return ClipRect(
            child: Scrollbar(
              controller: _hController,
              thumbVisibility: available < contentWidth - 0.5,
              notificationPredicate: (n) => n.metrics.axis == Axis.horizontal,
              child: SingleChildScrollView(
                controller: _hController,
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: contentWidth,
                  child: Scrollbar(
                    controller: _vController,
                    thumbVisibility: true,
                    child: SingleChildScrollView(
                      controller: _vController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Column(
                        children: [
                          SizedBox(
                            height: _headerHeight,
                            width: contentWidth,
                            child: Row(
                              children: [
                                SizedBox(
                                  width: _timeColWidth,
                                  child: Text(
                                    'Saat',
                                    style: theme.textTheme.labelMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                ...courtNames.map(
                                  (name) => SizedBox(
                                    width: courtColWidth,
                                    child: Text(
                                      name,
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: theme.textTheme.labelMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Divider(height: 1),
                          ...hours.map((hour) {
                            return SizedBox(
                              height: _rowHeight,
                              width: contentWidth,
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: _timeColWidth,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        '${hour.toString().padLeft(2, '0')}:00',
                                        style: theme.textTheme.bodySmall?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                  ...courtNames.map((name) {
                                    final slot = byKey['$name|$hour']!;
                                    return SizedBox(
                                      width: courtColWidth,
                                      height: _rowHeight,
                                      child: Padding(
                                        padding: const EdgeInsets.all(2),
                                        child: CourtSlotCell(
                                          slot: slot,
                                          onTap: () => widget.onSlotTap(slot),
                                        ),
                                      ),
                                    );
                                  }),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Haftalık: sütun=saat, ana satır=gün, alt satır=kort (hafif hücreler).
class _WeekCourtGrid extends StatefulWidget {
  const _WeekCourtGrid({required this.slots, required this.onSlotTap});

  final List<CourtSlot> slots;
  final Future<void> Function(CourtSlot slot) onSlotTap;

  @override
  State<_WeekCourtGrid> createState() => _WeekCourtGridState();
}

class _WeekCourtGridState extends State<_WeekCourtGrid> {
  static const _labelColWidth = 56.0;
  static const _minHourColWidth = 48.0;
  static const _courtRowHeight = 36.0;
  static const _dayHeaderHeight = 24.0;
  static const _hourHeaderHeight = 26.0;
  static const _emptyBg = Color(0xFFF5F5F5);

  final _hController = ScrollController();
  final _vController = ScrollController();

  late final List<String> _courtNames;
  late final List<DateTime> _days;
  late final Map<String, CourtSlot> _byKey;
  late final List<int> _hours;

  @override
  void initState() {
    super.initState();
    _indexSlots();
  }

  @override
  void didUpdateWidget(covariant _WeekCourtGrid oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.slots, widget.slots)) {
      _indexSlots();
    }
  }

  void _indexSlots() {
    final courtNames = <String>[];
    final days = <DateTime>[];
    final byKey = <String, CourtSlot>{};

    for (final slot in widget.slots) {
      if (!courtNames.contains(slot.courtName)) courtNames.add(slot.courtName);
      final day = DateTime(slot.startTime.year, slot.startTime.month, slot.startTime.day);
      if (!days.any((d) => d.isAtSameMomentAs(day))) days.add(day);
      byKey['${day.year}-${day.month}-${day.day}|${slot.courtName}|${slot.startTime.hour}'] =
          slot;
    }
    days.sort();
    _courtNames = courtNames;
    _days = days;
    _byKey = byKey;
    _hours = List.generate(
      AppConstants.calendarEndHour - AppConstants.calendarStartHour,
      (i) => AppConstants.calendarStartHour + i,
    );
  }

  @override
  void dispose() {
    _hController.dispose();
    _vController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hourCount = _hours.length;

    return _scrollConfig(
      context,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final available = constraints.maxWidth;
          final minTable = _labelColWidth + hourCount * _minHourColWidth;
          final hourColWidth = available >= minTable
              ? (available - _labelColWidth) / hourCount
              : _minHourColWidth;
          final contentWidth = _labelColWidth + hourCount * hourColWidth;

          return ClipRect(
            child: SingleChildScrollView(
              controller: _hController,
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: contentWidth,
                child: CustomScrollView(
                  controller: _vController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: _hourHeaderHeight,
                        width: contentWidth,
                        child: Row(
                          children: [
                            SizedBox(
                              width: _labelColWidth,
                              child: Text(
                                'Kort',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            ..._hours.map(
                              (h) => SizedBox(
                                width: hourColWidth,
                                child: Text(
                                  h.toString().padLeft(2, '0'),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(child: Divider(height: 1)),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, dayIndex) {
                          final day = _days[dayIndex];
                          return RepaintBoundary(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  height: _dayHeaderHeight,
                                  width: contentWidth,
                                  child: ColoredBox(
                                    color: AppColors.navy.withValues(alpha: 0.08),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 6),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          '${['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'][day.weekday - 1]} '
                                          '${day.day}',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: theme.textTheme.labelMedium?.copyWith(
                                            fontWeight: FontWeight.w800,
                                            color: AppColors.navy,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                ..._courtNames.map((courtName) {
                                  return SizedBox(
                                    height: _courtRowHeight,
                                    width: contentWidth,
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: _labelColWidth,
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 4),
                                            child: Text(
                                              courtName.replaceFirst('Kort ', 'K'),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: theme.textTheme.labelSmall?.copyWith(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 10,
                                              ),
                                            ),
                                          ),
                                        ),
                                        ..._hours.map((hour) {
                                          final slot = _byKey[
                                              '${day.year}-${day.month}-${day.day}|$courtName|$hour'];
                                          return SizedBox(
                                            width: hourColWidth,
                                            height: _courtRowHeight,
                                            child: Padding(
                                              padding: const EdgeInsets.all(1),
                                              child: slot == null
                                                  ? const ColoredBox(color: _emptyBg)
                                                  : WeekSlotCell(
                                                      slot: slot,
                                                      onTap: () => widget.onSlotTap(slot),
                                                    ),
                                            ),
                                          );
                                        }),
                                      ],
                                    ),
                                  );
                                }),
                              ],
                            ),
                          );
                        },
                        childCount: _days.length,
                        addAutomaticKeepAlives: false,
                        addRepaintBoundaries: false,
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 12)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _LegendBar extends StatelessWidget {
  const _LegendBar();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 4,
      children: [
        _LegendItem(color: Colors.green.shade100, label: 'Boş'),
        _LegendItem(color: Colors.orange.shade100, label: 'Kiralama'),
        _LegendItem(color: Colors.red.shade100, label: 'Kilitli'),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 22,
              height: 16,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF90CAF9),
                      borderRadius: BorderRadius.circular(3),
                      border: Border.all(color: const Color(0xFF0D47A1), width: 2.5),
                    ),
                  ),
                  const Positioned(
                    top: 0,
                    left: 2,
                    child: Text('G', style: TextStyle(fontSize: 6, fontWeight: FontWeight.w900)),
                  ),
                  const Center(
                    child: Text('Ç15', style: TextStyle(fontSize: 7, fontWeight: FontWeight.w900)),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 4),
            const Text('Grup = Ç15 + G', style: TextStyle(fontSize: 11)),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 22,
              height: 14,
              decoration: BoxDecoration(
                color: const Color(0xFF90CAF9),
                borderRadius: BorderRadius.circular(3),
                border: Border.all(color: const Color(0xFF1565C0)),
              ),
              alignment: Alignment.center,
              child: const Text('EK', style: TextStyle(fontSize: 7, fontWeight: FontWeight.w800)),
            ),
            const SizedBox(width: 4),
            const Text('Özel = baş harf', style: TextStyle(fontSize: 11)),
          ],
        ),
        Text('Renk = antrenör', style: TextStyle(fontSize: 11, color: Colors.grey.shade700)),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3)),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 11)),
      ],
    );
  }
}
