import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:schedule/BLoC/Provider/BLoCProvider.dart';
import 'package:schedule/BLoC/SchedulesBLoC.dart';
import 'package:schedule/Utils/Constants.dart';

class DayDateScrollList extends StatefulWidget{

  DayDateScrollList();
  @override
  State<StatefulWidget> createState() {
    return DayDateScrollListState();
  }
}

class DayDateScrollListState extends State<DayDateScrollList>{

  late DateTime selectedDate;

  @override
  Widget build(BuildContext context) {
    SchedulesBloc schedulesBloc = BlocProvider.of(context).schedulesBloc;
    selectedDate = schedulesBloc.selectedDate;
    return Container(
      height: 300,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 31,
        itemBuilder: (context, index) {
          String date = (index+1).toString().padLeft(2, '0');
          DateTime dateTime = DateTime.parse("2022-07-$date");
          String day = DateFormat('EEEE').format(dateTime).substring(0,3);
          return InkWell(
            onTap: (){
              setState((){
                selectedDate = dateTime;
              });
              schedulesBloc.eventSink.add(dateTime);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    day,
                    style: TextStyle(fontSize: 12),
                  ),
                  Container(
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: dateTime == selectedDate ? Color(Constants.PRIMARY_BLUE) : Colors.transparent,
                        borderRadius: BorderRadius.circular(20)
                    ),
                    child: Center(
                      child: Text(
                        "${dateTime.day}",
                        style: TextStyle(
                          color: dateTime == selectedDate ? Colors.white : Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );

  }

}
