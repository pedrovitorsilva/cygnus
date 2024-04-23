import 'package:toast/toast.dart';

void userMessage(String msg) {
  Toast.show(
    msg,
    duration: Toast.lengthLong,
    gravity: Toast.bottom,
  );
}
