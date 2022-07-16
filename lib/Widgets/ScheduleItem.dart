import 'package:flutter/material.dart';
import 'package:schedule/Data/Schedule.dart';
import 'package:schedule/Utils/Constants.dart';
import 'package:schedule/Utils/DateTimeUtils.dart';
import 'package:timelines/timelines.dart';

class ScheduleItem extends StatelessWidget{

  Schedule schedule;
  bool isFirst;
  bool isLast;
  ScheduleItem({required this.schedule, this.isFirst = false, this.isLast = false});

  @override
  Widget build(BuildContext context) {
    String startTime = DateTimeUtils.timeToAmPm(DateTimeUtils.strToTime(schedule.startTime));
    String endTime = DateTimeUtils.timeToAmPm(DateTimeUtils.strToTime(schedule.endTime));
    return ListTile(
      title: Text("$startTime - $endTime", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),),
      subtitle: Text("${schedule.name}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
      leading: SizedBox(
        height: 50.0,
        width: 30.0,
        child: TimelineNode(
          indicator: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Color(0xffBBDEFB),
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Icon(Icons.calendar_today_rounded, color: Color(Constants.PRIMARY_BLUE), size: 15,)
          ),
          startConnector: isFirst? null : SolidLineConnector(color: Colors.black,),
          endConnector: isLast ? null : SolidLineConnector(color: Colors.black,),
        ),
      )
    );
  }
}