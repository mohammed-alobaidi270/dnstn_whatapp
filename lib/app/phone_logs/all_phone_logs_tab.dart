import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:call_log/call_log.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dnstn_whatapp/app/number_logs/number_logs_screen.dart';
import 'package:dnstn_whatapp/app/phone_logs/phone_logs_view_model.dart';
import 'package:dnstn_whatapp/widgets/call_logs_widget.dart';
import 'package:dnstn_whatapp/widgets/phone_textfield.dart';

class AllPhonelogsTab extends ConsumerStatefulWidget {
  final Iterable<CallLogEntry> entries;
  const AllPhonelogsTab({Key? key, required this.entries}) : super(key: key);

  @override
  _AllPhonelogsTabState createState() => _AllPhonelogsTabState();
}

class _AllPhonelogsTabState extends ConsumerState<AllPhonelogsTab>
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
    int numOfcall = 0;
    Iterable<CallLogEntry> entries = widget.entries;
    return ListView.builder(
      padding: const EdgeInsets.all(0),
      itemCount: entries.length,
      itemBuilder: (context, index) {
        if (entries.elementAt(index).number ==
                entries.elementAt(index + 1).number &&
            entries.elementAt(index).callType ==
                entries.elementAt(index + 1).callType!) {
          numOfcall++;
          return const SizedBox.shrink();
        }
        int numOfcall2 = numOfcall;
        numOfcall = 0;
        return Column(
          children: [
            GestureDetector(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 27),
                    child: cl.getAvator(entries.elementAt(index).callType!),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      cl.getTitle(
                          entries.elementAt(index), numOfcall2, context),
                      Text(cl.formatDate(DateTime.fromMillisecondsSinceEpoch(
                              entries.elementAt(index).timestamp!)) +
                          cl.getTime(entries.elementAt(index).duration!),style: const TextStyle(color: Colors.white54),),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(CupertinoIcons.chat_bubble_text),
                      color: Colors.blueGrey.shade200,
                      iconSize: 35,
                      onPressed: () {
                        pro.openWhatsApp(
                            entries.elementAt(index).number!, context);
                      }),
                  IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(CupertinoIcons.exclamationmark_circle),
                      color: Colors.blueGrey.shade200,
                      iconSize: 35,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NumberlogsScreen(
                                    entries: entries.where((element) =>
                                        element.number ==
                                        entries.elementAt(index).number),
                                  )),
                        );
                      }),

                  // ListTile(
                  //   dense: true,
                  //   contentPadding: const EdgeInsets.all(10),
                  //   leading: ,
                  //   title: ,
                  //   subtitle: Text(cl.formatDate(
                  //           DateTime.fromMillisecondsSinceEpoch(
                  //               entries
                  //                   .elementAt(index)
                  //                   .timestamp!)) +
                  //       cl.getTime(
                  //           entries.elementAt(index).duration!)),
                  //   isThreeLine: true,
                  //   trailing: Row(
                  //     mainAxisSize: MainAxisSize.min,
                  //     children: [
                  //       IconButton(
                  //           padding: EdgeInsets.zero,
                  //           icon: const Icon(
                  //               CupertinoIcons.chat_bubble_text),
                  //           color: Colors.blue.shade700,
                  //           iconSize: 35,
                  //           onPressed: () {
                  //             pro.openWhatsApp(
                  //                 entries.elementAt(index).number!,
                  //                 context);
                  //           }),
                  //       // const SizedBox(width: 8),
                  //       IconButton(
                  //           padding: EdgeInsets.zero,
                  //           icon: const Icon(CupertinoIcons
                  //               .exclamationmark_circle),
                  //           color: Colors.blue.shade700,
                  //           iconSize: 35,
                  //           onPressed: () {
                  //             Navigator.push(
                  //               context,
                  //               MaterialPageRoute(
                  //                   builder: (context) =>
                  //                       NumberlogsScreen(
                  //                         entries: entries.where(
                  //                             (element) =>
                  //                                 element.number ==
                  //                                 entries
                  //                                     .elementAt(
                  //                                         index)
                  //                                     .number),
                  //                       )),
                  //             );
                  //           }),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
              onLongPress: () {
                pt.update!(entries.elementAt(index).number.toString());
              },
              onTap: () {
                cl.call(entries.elementAt(index).number!);
              },
            ),
            const Padding(
              padding: EdgeInsets.only(left: 30),
              child: Divider(
                thickness: 1,
                height: 0.0,
              ),
            ),
          ],
        );
      },
    );
  }
}
