import 'package:chat_service/ui/widgets/embedded_message_picker/embedded_message_picker.dart';
import 'package:chat_service/ui/widgets/message_item/custom_message/factory.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Util {

  static final http.Client httpClient = new http.Client();
  static final FlutterSecureStorage secureStorage = new FlutterSecureStorage();
  static RemoteConfig remoteConfig;
  static SharedPreferences prefs;
  static Locale locale = new Locale("id");
  static Factory factory = new Factory();
  static List<EmbeddedMessagePicker> embeddedMessagePickers = [];
  static String GOOGLE_API_KEY;

  static String RABBIT_USERNAME = "happymama";
  static String RABBIT_PASSWORD = "l8BFGCiPuiTkUBsCXDIc9K2JwOiyZ1Z8";

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

  static String formatNumeric(Locale locale, double data) {
    if (data != null) {
      NumberFormat format = new NumberFormat("#,###", locale.languageCode);

      return format.format(data);
    }

    return "-";
  }


  static String formatCurrency(Locale locale, double data) {
    if (data != null) {
      NumberFormat format = NumberFormat.currency(
          locale: locale.languageCode, symbol: "Rp ");

      return format.format(data);
    }

    return "-";
  }


}