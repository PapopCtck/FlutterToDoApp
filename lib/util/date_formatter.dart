import 'package:intl/intl.dart';

String dateFormatted() {
  var now = DateTime.now();
  var formatter = new DateFormat("d MMM yy, h:m");
  String formatted = formatter.format(now);
  return formatted;
}