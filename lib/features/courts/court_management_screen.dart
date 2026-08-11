import 'dart:math' as math;

import 'package:crm_app/core/database/app_database.dart';
import 'package:crm_app/core/constants/app_constants.dart';
import 'package:crm_app/core/enums/user_role.dart';
import 'package:crm_app/core/providers/database_provider.dart';
import 'package:crm_app/core/services/court_availability_service.dart';
import 'package:crm_app/core/theme/app_theme.dart';
import 'package:crm_app/core/utils/app_date_format.dart';
import 'package:crm_app/features/courts/widgets/add_test_credits_dialog.dart';
import 'package:crm_app/features/courts/widgets/block_court_dialog.dart';
import 'package:crm_app/features/courts/widgets/court_slot_cell.dart';
import 'package:crm_app/features/courts/widgets/rent_court_dialog.dart';
import 'package:crm_app/features/courts/widgets/week_slot_cell.dart';
import 'package:crm_app/core/widgets/schedule_rental_slot.dart';
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
  late Set<String> _expandedBlocks;

  @override
  void initState() {
    super.initState();
    _expandedBlocks = {
      for (final b in AppConstants.calendarTimeBlocks)
        if (b.courtExpandedByDefault) b.id,
    };
  }

  void _toggleBlock(String id) {
    setState(() {
      if (_expandedBlocks.contains(id)) {
        _expandedBlocks.remove(id);
      } else {
        _expandedBlocks.add(id);
      }
    });
  }

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
        if (widget.role == UserRole.athlete) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 4),
            child: _MemberCreditBar(userId: widget.userId),
          ),
        ],
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
                    ? _WeekCourtGrid(
                        slots: slots,
                        onSlotTap: _onSlotTap,
                        expandedBlocks: _expandedBlocks,
                        onToggleBlock: _toggleBlock,
                      )
                    : _DayCourtGrid(
                        slots: slots,
                        onSlotTap: _onSlotTap,
                        expandedBlocks: _expandedBlocks,
                        onToggleBlock: _toggleBlock,
                      ),
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
      if (!slot.startTime.isAfter(DateTime.now())) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Geçmiş saat için kiralama yapılamaz')),
          );
        }
        return;
      }
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

/// İki scroll görünümünü senkron tutar (sticky eksenler için).
class _ScrollPair {
  _ScrollPair() {
    a.addListener(_fromA);
    b.addListener(_fromB);
  }

  final ScrollController a = ScrollController();
  final ScrollController b = ScrollController();
  bool _locking = false;

  void _fromA() => _sync(a, b);
  void _fromB() => _sync(b, a);

  void _sync(ScrollController from, ScrollController to) {
    if (_locking || !from.hasClients || !to.hasClients) return;
    final target = from.offset.clamp(0.0, to.position.maxScrollExtent);
    if ((to.offset - target).abs() < 0.5) return;
    _locking = true;
    to.jumpTo(target);
    _locking = false;
  }

  void dispose() {
    a.removeListener(_fromA);
    b.removeListener(_fromB);
    a.dispose();
    b.dispose();
  }
}

/// Günlük: satır=saat, sütun=kort. Blok başlıkları tam genişlik.
class _DayCourtGrid extends StatefulWidget {
  const _DayCourtGrid({
    required this.slots,
    required this.onSlotTap,
    required this.expandedBlocks,
    required this.onToggleBlock,
  });

  final List<CourtSlot> slots;
  final Future<void> Function(CourtSlot slot) onSlotTap;
  final Set<String> expandedBlocks;
  final void Function(String blockId) onToggleBlock;

  @override
  State<_DayCourtGrid> createState() => _DayCourtGridState();
}

class _DayCourtGridState extends State<_DayCourtGrid> {
  static const _timeColWidth = 48.0;
  static const _minCourtColWidth = 88.0;
  static const _rowHeight = 56.0;
  static const _headerHeight = 40.0;
  static const _blockHeaderHeight = 34.0;

