import 'package:flutter/material.dart';
import 'package:schedule/Utils/Constants.dart';

class CustomDialog{
  static void showErrorDialog(BuildContext context, String message){
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
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("$message", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xffE53935)),),
                  Text(
                    "Please modify and try again.", style: TextStyle(fontSize: 16, color: Color(Constants.PRIMARY_BLUE)),
                  ),
                  SizedBox(
                    width: 400.0,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Color(Constants.PRIMARY_BLUE))
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Okay",
                        style: TextStyle(color: Colors.white, fontSize: 16),
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