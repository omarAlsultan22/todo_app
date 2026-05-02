import 'package:flutter/material.dart';
import 'package:todo_app/constants/app_icons.dart';


class BottomSheetState {
  final bool isVisible;
  final IconData icon;

  const BottomSheetState({
    this.isVisible = false,
    this.icon = AppIcons.editIcon,
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