import 'package:flutter/material.dart';


@immutable
class BottomSheetState {
  final bool isVisible;
  final IconData icon;

  const BottomSheetState({
    this.isVisible = false,
    this.icon = Icons.edit,
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