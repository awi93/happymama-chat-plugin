import 'package:chat_service/core/blocs/online_status/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnlineStatus extends StatelessWidget {

  String _memberId;

  OnlineStatus(this._memberId);

  OnlineStatusBloc _bloc = new OnlineStatusBloc();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: _bloc..dispatch(Init(_memberId)),
      builder: (context, state) {
        String text = "";
        if (state is OnlineState) {
          text = "Online";
        }
        else if (state is OfflineState) {
          if (state.data["last"] != null) {
            if ((state.data["last"] as Duration).inMinutes > 0 && (state.data["last"] as Duration).inMinutes < 60) {
              text = "Terakhir Online : " + (state.data["last"] as Duration).inMinutes.toString() + " Menit yang Lalu";
            }
            else if ((state.data["last"] as Duration).inMinutes > 60 && (state.data["last"] as Duration).inMinutes < 1440) {
              text = "Terakhir Online : " + (state.data["last"] as Duration).inHours.toString() + " Jam yang Lalu";
            }
            else if ((state.data["last"] as Duration).inMinutes > 1440) {
              text = "Terakhir Online : " + (state.data["last"] as Duration).inDays.toString() + " Hari yang Lalu";
            }
            else return Text("Offline");
          }
          else {
            text = "Offline";
          }
        }

        return Text(
          text,
          style: TextStyle(
            color: Colors.grey[500],
            fontSize: 11,
            fontWeight: FontWeight.normal
          ),
        );
      },
    );
  }

}