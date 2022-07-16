import 'package:flutter/material.dart';
import 'package:schedule/ServiceHandler/ScheduleAPIHandler.dart';
import 'package:schedule/Data/Schedule.dart';
import 'package:schedule/Utils/DateTimeUtils.dart';

class ScheduleUtils{

  static List<Schedule> sortSchedulesByTime(List<Schedule> schedules){
    schedules.sort((a,b){
      TimeOfDay aStartTime = DateTimeUtils.strToTime(a.startTime);
      TimeOfDay bStartTime = DateTimeUtils.strToTime(b.startTime);
      return DateTimeUtils.compareTime(aStartTime, bStartTime);
    });
    return schedules;
  }

  static Future<bool> isScheduleExists(Schedule newSchedule) async{
    ScheduleAPIHandler scheduleAPIHandler = ScheduleAPIHandler();
    List<Schedule> schedules = await scheduleAPIHandler.getSchedules();
    for(Schedule schedule in schedules){
      if(schedule.startTime == newSchedule.startTime && schedule.endTime == newSchedule.endTime && schedule.date == newSchedule.date){
        return true;
      }
    }
    return false;
  }
}