import 'package:flutter_riverpod/flutter_riverpod.dart';

enum PreviewLayout { mobile, web }

/// Geliştirme önizlemesi: varsayılan mobil genişlik.
final previewLayoutProvider =
    StateProvider<PreviewLayout>((ref) => PreviewLayout.mobile);

const double kMobilePreviewWidth = 390;
