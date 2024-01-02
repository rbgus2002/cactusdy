

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HapticRefreshIndicator extends RefreshIndicator {
  HapticRefreshIndicator({
    super.key,
    required super.child,
    required onRefresh,
    super.strokeWidth,
    super.backgroundColor,
    super.color,
    super.edgeOffset,
    super.displacement
  }) : super(onRefresh: () {
    HapticFeedback.mediumImpact();
    return onRefresh();
  });
}