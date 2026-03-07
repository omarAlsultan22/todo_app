import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';


class BottomSheetState {
  final bool isVisible;
  final IconData icon;

  const BottomSheetState({
    this.isVisible = false,
    this.icon = AppConstants.editIcon,
  });

  BottomSheetState copyWith({
    bool? isVisible,
    IconData? icon,
  }) {
    return BottomSheetState(
      isVisible: isVisible ?? this.isVisible,
      icon: icon ?? this.icon,
    );
  }
}