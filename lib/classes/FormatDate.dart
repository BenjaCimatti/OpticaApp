import 'package:intl/intl.dart';
  
String formatDate (String date) {
  String dateTimeString = date;
  final dateTime = DateTime.parse(dateTimeString);
  final format = DateFormat('dd/MM/yyyy');
  final formatedDate = format.format(dateTime);

  return formatedDate;
}