import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:intl/intl.dart';

class CallLogs {
  void call(String text) async {
    await FlutterPhoneDirectCaller.callNumber(text);
  }

  getAvator(CallType callType) {
    switch (callType) {
      case CallType.outgoing:
        return Icon(
          Icons.phone_forwarded_rounded,
          color: Colors.blueGrey.shade200,
          size: 25,
        );
      case CallType.missed:
        return const Icon(
          null,
          size: 25,
        );
      default:
        return Icon(
          Icons.phone_callback_rounded,
          color: Colors.blueGrey.shade200,
          size: 25,
        );
    }
  }

  Future<Iterable<CallLogEntry>> getCallLogs() {
    return CallLog.get();
  }

  String formatDate(DateTime dt) {
    return DateFormat('d-MMM-y H:m:s').format(dt);
  }

  getTitle(CallLogEntry entry, int numOfcall, context) {
    String title = '';
    String subtitle = '';
    Color color = Colors.black87;
    if (entry.name == null) {
      title = entry.number ?? '-';
    } else if (entry.name!.isEmpty) {
      title = entry.number ?? '-';
    } else {
      title = entry.name ?? '-';
    }
    if (numOfcall != 0) {
      subtitle = ' ( ${numOfcall + 1} )';
    }
    if (entry.callType == CallType.outgoing) {
      color = Colors.blueGrey.shade200;
    } else if (entry.callType == CallType.missed) {
      color = Colors.red.shade300;
    } else {
      color = Colors.blueGrey.shade200;
    }
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
              color: color, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          subtitle,
          style: TextStyle(
              color: color, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  String getTime(int duration) {
    Duration d1 = Duration(seconds: duration);
    String formatedDuration = "";
    if (d1.inHours > 0) {
      formatedDuration += d1.inHours.toString() + "h ";
    }
    if (d1.inMinutes > 0) {
      formatedDuration += d1.inMinutes.toString() + "m ";
    }
    if (d1.inSeconds > 0) {
      formatedDuration += d1.inSeconds.toString() + "s";
    }
    if (formatedDuration.isEmpty) {
      return "";
    }
    return '($formatedDuration)';
  }
}