  final _h = _ScrollPair();
  final _v = _ScrollPair();

  @override
  void dispose() {
    _h.dispose();
    _v.dispose();
    super.dispose();
  }

  int _busyCountInBlock(CalendarTimeBlock block, Map<String, CourtSlot> byKey, List<String> courts) {
    var count = 0;
    for (final hour in block.hours) {
      for (final court in courts) {
        final slot = byKey['$court|$hour'];
        if (slot != null && slot.status != SlotStatus.available) count++;
      }
    }
    return count;
  }

  @override
  Widget build(BuildContext context) {
    final courtNames = <String>[];
    final hourSet = <int>{};
    final byKey = <String, CourtSlot>{};

    for (final slot in widget.slots) {
      if (!courtNames.contains(slot.courtName)) courtNames.add(slot.courtName);
      hourSet.add(slot.startTime.hour);
      byKey['${slot.courtName}|${slot.startTime.hour}'] = slot;
    }

    final theme = Theme.of(context);
    final courtCount = math.max(courtNames.length, 1);
    final headerStyle = theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold);
    final timeStyle = theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600);

    return _scrollConfig(
      context,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final available = math.max(constraints.maxWidth - _timeColWidth, 0.0);
          final courtColWidth = available >= courtCount * _minCourtColWidth
              ? available / courtCount
              : _minCourtColWidth;
          final bodyWidth = courtCount * courtColWidth;

          var bodyHeight = 12.0;
          for (final block in AppConstants.calendarTimeBlocks) {
            bodyHeight += _blockHeaderHeight;
            if (widget.expandedBlocks.contains(block.id)) {
              bodyHeight += block.hours.where(hourSet.contains).length * _rowHeight;
            }
          }

          Widget leftBody() {
            return Column(
              children: [
                for (final block in AppConstants.calendarTimeBlocks) ...[
                  SizedBox(
                    height: _blockHeaderHeight,
                    width: _timeColWidth,
                    child: Material(
                      color: widget.expandedBlocks.contains(block.id)
                          ? Colors.grey.shade200
                          : const Color(0xFFEEF1EF),
                      child: InkWell(
                        onTap: () => widget.onToggleBlock(block.id),
                        child: Icon(
                          widget.expandedBlocks.contains(block.id)
                              ? Icons.expand_more
                              : Icons.chevron_right,
                          size: 18,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                  if (widget.expandedBlocks.contains(block.id))
                    for (final hour in block.hours.where(hourSet.contains))
                      SizedBox(
                        height: _rowHeight,
                        width: _timeColWidth,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: Text(
                              '${hour.toString().padLeft(2, '0')}:00',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: timeStyle,
                            ),
                          ),
                        ),
                      ),
                ],
                const SizedBox(height: 12),
              ],
            );
          }

          Widget rightBody() {
            return Column(
              children: [
                for (final block in AppConstants.calendarTimeBlocks) ...[
                  SizedBox(
                    height: _blockHeaderHeight,
                    width: bodyWidth,
                    child: _CourtBlockHeader(
                      block: block,
                      expanded: widget.expandedBlocks.contains(block.id),
                      hiddenCount: widget.expandedBlocks.contains(block.id)
                          ? 0
                          : _busyCountInBlock(block, byKey, courtNames),
                      onTap: () => widget.onToggleBlock(block.id),
                    ),
                  ),
                  if (widget.expandedBlocks.contains(block.id))
                    for (final hour in block.hours.where(hourSet.contains))
                      SizedBox(
                        height: _rowHeight,
                        width: bodyWidth,
                        child: Row(
                          children: [
                            for (final name in courtNames)
                              SizedBox(
                                width: courtColWidth,
                                height: _rowHeight,
                                child: Padding(
                                  padding: const EdgeInsets.all(2),
                                  child: CourtSlotCell(
                                    slot: byKey['$name|$hour']!,
                                    onTap: () => widget.onSlotTap(byKey['$name|$hour']!),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                ],
                const SizedBox(height: 12),
              ],
            );
          }

          return Column(
            children: [
              SizedBox(
                height: _headerHeight,
                child: Row(
                  children: [
                    SizedBox(
                      width: _timeColWidth,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Text('Saat', style: headerStyle),
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        controller: _h.a,
                        scrollDirection: Axis.horizontal,
                        child: SizedBox(
                          width: bodyWidth,
                          height: _headerHeight,
                          child: ColoredBox(
                            color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
                            child: Row(
                              children: [
                                for (final name in courtNames)
                                  SizedBox(
                                    width: courtColWidth,
                                    child: Center(
                                      child: Text(
                                        name,
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: headerStyle,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: _timeColWidth,
                      child: ScrollConfiguration(
                        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                        child: SingleChildScrollView(
                          controller: _v.a,
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: SizedBox(
                            width: _timeColWidth,
                            height: bodyHeight,
                            child: leftBody(),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Scrollbar(
                        controller: _h.b,
                        thumbVisibility: bodyWidth > available + 0.5,
                        notificationPredicate: (n) => n.metrics.axis == Axis.horizontal,
                        child: SingleChildScrollView(
                          controller: _h.b,
                          scrollDirection: Axis.horizontal,
                          child: SizedBox(
                            width: bodyWidth,
                            child: Scrollbar(
                              controller: _v.b,
                              thumbVisibility: true,
                              child: SingleChildScrollView(
                                controller: _v.b,
                                physics: const AlwaysScrollableScrollPhysics(),
                                child: SizedBox(
                                  width: bodyWidth,
                                  height: bodyHeight,
                                  child: rightBody(),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _WeekCol {
  const _WeekCol.hour(this.hour)
      : blocks = const [],
        isCollapsedBlock = false;
  const _WeekCol.collapsedBundle(this.blocks)
      : hour = null,
        isCollapsedBlock = true;

  final int? hour;
  final List<CalendarTimeBlock> blocks;
  final bool isCollapsedBlock;
}

/// Haftalık: saatler sütun. Gizli blok = dar sütun, açık blok = saat sütunları.
class _WeekCourtGrid extends StatefulWidget {
  const _WeekCourtGrid({
    required this.slots,
    required this.onSlotTap,
    required this.expandedBlocks,
    required this.onToggleBlock,
  });

  final List<CourtSlot> slots;
  final Future<void> Function(CourtSlot slot) onSlotTap;
  final Set<String> expandedBlocks;
  final void Function(String blockId) onToggleBlock;

  @override
  State<_WeekCourtGrid> createState() => _WeekCourtGridState();
}

class _WeekCourtGridState extends State<_WeekCourtGrid> {
  static const _labelColWidth = 64.0;
  static const _minHourColWidth = 44.0;
  /// Tüm gizli bloklar tek dar şeritte birleşir.
  static const _collapsedColWidth = 18.0;
  static const _courtRowHeight = 36.0;
  static const _dayHeaderHeight = 24.0;
  static const _hourHeaderHeight = 40.0;
  static const _emptyBg = Color(0xFFF5F5F5);
  static const _collapsedBg = Color(0xFFEEF1EF);
  static const _collapsedFg = Color(0xFF5A6B60);
  static const _dayNames = ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];

  final _h = _ScrollPair();
  final _v = _ScrollPair();

  late List<String> _courtNames;
  late List<DateTime> _days;
  late Map<String, CourtSlot> _byKey;

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
  }

  @override
  void dispose() {
    _h.dispose();
    _v.dispose();
    super.dispose();
  }

  List<_WeekCol> _buildColumns() {
    final cols = <_WeekCol>[];
    final collapsed = <CalendarTimeBlock>[];

    void flushCollapsed() {
      if (collapsed.isEmpty) return;
      cols.add(_WeekCol.collapsedBundle(List<CalendarTimeBlock>.of(collapsed)));
      collapsed.clear();
    }

    for (final block in AppConstants.calendarTimeBlocks) {
      if (widget.expandedBlocks.contains(block.id)) {
        flushCollapsed();
        for (final hour in block.hours) {
          cols.add(_WeekCol.hour(hour));
        }
      } else {
        collapsed.add(block);
      }
    }
    flushCollapsed();
    return cols;
  }

  int _busyCountInBlock(CalendarTimeBlock block) {
    var count = 0;
    for (final day in _days) {
      for (final court in _courtNames) {
        for (final hour in block.hours) {
          final slot = _byKey['${day.year}-${day.month}-${day.day}|$court|$hour'];
          if (slot != null && slot.status != SlotStatus.available) count++;
        }
      }
    }
    return count;
  }

  Future<void> _pickCollapsedBlock(
    BuildContext context,
    List<CalendarTimeBlock> blocks,
  ) async {
    if (blocks.isEmpty) return;
    if (blocks.length == 1) {
      widget.onToggleBlock(blocks.first.id);
      return;
    }
    final chosen = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Hangi bloğu açmak istersin?',
                    style: Theme.of(ctx).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
              ),
              for (final b in blocks)
                ListTile(
                  leading: const Icon(Icons.unfold_more),
                  title: Text(b.label),
                  subtitle: Text(b.rangeLabel),
                  trailing: Text('${_busyCountInBlock(b)} dolu'),
                  onTap: () => Navigator.pop(ctx, b.id),
                ),
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Vazgeç'),
              ),
            ],
          ),
        );
      },
    );
    if (chosen != null) widget.onToggleBlock(chosen);
  }

  double _colWidth(_WeekCol col, double hourColWidth) =>
      col.isCollapsedBlock ? _collapsedColWidth : hourColWidth;

  double get _leftBodyHeight =>
      _days.length * (_dayHeaderHeight + _courtNames.length * _courtRowHeight) + 12;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cols = _buildColumns();

    return _scrollConfig(
      context,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final available = math.max(constraints.maxWidth - _labelColWidth, 0.0);
          final hourColCount = cols.where((c) => !c.isCollapsedBlock).length;
          final collapsedWidth =
              cols.where((c) => c.isCollapsedBlock).length * _collapsedColWidth;
          final hourBudget = math.max(available - collapsedWidth, 0.0);
          final hourColWidth = hourColCount == 0
              ? _minHourColWidth
              : (hourBudget >= hourColCount * _minHourColWidth
                  ? hourBudget / hourColCount
                  : _minHourColWidth);

          var bodyWidth = 0.0;
          for (final c in cols) {
            bodyWidth += _colWidth(c, hourColWidth);
          }
          bodyWidth = math.max(bodyWidth, available);

          Widget headerCell(_WeekCol col) {
            final w = _colWidth(col, hourColWidth);
            if (col.isCollapsedBlock) {
              final blocks = col.blocks;
              final busy = blocks.fold<int>(0, (sum, b) => sum + _busyCountInBlock(b));
              return SizedBox(
                width: w,
                height: _hourHeaderHeight,
                child: Tooltip(
                  message: '${blocks.map((b) => b.label).join(' · ')} — dokunarak aç',
                  child: Material(
                    color: _collapsedBg,
                    child: InkWell(
                      onTap: () => _pickCollapsedBlock(context, blocks),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.chevron_right, size: 14, color: _collapsedFg),
                          if (busy > 0)
                            Text(
                              '$busy',
                              style: const TextStyle(
                                fontSize: 8,
                                fontWeight: FontWeight.w700,
                                color: _collapsedFg,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
            return SizedBox(
              width: w,
              height: _hourHeaderHeight,
              child: Center(
                child: Text(
                  col.hour!.toString().padLeft(2, '0'),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                ),
              ),
            );
          }

          Widget bodyCell(_WeekCol col, DateTime day, String courtName) {
            final w = _colWidth(col, hourColWidth);
            if (col.isCollapsedBlock) {
              return SizedBox(
                width: w,
                height: _courtRowHeight,
                child: Material(
                  color: _collapsedBg,
                  child: InkWell(
                    onTap: () => _pickCollapsedBlock(context, col.blocks),
                    child: const Center(
                      child: Icon(Icons.more_vert, size: 12, color: _collapsedFg),
                    ),
                  ),
                ),
              );
            }
            final slot = _byKey['${day.year}-${day.month}-${day.day}|$courtName|${col.hour}'];
            return SizedBox(
              width: w,
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
          }

          // Blok şeridi + saat başlıkları aynı yatay scroll içinde (tek controller).
          Widget topHeaders() {
            return SizedBox(
              height: 28 + _hourHeaderHeight,
              child: Row(
                children: [
                  SizedBox(
                    width: _labelColWidth,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 28,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 6),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Blok',
                                style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: _hourHeaderHeight,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 6),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Gün/Kort',
                                style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: _h.a,
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        width: bodyWidth,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 28,
                              child: Row(
                                children: [
                                  for (final block in AppConstants.calendarTimeBlocks)
                                    Builder(
                                      builder: (_) {
                                        final expanded = widget.expandedBlocks.contains(block.id);
                                        // Gizli bloklar tek dar şeritte birleşir: yalnızca ilk gizliye genişlik ver.
                                        final collapsedBlocks = AppConstants.calendarTimeBlocks
                                            .where((b) => !widget.expandedBlocks.contains(b.id))
                                            .toList();
                                        final isFirstCollapsed = !expanded &&
                                            collapsedBlocks.isNotEmpty &&
                                            collapsedBlocks.first.id == block.id;
                                        if (!expanded && !isFirstCollapsed) {
                                          return const SizedBox.shrink();
                                        }
                                        final w = expanded
                                            ? block.hours.length * hourColWidth
                                            : _collapsedColWidth;
                                        return SizedBox(
                                          width: w,
                                          height: 28,
                                          child: Material(
                                            color: expanded
                                                ? Colors.grey.shade200
                                                : _collapsedBg,
                                            child: InkWell(
                                              onTap: expanded
                                                  ? () => widget.onToggleBlock(block.id)
                                                  : () => _pickCollapsedBlock(
                                                        context,
                                                        collapsedBlocks,
                                                      ),
                                              child: Center(
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 2),
                                                  child: Text(
                                                    expanded
                                                        ? '${block.label} · Gizle'
                                                        : '${collapsedBlocks.map((b) => b.label[0]).join('')} ›',
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      fontWeight: FontWeight.w700,
                                                      color: expanded
                                                          ? theme.colorScheme.onSurface
                                                          : _collapsedFg,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: _hourHeaderHeight,
                              child: ColoredBox(
                                color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
                                child: Row(
                                  children: [for (final col in cols) headerCell(col)],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              topHeaders(),
              const Divider(height: 1),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: _labelColWidth,
                      child: ScrollConfiguration(
                        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                        child: SingleChildScrollView(
                          controller: _v.a,
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: SizedBox(
                            width: _labelColWidth,
                            height: _leftBodyHeight,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                for (final day in _days) ...[
                                  SizedBox(
                                    height: _dayHeaderHeight,
                                    child: ColoredBox(
                                      color: AppColors.navy.withValues(alpha: 0.08),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 6),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            '${_dayNames[day.weekday - 1]} ${day.day}',
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
                                  for (final courtName in _courtNames)
                                    SizedBox(
                                      height: _courtRowHeight,
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 6),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
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
                                    ),
                                ],
                                const SizedBox(height: 12),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Scrollbar(
                        controller: _h.b,
                        thumbVisibility: bodyWidth > available + 0.5,
                        notificationPredicate: (n) => n.metrics.axis == Axis.horizontal,
                        child: SingleChildScrollView(
                          controller: _h.b,
                          scrollDirection: Axis.horizontal,
                          child: SizedBox(
                            width: bodyWidth,
                            child: Scrollbar(
                              controller: _v.b,
                              thumbVisibility: true,
                              child: SingleChildScrollView(
                                controller: _v.b,
                                physics: const AlwaysScrollableScrollPhysics(),
                                child: SizedBox(
                                  width: bodyWidth,
                                  height: _leftBodyHeight,
                                  child: Column(
                                    children: [
                                      for (final day in _days) ...[
                                        SizedBox(
                                          height: _dayHeaderHeight,
                                          width: bodyWidth,
                                          child: ColoredBox(
                                            color: AppColors.navy.withValues(alpha: 0.05),
                                          ),
                                        ),
                                        for (final courtName in _courtNames)
                                          SizedBox(
                                            height: _courtRowHeight,
                                            width: bodyWidth,
                                            child: Row(
                                              children: [
                                                for (final col in cols)
                                                  bodyCell(col, day, courtName),
                                              ],
                                            ),
                                          ),
                                      ],
                                      const SizedBox(height: 12),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _CourtBlockHeader extends StatelessWidget {
  const _CourtBlockHeader({
    required this.block,
    required this.expanded,
    required this.hiddenCount,
    required this.onTap,
  });

  final CalendarTimeBlock block;
  final bool expanded;
  final int hiddenCount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: expanded ? Colors.grey.shade200 : const Color(0xFFEEF1EF),
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: 34,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                Icon(
                  expanded ? Icons.expand_more : Icons.chevron_right,
                  size: 18,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 4),
                Flexible(
                  flex: 2,
                  child: Text(
                    block.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(width: 4),
                Flexible(
                  flex: 3,
                  child: Text(
                    block.rangeLabel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                if (!expanded && hiddenCount > 0) ...[
                  const SizedBox(width: 4),
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '$hiddenCount dolu',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
                const SizedBox(width: 6),
                Text(
                  expanded ? 'Gizle' : 'Göster',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MemberCreditBar extends ConsumerWidget {
  const _MemberCreditBar({required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(databaseProvider);

    return StreamBuilder<User?>(
      stream: db.watchUserById(userId),
      builder: (context, snapshot) {
        final balance = snapshot.data?.creditBalance ?? ref.watch(authProvider).user?.creditBalance ?? 0;
        return Card(
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Icon(Icons.account_balance_wallet_outlined, color: AppColors.limeDark, size: 22),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${balance.toInt()} kredi',
                        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                      ),
                      Text(
                        '1 saat = ${AppConstants.courtRentalCreditCost.toInt()} kredi',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey.shade700,
                            ),
                      ),
                    ],
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () async {
                    final newBalance = await showDialog<double>(
                      context: context,
                      builder: (_) => const AddTestCreditsDialog(),
                    );
                    if (newBalance != null && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Bakiye: ${newBalance.toInt()} kredi')),
                      );
                    }
                  },
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Test Kredi'),
                  style: OutlinedButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                  ),
                ),
              ],
            ),
          ),
        );
      },
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
        _LegendItem(color: const Color(0xFFFFF3E8), label: 'Kiralama = isim'),
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
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 22,
              height: 14,
              decoration: BoxDecoration(
                color: RentalSlotColors.fill,
                borderRadius: BorderRadius.circular(3),
                border: Border.all(color: RentalSlotColors.border),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: RentalSlotColors.fill,
                      borderRadius: BorderRadius.circular(3),
                      border: Border.all(color: RentalSlotColors.border),
                    ),
                  ),
                  const Center(
                    child: Text('Can', style: TextStyle(fontSize: 7, fontWeight: FontWeight.w800)),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(width: 3, color: RentalSlotColors.rail),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 4),
            const Text('Kiralama = sağ şerit', style: TextStyle(fontSize: 11)),
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
