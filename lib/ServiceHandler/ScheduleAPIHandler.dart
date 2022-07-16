import 'dart:convert';
import 'package:schedule/Utils/Constants.dart';
import 'package:schedule/Data/Schedule.dart';
import 'package:http/http.dart' as http;

class ScheduleAPIHandler{
  Future<void> saveSchedule(Schedule schedule) async{
    await http.post(
      Uri.parse('https://alpha.classaccess.io/api/challenge/v1/save/schedule'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(schedule),
    );
  }

  Future<List<Schedule>> getSchedules() async{
    final response = await http.get(Uri.parse('https://alpha.classaccess.io/api/challenge/v2/schedule/${Constants.PHONE_NUMBER}'));
    if(response.statusCode == 200){
      List data = jsonDecode(response.body)["data"];
      List<Schedule> scheduleList= data.map((e) => Schedule.fromJson(e)).toList();
      return scheduleList;
    }
    return [];
  }

}