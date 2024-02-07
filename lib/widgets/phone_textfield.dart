import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dnstn_whatapp/app/phone_logs/phone_logs_view_model.dart';
import 'call_logs_widget.dart';

// ignore: must_be_immutable
class PhoneTextField extends ConsumerStatefulWidget {
  Function? update;

  PhoneTextField({Key? key}) : super(key: key);

  @override
   _PhoneTextFieldState createState() => _PhoneTextFieldState();
}

class _PhoneTextFieldState extends ConsumerState<PhoneTextField> {
  TextEditingController t1 = TextEditingController();
  CallLogs cl =  CallLogs();
  bool empty = false;
  @override
  void initState() {
    super.initState();
    widget.update = (text) {
      if (kDebugMode) {
        print('called: ' + text);
      }

      setState(() {
        t1.text = text;
      });
    };

    t1.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
   final d = ref.read(phonelogsViewModelProvider.notifier);
    return TextField(
      controller: t1,
      decoration: InputDecoration(
    labelText: "Phone number",
    contentPadding: const EdgeInsets.all(10),
    suffixIcon: t1.text.isNotEmpty
        ? Row(
          mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                  icon: const Icon(Icons.phone),
                  onPressed: () {
                    cl.call(t1.text);
                  }),
              IconButton(
                  icon: const Icon(Icons.sms_outlined),
                  onPressed: () {
                   d.openWhatsApp(t1.text,context);
                  })
            ],
          )
        : null,
      ),
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.done,
      // onSubmitted: (value) => {cl.call(t1.text)},
    );
  }
}
