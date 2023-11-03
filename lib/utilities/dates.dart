import 'package:intl/intl.dart';
import 'package:webviewflutter/utilities/shared_preferences.dart';

String getCurrentDateTime(String format, {int daysBefore = 0}) {
  DateTime now = DateTime.now().subtract(Duration(days: daysBefore));
  String formattedDateTime = DateFormat(format).format(now);
  return formattedDateTime;
}

String formatDate(String dateTime, {String dateAfter = "dd MMMM yyyy", String dateBefore = "yyyy-MM-dd HH:mm:ss"}) {
  if(dateTime == '') return '-';
  final input = DateFormat(dateBefore, SharedPreference().getLang());
  final output = DateFormat(dateAfter, SharedPreference().getLang());
  final getAbbreviate = input.parse(dateTime);
  return output.format(getAbbreviate);
}

bool endDateValid(String initialDateText, String endDateText) {
  DateTime initialDate = DateTime.parse(initialDateText);
  DateTime endDate = DateTime.parse(endDateText);

  return !endDate.isBefore(initialDate);
}