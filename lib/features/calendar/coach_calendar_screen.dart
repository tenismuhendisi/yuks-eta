import 'package:crm_app/core/utils/app_date_format.dart';
import 'package:crm_app/core/constants/app_constants.dart';
import 'package:crm_app/core/database/app_database.dart';
import 'package:crm_app/core/enums/lesson_type.dart';
import 'package:crm_app/core/providers/database_provider.dart';
import 'package:crm_app/core/services/court_availability_service.dart';
import 'package:crm_app/features/calendar/widgets/lesson_form_dialog.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart' hide Table, TableRow;
import 'package:flutter/material.dart' as material show Table, TableRow;
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CoachCalendarScreen extends ConsumerStatefulWidget {
  const CoachCalendarScreen({super.key, required this.coachId});

  final String coachId;

  @override
  ConsumerState<CoachCalendarScreen> createState() => _CoachCalendarScreenState();
}

class _CoachCalendarScreenState extends ConsumerState<CoachCalendarScreen> {
  DateTime _weekStart = _startOfWeek(DateTime.now());
  bool _showTemplates = false;

  static DateTime _startOfWeek(DateTime date) {
    final d = DateTime(date.year, date.month, date.day);
    return d.subtract(Duration(days: d.weekday - 1));
  }

  List<DateTime> get _weekDays =>
      List.generate(7, (i) => _weekStart.add(Duration(days: i)));

  List<int> get _hours => List.generate(
        AppConstants.calendarEndHour - AppConstants.calendarStartHour,
        (i) => AppConstants.calendarStartHour + i,
      );

  void _prevWeek() => setState(() => _weekStart = _weekStart.subtract(const Duration(days: 7)));
  void _nextWeek() => setState(() => _weekStart = _weekStart.add(const Duration(days: 7)));
  void _goToday() => setState(() => _weekStart = _startOfWeek(DateTime.now()));

  Future<void> _onCellTap(DateTime day, int hour) async {
    final start = DateTime(day.year, day.month, day.day, hour);
    final end = start.add(const Duration(hours: 1));
    await showDialog<bool>(
      context: context,
      builder: (_) => LessonFormDialog(
        coachId: widget.coachId,
        initialStart: start,
        initialEnd: end,
        isTemplate: _showTemplates,
      ),
    );
    setState(() {});
  }

