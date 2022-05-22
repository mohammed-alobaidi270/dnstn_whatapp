import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
final phonelogsViewModelProvider = StateNotifierProvider<PhonelogsViewModel, String>(((ref){
  return PhonelogsViewModel(ref);
}));


class PhonelogsViewModel extends StateNotifier<String>{
  PhonelogsViewModel(this.ref) :super('');

  final Ref ref;

  openWhatsApp(String num) async { 
  
      if (await canLaunchUrl(Uri.parse('whatsapp://send?phone=$num'))) {
        if(num.startsWith('+')){
           await launchUrl(Uri.parse('whatsapp://send?phone=$num'));
        }else{
            await launchUrl(Uri.parse('whatsapp://send?phone=+966$num'));
        }
     
    } else {
      throw 'Could not launch $num';
    }

  }
}