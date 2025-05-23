import 'package:attendance_maker/otherUI/new.dart';
import 'package:attendance_maker/provider/student_provider.dart';
import 'package:attendance_maker/screens/screen1.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => StudentProvider())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, context) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: LoverScreen(),
        );
      },
    );
  }
}
