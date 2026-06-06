import 'dart:ui';
import '../../errors/exceptions/base/app_exception.dart';


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

  factory MessageResult.error({
    AppException? error,
  }){
    return MessageResult(
        color: Color(0xFFC62828),
        message: 'failed: ${error!.error}'
    );
  }
}