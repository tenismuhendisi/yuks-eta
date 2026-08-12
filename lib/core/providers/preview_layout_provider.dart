import 'package:flutter_riverpod/flutter_riverpod.dart';

enum PreviewLayout { mobile, web }

final previewLayoutProvider =
    StateProvider<PreviewLayout>((ref) => PreviewLayout.mobile);

/// iPhone 15 mantıksal boyut (pt): 393 × 852
const double kMobilePreviewWidth = 393;
const double kMobilePreviewHeight = 852;
