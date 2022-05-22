import 'package:flutter/material.dart';
import 'package:call_log/call_log.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_app_helper/app/home/phonelogs_view_model.dart';
import './callLogs.dart';

class PhoneTextField extends ConsumerStatefulWidget {
  Function? update;

  @override
   _PhoneTextFieldState createState() => _PhoneTextFieldState();
}

class _PhoneTextFieldState extends ConsumerState<PhoneTextField> {
  TextEditingController t1 = TextEditingController();
  CallLogs cl = new CallLogs();
  bool empty = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.update = (text) {
      print('called: ' + text);

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
    return Container(
        child: TextField(
      controller: t1,
      decoration: InputDecoration(
        labelText: "Phone number",
        contentPadding: EdgeInsets.all(10),
        suffixIcon: t1.text.length > 0
            ? Row(
              mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                      icon: Icon(Icons.phone),
                      onPressed: () {
                        cl.call(t1.text);
                      }),
                  IconButton(
                      icon: Icon(Icons.sms_outlined),
                      onPressed: () {
                       d.openWhatsApp(t1.text);
                      })
                ],
              )
            : null,
      ),
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.done,
      // onSubmitted: (value) => {cl.call(t1.text)},
    ));
  }
}
