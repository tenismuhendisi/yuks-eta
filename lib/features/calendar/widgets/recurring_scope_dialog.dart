import 'package:crm_app/core/database/app_database.dart';
import 'package:crm_app/core/providers/database_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Tekrarlı seriye uygulanacak işlem kapsamı.
enum RecurringScope {
  thisOnly,
  allEvents,
  thisAndFollowing,
}

/// Serisi olan derste kapsam sorar; seri yoksa [RecurringScope.thisOnly] döner.
Future<RecurringScope?> resolveRecurringScope(
  BuildContext context, {
  required Lesson lesson,
  required String title,
}) async {
  final seriesId = lesson.seriesId;
  if (seriesId == null || seriesId.isEmpty) {
    return RecurringScope.thisOnly;
  }

  return showModalBottomSheet<RecurringScope>(
    context: context,
    showDragHandle: true,
    builder: (ctx) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                title,
                style: Theme.of(ctx).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                'Bu ders tekrarlanan bir serinin parçası. Değişiklik nereye uygulansın?',
                style: Theme.of(ctx).textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              ListTile(
                leading: const Icon(Icons.event),
                title: const Text('Sadece bu event'),
                onTap: () => Navigator.pop(ctx, RecurringScope.thisOnly),
              ),
              ListTile(
                leading: const Icon(Icons.event_repeat),
                title: const Text('Tüm eventler'),
                onTap: () => Navigator.pop(ctx, RecurringScope.allEvents),
              ),
              ListTile(
                leading: const Icon(Icons.event_note),
                title: const Text('Bu ve bundan sonraki eventler'),
                onTap: () => Navigator.pop(ctx, RecurringScope.thisAndFollowing),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Vazgeç'),
              ),
            ],
          ),
        ),
      );
    },
  );
}

/// Kapsama göre hedef dersleri döndürür.
Future<List<Lesson>> lessonsForScope(
  WidgetRef ref, {
  required Lesson lesson,
  required RecurringScope scope,
}) async {
  final seriesId = lesson.seriesId;
  if (seriesId == null || seriesId.isEmpty || scope == RecurringScope.thisOnly) {
    return [lesson];
  }

  final series = await ref.read(databaseProvider).getLessonsBySeriesId(seriesId);
  switch (scope) {
    case RecurringScope.thisOnly:
      return [lesson];
    case RecurringScope.allEvents:
      return series;
    case RecurringScope.thisAndFollowing:
      return series
          .where(
            (l) =>
                !l.startTime.isBefore(lesson.startTime) || l.id == lesson.id,
          )
          .toList();
  }
}
