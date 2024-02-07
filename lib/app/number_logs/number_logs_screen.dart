import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:call_log/call_log.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dnstn_whatapp/app/phone_logs/phone_logs_view_model.dart';
import 'package:dnstn_whatapp/widgets/call_logs_widget.dart';
import 'package:dnstn_whatapp/widgets/phone_textfield.dart';

class NumberlogsScreen extends ConsumerStatefulWidget {
  final Iterable<CallLogEntry> entries;
  const NumberlogsScreen({Key? key, required this.entries}) : super(key: key);

  @override
  _NumberlogsScreenState createState() => _NumberlogsScreenState();
}

class _NumberlogsScreenState extends ConsumerState<NumberlogsScreen>
    with WidgetsBindingObserver {
  //Iterable<CallLogEntry> entries;
  PhoneTextField pt = PhoneTextField();
  CallLogs cl = CallLogs();

  // AppLifecycleState? _notification;
  Future<Iterable<CallLogEntry>>? logs;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    logs = cl.getCallLogs();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (AppLifecycleState.resumed == state) {
      setState(() {
        logs = cl.getCallLogs();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final pro = ref.read(phonelogsViewModelProvider.notifier);
    Iterable<CallLogEntry> entries = widget.entries;
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20),
            Container(
              height: 100,
              width: 100,
              decoration: const BoxDecoration(
                color: Colors.greenAccent,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  entries.first.name?.split('').first ?? '',
                  style: const TextStyle(fontSize: 40, height: 1),
                ),
              ),
            ),
            Text(
              entries.first.name ?? entries.first.number ?? '',
              style: TextStyle(color: Colors.blueGrey.shade200, fontSize: 30),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.call),
                    color: Colors.blueGrey.shade200,
                    iconSize: 35,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NumberlogsScreen(
                                  entries: entries.where((element) =>
                                      element.number == entries.first.number),
                                )),
                      );
                    }),
                IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(CupertinoIcons.chat_bubble_text),
                    color: Colors.blueGrey.shade200,
                    iconSize: 35,
                    onPressed: () {
                      pro.openWhatsApp(entries.first.number!, context);
                    }),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(0),
                itemCount: entries.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      GestureDetector(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 27),
                              child: cl.getAvator(
                                  entries.elementAt(index).callType!),
                            ),
                            const SizedBox(width: 8),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                cl.getTitle(
                                    entries.elementAt(index), 0, context),
                                Text(
                                    cl.formatDate(
                                            DateTime.fromMillisecondsSinceEpoch(
                                                entries
                                                    .elementAt(index)
                                                    .timestamp!)) +
                                        cl.getTime(
                                            entries.elementAt(index).duration!),
                                    style:
                                        const TextStyle(color: Colors.white54)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        thickness: 1,
                        height: 0.0,
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
