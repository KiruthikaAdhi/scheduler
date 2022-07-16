class Schedule {
  String name;
  String startTime;
  String endTime;
  String date;
  String phoneNumber;

  Schedule({required this.name, required this.date, required this.startTime, required this.endTime, required this.phoneNumber});

  Schedule.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        startTime = json['startTime'],
        endTime = json['endTime'],
        date = json['date'],
        phoneNumber = json['phoneNumber'] ?? "";

  Map<String, dynamic> toJson() =>
      {
        'name': name,
        'startTime' : startTime,
        'endTime' : endTime,
        'date' : date,
        'phoneNumber' : phoneNumber
      };
}