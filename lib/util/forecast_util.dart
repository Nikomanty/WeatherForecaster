import 'package:intl/intl.dart';

class Util {
  static String appId = "e293e00a8c63a949a256132d15f4aab9";
  static String longDateAndTimeFormat = "EEE, d. MMM. y, hh:mm aaa";
  static String shortDateAndTimeFormat = "d. MMM. y, hh:mm aaa";
  static String onlyTimeFormat = "hh:mm aaa";

  static String getFormattedDate(DateTime dateTime, String format){
    return new DateFormat(format).format(dateTime);
  }

}