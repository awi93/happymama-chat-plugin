import 'package:chat_service/core/models/views/vw_conversation_message.dart';
import 'package:chat_service/core/models/views/vw_user_active_conversation.dart';
import 'package:chat_service/ui/pages/conversation/bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uuid/uuid.dart';

class ConversationToolbar extends StatelessWidget {

  ConversationBloc _bloc;
  TextEditingController controller = new TextEditingController();
  final VwUserActiveConversation conversation;

  ConversationToolbar(this.conversation);

  @override
  Widget build(BuildContext context) {
    _bloc = BlocProvider.of<ConversationBloc>(context);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Container()
    );
  }

}