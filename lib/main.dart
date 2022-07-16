import 'package:flutter/material.dart';
import 'package:schedule/BLoC/Provider/BLoCProvider.dart';
import 'package:schedule/BLoC/SchedulesBLoC.dart';
import 'package:schedule/Data/Schedule.dart';
import 'package:schedule/Utils/Constants.dart';
import 'package:schedule/Widgets/AddSchedulePage.dart';
import 'package:schedule/Widgets/DayDateScrollList.dart';
import 'package:schedule/Widgets/ScheduleList.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      schedulesBloc: SchedulesBloc(),
      child: MaterialApp(
        title: 'Scheduler',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'Euclid Circular B'
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    SchedulesBloc schedulesBloc = BlocProvider.of(context).schedulesBloc;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Flexible(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "JULY 2022",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: DayDateScrollList()
                ),
                Expanded(
                  flex: 10,
                  child: StreamBuilder<List<Schedule>>(
                    stream: schedulesBloc.schedulesStream,
                    builder: (context, snapshot) {
                      if(snapshot.hasData && snapshot.data != null && snapshot.data!.isNotEmpty) {
                        return Container(child: ScheduleList(schedules : snapshot.data!));
                      }
                      return Center(
                        child: Text(
                          "No schedules found!",
                          style: TextStyle(fontSize: 20),
                        ),
                      );
                    }
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(Constants.PRIMARY_BLUE),
        onPressed: () async{
          showModalBottomSheet(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              isScrollControlled: true,
              context: context,
              builder: (context) => AddSchedulePage()
          );
          //schedulesBLoC.eventSink.add("");
        },
        tooltip: 'Add New Schedule',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
