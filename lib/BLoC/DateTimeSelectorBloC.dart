import 'dart:async';
import 'package:flutter/material.dart';
import 'package:schedule/Utils/DateTimeUtils.dart';

enum DateTimeAction{
  GetStartTime,
  GetEndTime,
  GetDate
}

class DateTimeEvent{
  DateTimeAction dateTimeAction;
  BuildContext context;

  DateTimeEvent({required this.dateTimeAction, required this.context});
}

class DateTimeBloc{
  late TimeOfDay startTime;
  late TimeOfDay endTime;
  late String date;

  final _startTimeStreamController = StreamController<String>();
  StreamSink<String> get _startTimeSink => _startTimeStreamController.sink;
  Stream<String> get startTimeStream => _startTimeStreamController.stream;

  final _endTimeStreamController = StreamController<String>();
  StreamSink<String> get _endTimeSink => _endTimeStreamController.sink;
  Stream<String> get endTimeStream => _endTimeStreamController.stream;

  final _dateStreamController = StreamController<String>();
  StreamSink<String> get _dateSink => _dateStreamController.sink;
  Stream<String> get dateStream => _dateStreamController.stream;

  final _eventStreamController = StreamController<DateTimeEvent>();
  StreamSink<DateTimeEvent> get eventSink => _eventStreamController.sink;
  Stream<DateTimeEvent> get _eventStream => _eventStreamController.stream;

  DateTimeBloc(){
    startTime = TimeOfDay.now();
    endTime = TimeOfDay.now().addHour(1);
    date = DateTimeUtils.dateToStr(DateTime.now());
    _eventStream.listen((DateTimeEvent dateTimeEvent) async{
      await handleDateTimeEvent(dateTimeEvent);
    });
  }

  Future<void> handleDateTimeEvent(DateTimeEvent dateTimeEvent) async{
    if(dateTimeEvent.dateTimeAction == DateTimeAction.GetStartTime){
      TimeOfDay? selectedTime = await _selectTime(dateTimeEvent.context);
      if(selectedTime != null){
        startTime = selectedTime;
        _startTimeSink.add(DateTimeUtils.timeToAmPm(selectedTime));
      }
    }
    else if(dateTimeEvent.dateTimeAction == DateTimeAction.GetEndTime){
      TimeOfDay? selectedTime = await _selectTime(dateTimeEvent.context);
      if(selectedTime != null){
        endTime = selectedTime;
        _endTimeSink.add(DateTimeUtils.timeToAmPm(selectedTime));
      }
    }
    else if(dateTimeEvent.dateTimeAction == DateTimeAction.GetDate){
      DateTime? selectedDate = await _selectDate(dateTimeEvent.context);
      if(selectedDate != null){
        date = DateTimeUtils.dateToStr(selectedDate);
        _dateSink.add(date);
      }
    }
  }

  Future<DateTime?> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));
    return pickedDate;
  }

  Future<TimeOfDay?> _selectTime(BuildContext context) async{
    TimeOfDay initialTime = TimeOfDay.now();
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );
    return pickedTime;
  }

  void dispose(){
    _eventStreamController.close();
    _dateStreamController.close();
    _endTimeStreamController.close();
    _startTimeStreamController.close();
  }

}