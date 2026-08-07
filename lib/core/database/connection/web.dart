import 'package:drift/drift.dart';
import 'package:drift/web.dart';

LazyDatabase openConnection() {
  return LazyDatabase(() async {
    return WebDatabase('eta_tenis_crm_v8');
  });
}
