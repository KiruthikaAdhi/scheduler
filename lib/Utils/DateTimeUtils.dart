import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension TimeOfDayExtension on TimeOfDay {
  TimeOfDay addHour(int hour) {
    return this.replacing(hour: (this.hour + hour)%24, minute: this.minute);
  }
}

class DateTimeUtils{

  static String dateToStr(DateTime dateTime){
    String dateTimeStr = DateFormat('dd/MM/yyyy').format(dateTime);
    return dateTimeStr;
  }

  static String timeToStr(TimeOfDay timeOfDay){
    String dateTimeStr = '${timeOfDay.hour.toString().padLeft(2, '0')}:${timeOfDay.minute.toString().padLeft(2, '0')}:00';
    return dateTimeStr;
  }

  static TimeOfDay strToTime(String time){
    TimeOfDay timeOfDay = TimeOfDay(hour:int.parse(time.split(":")[0]),minute: int.parse(time.split(":")[1]));
    return timeOfDay;
  }

  static String timeToAmPm(TimeOfDay timeOfDay){
    String dateTimeStr = "${timeOfDay.hour}:${timeOfDay.minute}:00";
    dateTimeStr = DateFormat.jm().format(DateFormat("hh:mm:ss").parse(dateTimeStr));
    return dateTimeStr;
  }

  static int compareTime(TimeOfDay a, TimeOfDay b){
    if(a.hour > b.hour) {
      return 1;
    }
    if(a.hour == b.hour){
      if(a.minute > b.minute){
        return 1;
      }
    }
    return -1;
  }
}