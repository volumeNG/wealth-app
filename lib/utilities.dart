import 'package:intl/intl.dart';

String getTimeFromDateAndTime(String date) {
  DateTime dateTime;
  try {
    dateTime = DateTime.parse(date).toLocal();
    return DateFormat.jm().format(dateTime).toString(); //5:08 PM
// String formattedTime = DateFormat.Hms().format(now);
// String formattedTime = DateFormat.Hm().format(now);   // //17:08  force 24 hour time
  } catch (e) {
    return date;
  }
}


String formatDropdownString(String value) {
  // Split by camel case and capitalize each word
  final regex = RegExp(r'(?<=[a-z])(?=[A-Z])');
  return value
      .split(regex)
      .map((word) => word[0].toUpperCase() + word.substring(1))
      .join(' ');
}


// Regular expression to match URLs
//Check if message is a link
final urlRegExp = RegExp(
  r'^(http|https):\/\/[^\s/$.?#].[^\s]*$',
  caseSensitive: false,
);