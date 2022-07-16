import 'dart:async';
import 'package:flutter/material.dart';
import 'package:schedule/ServiceHandler/ScheduleAPIHandler.dart';
import 'package:schedule/Data/Schedule.dart';
import 'package:schedule/Utils/Constants.dart';
import 'package:schedule/Utils/DateTimeUtils.dart';
import 'package:schedule/Utils/ScheduleUtils.dart';
import 'package:schedule/Widgets/Dialog.dart';

class SaveScheduleEvent{
  Schedule schedule;
  BuildContext buildContext;
  SaveScheduleEvent({required this.schedule, required this.buildContext});
}

class SchedulesBloc{
  ScheduleAPIHandler _scheduleAPIHandler = ScheduleAPIHandler();
  late DateTime selectedDate;

  final _schedulesStreamController = StreamController<List<Schedule>>();
  StreamSink<List<Schedule>> get _schedulesSink => _schedulesStreamController.sink;
  Stream<List<Schedule>> get schedulesStream => _schedulesStreamController.stream;

  final _listSchedulesEventStreamController = StreamController<DateTime>();
  StreamSink<DateTime> get eventSink => _listSchedulesEventStreamController.sink;
  Stream<DateTime> get _eventStream => _listSchedulesEventStreamController.stream;

/*  final _saveStateStreamController = StreamController<int>();
  StreamSink<int> get _saveStateSink => _saveStateStreamController.sink;
  Stream<int> get saveStateStream => _saveStateStreamController.stream;*/

  final _saveEventStreamController = StreamController<SaveScheduleEvent>();
  StreamSink<SaveScheduleEvent> get saveEventSink => _saveEventStreamController.sink;
  Stream<SaveScheduleEvent> get _saveEventStream => _saveEventStreamController.stream;

  SchedulesBloc(){
    selectedDate = DateTime.parse("2022-07-01");
    _eventStream.listen((DateTime date) async{
      selectedDate = date;
      List<Schedule> schedules = await getSchedulesForDate(DateTimeUtils.dateToStr(date));
      _schedulesSink.add(schedules);
    });

    _saveEventStream.listen((SaveScheduleEvent saveScheduleEvent) async{
      bool isValidated = await validate(saveScheduleEvent.buildContext, saveScheduleEvent.schedule);
      if(isValidated) {
        await _scheduleAPIHandler.saveSchedule(saveScheduleEvent.schedule);
        if(DateTimeUtils.dateToStr(selectedDate) == saveScheduleEvent.schedule.date){
          eventSink.add(selectedDate);
        }
        Navigator.pop(saveScheduleEvent.buildContext);
      }
    });
  }

  Future<List<Schedule>> getSchedulesForDate(String selectedDate) async{
    List<Schedule> schedules = await _scheduleAPIHandler.getSchedules();
    schedules = schedules.where((schedule) => schedule.date == selectedDate).toList();
    return schedules;
  }

  Future<bool> validate(BuildContext context, Schedule schedule) async {
    if(schedule.name == null || schedule.name.isEmpty){
      CustomDialog.showErrorDialog(context, "Schedule Name is empty.");
      return false;
    }
    if(DateTimeUtils.compareTime(DateTimeUtils.strToTime(schedule.endTime), DateTimeUtils.strToTime(schedule.startTime)) == -1){
      CustomDialog.showErrorDialog(context, "Start time should be less than end time.");
      return false;
    }
    bool scheduleExists = await ScheduleUtils.isScheduleExists(schedule);
    if(scheduleExists){
      CustomDialog.showErrorDialog(context, "This overlaps with another schedule and can’t be saved.");
      return false;
    }
    return true;
  }

  void dispose(){
    _listSchedulesEventStreamController.close();
    _saveEventStreamController.close();
    _schedulesStreamController.close();
  }
}