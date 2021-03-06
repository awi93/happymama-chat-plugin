import 'package:chat_service/core/utils/util.dart';
import 'package:chat_service/ui/widgets/embedded_message_picker/embedded_message_picker.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chat_service/ui/widgets/message_item/custom_message/factory.dart';

class ChatService {

  static void init(RemoteConfig remoteConfig, SharedPreferences prefs) {
    Util.remoteConfig = remoteConfig;
    Util.prefs = prefs;
  }

  static void setLocale(Locale locale) {
    Util.locale = locale;
  }

  static void setFactory(Factory factory) {
    Util.factory = factory;
  }

  static void setEmbeddedMessagePicker(List<EmbeddedMessagePicker> pickers) {
    Util.embeddedMessagePickers = pickers;
  }

  static void setGoogleApiKey(String googleApiKey) {
    Util.GOOGLE_API_KEY = googleApiKey;
  }

}
