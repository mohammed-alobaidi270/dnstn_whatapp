import 'package:flutter/material.dart';
import 'package:call_log/call_log.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dnstn_whatapp/app/phone_logs/all_phone_logs_tab.dart';
import 'package:dnstn_whatapp/app/phone_logs/missed_phone_logs_tab.dart';
import 'package:dnstn_whatapp/widgets/call_logs_widget.dart';
import 'package:dnstn_whatapp/widgets/phone_textfield.dart';
import 'package:buttons_tabbar/buttons_tabbar.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        // appBar: AppBar(
        //   centerTitle: true,
        //   title: ButtonsTabBar(
        //     // center :true,
        //     elevation: 50,
        //     borderColor: Colors.red,
        //     backgroundColor: Colors.white,
        //     unselectedBackgroundColor: Colors.grey[300],
        //     contentPadding: const EdgeInsets.symmetric(horizontal: 25),
        //     buttonMargin: const EdgeInsets.all(4),
        //     // unselectedLabelStyle: TextStyle(color: Colors.grey),
        //     labelStyle:
        //         TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        //     tabs: [
        //       Tab(
        //         height: 50,
        //         text: 'All',
        //       ),
        //       Tab(
        //         text: 'Missed',
        //       ),
        //     ],
        //   ),
        // ),
        body: SafeArea(
          child: FutureBuilder(
            future: logs,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                Iterable<CallLogEntry> entries =
                    snapshot.data as Iterable<CallLogEntry>;
                return Column(
                  children: [
                    const SizedBox(height: 15),
                    Container(
                      padding: EdgeInsets.zero,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade700,
                          borderRadius: BorderRadius.circular(10)),
                      child: ButtonsTabBar(
                        backgroundColor: Colors.grey.shade800,
                        unselectedBackgroundColor: Colors.grey.shade700,
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 25),
                        buttonMargin: const EdgeInsets.all(3),
                        unselectedLabelStyle:
                            TextStyle(color: Colors.blueGrey.shade200),
                        labelStyle: TextStyle(
                            color: Colors.blueGrey.shade200,
                            fontWeight: FontWeight.bold),
                        tabs: const [
                          Tab(
                            height: 50,
                            text: 'All',
                          ),
                          Tab(
                            text: 'Missed',
                          ),
                        ],
                      ),
                    ),
                    pt,
                    Expanded(
                      child: TabBarView(
                        children: <Widget>[
                          AllPhonelogsTab(entries: entries),
                          MissedPhonelogsTab(entries:entries,
                              missedEntries: entries.where((element) =>
                                  element.callType == CallType.missed)),
                        ],
                      ),
                    ),
                  ],
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
    );
  }
}
