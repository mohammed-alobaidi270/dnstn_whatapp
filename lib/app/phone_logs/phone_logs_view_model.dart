import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';
import 'package:achievement_view/achievement_view.dart';

final phonelogsViewModelProvider =
    StateNotifierProvider<PhonelogsViewModel, String>(((ref) {
  return PhonelogsViewModel(ref);
}));

class PhonelogsViewModel extends StateNotifier<String> {
  PhonelogsViewModel(this.ref) : super('');

  final Ref ref;

  openWhatsApp(String num, BuildContext context) async {
    String number = num;

    if (num.startsWith('+966')) {
      number = num;
    } else if (num.startsWith('966')) {
      number = '+$num';
    } else if (num.startsWith('0')) {
      number = '+966${num.replaceFirst('0', '', 0)}';
    } else if (num.startsWith('5')) {
      number = '+966$num';
    }

    final link = WhatsAppUnilink(
      phoneNumber: number,
      text: '',
    );

    try {
      await launchUrl(link.asUri(), mode: LaunchMode.externalApplication);
    } catch (e) {
      AchievementView(
        title: 'Could not launch $num' '      ',
        icon: const Icon(
          Icons.error_outline,
          color: Colors.white,
        ),
        color:  Colors.red[400]!,
        textStyleSubTitle: const TextStyle(fontSize: 0.0),
        textStyleTitle: const TextStyle(
          color: Colors.white,
          fontSize: 17.0,
        ),
        alignment: Alignment.topCenter,
        duration: const Duration(seconds: 6),
        isCircle: false,
      ).show(context);
      throw 'Could not launch $num';
    }
  }
}
