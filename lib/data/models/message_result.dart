import 'dart:ui';
import 'package:flutter/material.dart';


class MessageResult {
  final String? error;
  final String? message;
  final Color? color;

  MessageResult({
    this.message,
    this.error,
    this.color
  });

  factory MessageResult.initial(){
    return MessageResult(
      color: null,
      error: null,
      message: null,
    );
  }

  factory MessageResult.success({required String message}){
    return MessageResult(
      color: Color(0xFF2E7D32),
      message: message,
    );
  }

  factory MessageResult.error({
    required String message,
  }){
    return MessageResult(
        color: Color(0xFFC62828),
        message: message
    );
  }
}