  Future<void> _onLessonDrop(Lesson lesson, DateTime newStart) async {
    final duration = lesson.endTime.difference(lesson.startTime);
    final newEnd = newStart.add(duration);

    if (!lesson.isTemplate && lesson.courtId != null) {
      final service = ref.read(courtAvailabilityServiceProvider);
      final available = await service.isCourtAvailable(
        lesson.courtId!,
        newStart,
        newEnd,
        excludeLessonId: lesson.id,
      );
      if (!available) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Kort bu saatte müsait değil')),
          );
        }
        return;
      }
    }

    await ref.read(databaseProvider).updateLesson(
          lesson.id,
          LessonsCompanion(
            startTime: Value(newStart),
            endTime: Value(newEnd),
          ),
        );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final db = ref.watch(databaseProvider);
    final weekLabel = AppDateFormat.weekRange(_weekDays.first, _weekDays.last);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            children: [
              IconButton(onPressed: _prevWeek, icon: const Icon(Icons.chevron_left)),
              Expanded(
                child: Text(
                  weekLabel,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              IconButton(onPressed: _nextWeek, icon: const Icon(Icons.chevron_right)),
              TextButton(onPressed: _goToday, child: const Text('Bugün')),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              FilterChip(
                label: const Text('Gerçek Dersler'),
                selected: !_showTemplates,
                onSelected: (_) => setState(() => _showTemplates = false),
              ),
              const SizedBox(width: 8),
              FilterChip(
                label: const Text('Şablon Dersler'),
                selected: _showTemplates,
                onSelected: (_) => setState(() => _showTemplates = true),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: FutureBuilder<List<Lesson>>(
            future: db.getLessonsForCoachInRange(
              widget.coachId,
              _weekDays.first,
              _weekDays.last.add(const Duration(days: 1)),
            ),
            builder: (context, snapshot) {
              final allLessons = snapshot.data ?? [];
              final lessons = allLessons.where((l) => l.isTemplate == _showTemplates).toList();

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  child: _CalendarGrid(
                    weekDays: _weekDays,
                    hours: _hours,
                    lessons: lessons,
                    onCellTap: _onCellTap,
                    onLessonDrop: _onLessonDrop,
                    onLessonTap: (lesson) async {
                      await showDialog<bool>(
                        context: context,
                        builder: (_) => LessonFormDialog(
                          coachId: widget.coachId,
                          existingLesson: lesson,
                        ),
                      );
                      setState(() {});
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _CalendarGrid extends StatelessWidget {
  const _CalendarGrid({
    required this.weekDays,
    required this.hours,
    required this.lessons,
    required this.onCellTap,
    required this.onLessonDrop,
    required this.onLessonTap,
  });

  final List<DateTime> weekDays;
  final List<int> hours;
  final List<Lesson> lessons;
  final void Function(DateTime day, int hour) onCellTap;
  final Future<void> Function(Lesson lesson, DateTime newStart) onLessonDrop;
  final void Function(Lesson lesson) onLessonTap;

  static const _cellWidth = 120.0;
  static const _cellHeight = 56.0;
  static const _timeWidth = 56.0;

  Lesson? _lessonAt(DateTime day, int hour) {
    final slotStart = DateTime(day.year, day.month, day.day, hour);
    final slotEnd = slotStart.add(const Duration(hours: 1));
    return lessons.where((l) =>
        l.startTime.isBefore(slotEnd) && l.endTime.isAfter(slotStart)).firstOrNull;
  }

  @override
  Widget build(BuildContext context) {
    return material.Table(
      defaultColumnWidth: const FixedColumnWidth(_cellWidth),
      border: TableBorder.all(color: Colors.grey.shade300),
      children: [
        material.TableRow(
          decoration: BoxDecoration(color: Colors.grey.shade100),
          children: [
            const SizedBox(width: _timeWidth, height: 36),
            ...weekDays.map((d) => SizedBox(
                  height: 36,
                  child: Center(
                    child: Text(
                      AppDateFormat.dayHeader(d),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                    ),
                  ),
                )),
          ],
        ),
        ...hours.map((hour) {
          return material.TableRow(
            children: [
              SizedBox(
                width: _timeWidth,
                height: _cellHeight,
                child: Center(
                  child: Text(
                    '${hour.toString().padLeft(2, '0')}:00',
                    style: const TextStyle(fontSize: 11),
                  ),
                ),
              ),
              ...weekDays.map((day) {
                final lesson = _lessonAt(day, hour);
                if (lesson != null && lesson.startTime.hour == hour) {
                  return _LessonCell(
                    lesson: lesson,
                    onTap: () => onLessonTap(lesson),
                  );
                }
                if (lesson != null) {
                  return const SizedBox(height: _cellHeight);
                }
                return _EmptyCell(
                  onTap: () => onCellTap(day, hour),
                  onAccept: (data) {
                    if (data is Lesson) {
                      onLessonDrop(data, DateTime(day.year, day.month, day.day, hour));
                    }
                  },
                );
              }),
            ],
          );
        }),
      ],
    );
  }
}

class _EmptyCell extends StatelessWidget {
  const _EmptyCell({required this.onTap, required this.onAccept});

  final VoidCallback onTap;
  final void Function(Object? data) onAccept;

  @override
  Widget build(BuildContext context) {
    return DragTarget<Object>(
      onAcceptWithDetails: (d) => onAccept(d.data),
      builder: (context, candidate, rejected) {
        return InkWell(
          onTap: onTap,
          child: Container(
            height: _CalendarGrid._cellHeight,
            color: candidate.isNotEmpty ? Colors.green.shade50 : null,
            child: candidate.isNotEmpty
                ? const Center(child: Icon(Icons.add, size: 16, color: Colors.green))
                : null,
          ),
        );
      },
    );
  }
}

class _LessonCell extends StatelessWidget {
  const _LessonCell({
    required this.lesson,
    required this.onTap,
  });

  final Lesson lesson;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final type = LessonType.fromString(lesson.type);
    final color = lesson.isTemplate
        ? Colors.purple.shade100
        : type == LessonType.private
            ? Colors.blue.shade200
            : Colors.teal.shade200;

    return Draggable<Lesson>(
      data: lesson,
      feedback: Material(
        elevation: 4,
        child: Container(
          width: _CalendarGrid._cellWidth,
          padding: const EdgeInsets.all(4),
          color: color,
          child: Text(
            lesson.title ?? type.label,
            style: const TextStyle(fontSize: 11),
          ),
        ),
      ),
      childWhenDragging: Container(
        height: _CalendarGrid._cellHeight,
        color: Colors.grey.shade200,
      ),
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: _CalendarGrid._cellHeight,
          padding: const EdgeInsets.all(4),
          color: color,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                lesson.title ?? type.label,
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                '${lesson.maxParticipants} kişi',
                style: const TextStyle(fontSize: 10),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

extension _FirstOrNull<E> on Iterable<E> {
  E? get firstOrNull {
    final it = iterator;
    if (!it.moveNext()) return null;
    return it.current;
  }
}
