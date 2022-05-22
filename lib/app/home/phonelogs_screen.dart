import 'package:flutter/material.dart';

import 'package:call_log/call_log.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_app_helper/app/home/phonelogs_view_model.dart';
import 'package:whats_app_helper/widgets/callLogs.dart';
import 'package:whats_app_helper/widgets/phone_textfield.dart';


class PhonelogsScreen extends ConsumerStatefulWidget {
  @override
  _PhonelogsScreenState createState() => _PhonelogsScreenState();
}

class _PhonelogsScreenState extends ConsumerState<PhonelogsScreen> with  WidgetsBindingObserver {
  //Iterable<CallLogEntry> entries;
  PhoneTextField pt = new PhoneTextField();
  CallLogs cl = new CallLogs();

  AppLifecycleState? _notification;
  Future<Iterable<CallLogEntry>>? logs;

  @override
  void initState(){
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    logs = cl.getCallLogs();
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);

    if (AppLifecycleState.resumed == state){
    setState(() {
        logs = cl.getCallLogs();
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    final d = ref.read(phonelogsViewModelProvider.notifier);
    return Scaffold(
      appBar: AppBar(title: Text("Phone"),),
      body: Column(
       mainAxisSize: MainAxisSize.min,
        children: [
          pt,
          // TextField(controller: t1, decoration: InputDecoration(labelText: "Phone number", contentPadding: EdgeInsets.all(10), suffixIcon: IconButton(icon: Icon(Icons.phone), onPressed: (){print("pressed");})),keyboardType: TextInputType.phone, textInputAction: TextInputAction.done, onSubmitted: (value) => call(value),),
          FutureBuilder(future:  logs,builder: (context, snapshot){
            if(snapshot.connectionState == ConnectionState.done){
             Iterable<CallLogEntry> entries = snapshot.data as Iterable<CallLogEntry>;
              return Expanded(
                child: ListView.builder( padding: EdgeInsets.all(0),itemBuilder: (context, index){
                 if(index!=0){
                   if(entries.elementAt(index-1).number != entries.elementAt(index).number){
                      return 
                   Column(
                     children: [
                       GestureDetector( child: Card(
                         margin: EdgeInsets.all(0),
                         
                            child: ListTile(
                              dense: true,
                              contentPadding:EdgeInsets.all(10),
                            // leading: cl.getAvator(entries.elementAt(index).callType!),
                            title: cl.getTitle(entries.elementAt(index)),
                            subtitle: Text(cl.formatDate(new DateTime.fromMillisecondsSinceEpoch(entries.elementAt(index).timestamp!))  + cl.getTime(entries.elementAt(index).duration!)),
                            isThreeLine: true,
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(icon: Icon(Icons.phone), color: Colors.green, onPressed: (){
                                  cl.call(entries.elementAt(index).number!);
                                }),
                                  IconButton(icon: Icon(Icons.sms_outlined), color: Colors.green, onPressed: (){
                                  d.openWhatsApp(entries.elementAt(index).number!);
                                }),
                              ],
                            ),
                          ),
                  ), onLongPress: () => pt.update!(entries.elementAt(index).number.toString()),
                  ),
                    Divider(
            thickness: 1,
            height: 0.0,
          ),
                     ],
                   );
                  
                   }
                   return SizedBox.shrink();
                  
                 }else{
                        return
                   Column(
                     children: [
                       GestureDetector( child: Card(
                         margin: EdgeInsets.all(0),
                         
                            child: ListTile(
                              dense: true,
                              contentPadding:EdgeInsets.all(10),
                            // leading: cl.getAvator(entries.elementAt(index).callType!),
                            title: cl.getTitle(entries.elementAt(index)),
                            subtitle: Text(cl.formatDate(new DateTime.fromMillisecondsSinceEpoch(entries.elementAt(index).timestamp!))  + cl.getTime(entries.elementAt(index).duration!)),
                            isThreeLine: true,
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(icon: Icon(Icons.phone), color: Colors.green, onPressed: (){
                                  cl.call(entries.elementAt(index).number!);
                                }),
                                  IconButton(icon: Icon(Icons.sms_outlined), color: Colors.green, onPressed: (){
                                  d.openWhatsApp(entries.elementAt(index).number!);
                                }),
                              ],
                            ),
                          ),
                  ), onLongPress: () => pt.update!(entries.elementAt(index).number.toString()),
                  ),
                    Divider(
            thickness: 1,
            height: 0.0,
          ),
                     ],
                   );
                 }
                  
                }, itemCount: entries.length,
                
                ),
              );
            }else{
              return Center(child: CircularProgressIndicator());
            }
          }),
       
        ],
      ),
    );
  }
}