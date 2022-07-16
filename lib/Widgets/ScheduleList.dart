import 'package:flutter/material.dart';
import 'package:schedule/Data/Schedule.dart';
import 'package:schedule/Utils/ScheduleUtils.dart';
import 'package:schedule/Widgets/ScheduleItem.dart';

class ScheduleList extends StatelessWidget{
  List<Schedule> schedules;

  ScheduleList({required this.schedules});
  @override
  Widget build(BuildContext context) {
    schedules = ScheduleUtils.sortSchedulesByTime(schedules);
    return Container(
      decoration: BoxDecoration(
        color: Color(0xffF5F5F5),
        borderRadius: BorderRadius.circular(10)
      ),
      child: ListView.builder(
        itemBuilder: (context, index) {
          return ScheduleItem(schedule: schedules[index], isFirst: (index == 0), isLast: index == (schedules.length - 1),);
        },
        itemCount: schedules.length),
    );
  }

}