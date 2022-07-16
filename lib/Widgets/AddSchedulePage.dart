import 'package:flutter/material.dart';
import 'package:schedule/BLoC/Provider/BLoCProvider.dart';
import 'package:schedule/BLoC/SchedulesBLoC.dart';
import 'package:schedule/BLoC/DateTimeSelectorBloC.dart';
import 'package:schedule/Data/Schedule.dart';
import 'package:schedule/Utils/Constants.dart';
import 'package:schedule/Utils/DateTimeUtils.dart';
import 'package:schedule/Utils/ScheduleUtils.dart';

class AddSchedulePage extends StatefulWidget{
  AddSchedulePage();

  @override
  State<StatefulWidget> createState() {
    return AddSchedulePageState();
  }
}

class AddSchedulePageState extends State<AddSchedulePage>{
  final scheduleNameController = TextEditingController();
  DateTimeBloc dateTimeBloc = DateTimeBloc();

  @override
  void dispose(){
    dateTimeBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SchedulesBloc schedulesBloc = BlocProvider.of(context).schedulesBloc;
    return Container(
      child: Padding(
        padding: EdgeInsets.only(left: 8.0, top: 8.0, right: 8.0, bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Add Schedule", style: TextStyle(fontSize: 16, color: Color(Constants.PRIMARY_BLUE)),),
                IconButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.close, color: Colors.black)
                )
              ],
            ),
            Text(
              "Name", style: TextStyle(fontSize: 13),
            ),
            TextField(
              decoration: InputDecoration(
                  hintText: '',
                  filled: true,
                  fillColor: Color(Constants.PALE_BLUE),
                  border: InputBorder.none
              ),
              controller: scheduleNameController,
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              "Date & Time", style: TextStyle(fontSize: 13),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Container(
                color: Color(Constants.PALE_BLUE),
                child: Column(
                  children : [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Start Time", style: TextStyle(fontSize: 14),),
                        ),
                        Row(
                          children: [
                            StreamBuilder<String>(
                              stream: dateTimeBloc.startTimeStream,
                              initialData: DateTimeUtils.timeToAmPm(dateTimeBloc.startTime),
                              builder: (context, snapshot) {
                                if(snapshot.hasData && snapshot.data != null) {
                                  return Text(snapshot.data!, style: TextStyle(fontSize: 16, color: Color(Constants.PRIMARY_BLUE)));
                                }
                                return Text("");
                              }
                            ),
                            IconButton(onPressed: (){
                              dateTimeBloc.eventSink.add(DateTimeEvent(dateTimeAction: DateTimeAction.GetStartTime, context: context));
                            }, icon: Icon(Icons.arrow_forward_ios))
                          ],
                        )
                      ],
                    ),
                    Divider(
                      height: 1,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("End Time", style: TextStyle(fontSize: 14),),
                        ),
                        Row(
                          children: [
                            StreamBuilder<String>(
                                stream: dateTimeBloc.endTimeStream,
                                initialData: DateTimeUtils.timeToAmPm(dateTimeBloc.endTime),
                                builder: (context, snapshot) {
                                  if(snapshot.hasData && snapshot.data != null) {
                                    return Text(snapshot.data!, style: TextStyle(fontSize: 16, color: Color(Constants.PRIMARY_BLUE)));
                                  }
                                  return Text("");
                                }
                            ),
                            IconButton(onPressed: (){
                              dateTimeBloc.eventSink.add(DateTimeEvent(dateTimeAction: DateTimeAction.GetEndTime, context: context));
                            }, icon: Icon(Icons.arrow_forward_ios))
                          ],
                        )
                      ],
                    ),
                    Divider(
                      height: 1,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Date", style: TextStyle(fontSize: 14),),
                        ),
                        Row(
                          children: [
                            StreamBuilder<String>(
                                stream: dateTimeBloc.dateStream,
                                initialData: dateTimeBloc.date,
                                builder: (context, snapshot) {
                                  if(snapshot.hasData && snapshot.data != null) {
                                    return Text(snapshot.data!, style: TextStyle(fontSize: 16, color: Color(Constants.PRIMARY_BLUE)),);
                                  }
                                  return Text("");
                                }
                            ),
                            IconButton(onPressed: (){
                              dateTimeBloc.eventSink.add(DateTimeEvent(dateTimeAction: DateTimeAction.GetDate, context: context));
                            }, icon: Icon(Icons.arrow_forward_ios))
                          ],
                        )
                      ],
                    ),
                  ]
                ),
              ),
            ),
            Card(
              color: Color(Constants.PRIMARY_BLUE),
              child: ListTile(
                title: Center(child: Text('Add Schedule', style: TextStyle(fontSize: 16, color: Colors.white),)),
                onTap: () async {
                  Schedule schedule = Schedule(name: scheduleNameController.text, date: dateTimeBloc.date, startTime: DateTimeUtils.timeToStr(dateTimeBloc.startTime), endTime: DateTimeUtils.timeToStr(dateTimeBloc.endTime), phoneNumber: Constants.PHONE_NUMBER);
                  schedulesBloc.saveEventSink.add(SaveScheduleEvent(schedule: schedule, buildContext: context));
                },
              ),
            )
          ],
        ),
      )
    );
  }

  Future<bool> validate(Schedule schedule) async {
    if(schedule.name == null || schedule.name.isEmpty){
      showErrorDialog("Schedule Name is empty.");
      return false;
    }
    if(DateTimeUtils.compareTime(DateTimeUtils.strToTime(schedule.endTime), DateTimeUtils.strToTime(schedule.startTime)) == -1){
      showErrorDialog("Start time should be less than end time.");
      return false;
    }
    bool scheduleExists = await ScheduleUtils.isScheduleExists(schedule);
    if(scheduleExists){
      showErrorDialog("This overlaps with another schedule and can’t be saved.");
      return false;
    }
    return true;
  }

  void showErrorDialog(String message){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)
            ), //this right here
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "$message \n Please modify and try again."
                  ),
                  SizedBox(
                    width: 400.0,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.blueAccent)
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Okay",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

}