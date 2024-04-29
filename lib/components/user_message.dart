import 'package:toast/toast.dart';

/// A [Toast] message function
void userMessage(String msg) {
  Toast.show(
    msg,
    duration: Toast.lengthLong,
    gravity: Toast.bottom,
  );
}
