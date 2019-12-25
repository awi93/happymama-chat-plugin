import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:intl/intl.dart';
import 'package:chat_service/ui/widgets/message_item/custom_message/factory.dart';

class Util {

  static final http.Client httpClient = new http.Client();
  static final FlutterSecureStorage secureStorage = new FlutterSecureStorage();
  static RemoteConfig remoteConfig;
  static Locale locale = new Locale("id");
  static Factory factory = new Factory();
  static String GOOGLE_API_KEY;

  static const HOUR_MINUTE = "HH:mm";
  static const MONTH_DAY_YEAR = "MMMM dd, yyyy";

  static int datetimeToMillis(DateTime date) {
    if(date == null)
      return null;

    return date.millisecondsSinceEpoch;
  }

  static DateTime millisToDatetime(int millis) {
    if(millis == null)
      return null;

    DateTime date = DateTime.fromMillisecondsSinceEpoch(millis);

    return date;
  }

  static String formatDate(String format, DateTime date, ) {
    if (date == null)
      return "-";
    return DateFormat(format, locale.languageCode).format(date);
  }

}