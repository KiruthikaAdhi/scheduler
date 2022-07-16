import 'package:flutter/material.dart';
import 'package:schedule/BLoC/SchedulesBLoC.dart';

class BlocProvider extends InheritedWidget {

  final SchedulesBloc schedulesBloc;

  const BlocProvider({
    Key? key,
    required Widget child,
    required this.schedulesBloc,
  })  : assert(child != null),
        super(key: key, child: child);

  static BlocProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<BlocProvider>()!;
  }

  @override
  bool updateShouldNotify(BlocProvider old) {
    return true;
  }
}