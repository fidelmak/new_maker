// import 'package:attendance_maker/otherUI/main_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// import 'const.dart';

// class loverScreen extends StatelessWidget {
//   const loverScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Center(
//               child: Image.asset(
//                 'assets/images/bgcartoon.png',
//                 width: 300.sp,
//                 height: 300.sp,
//               ),
//             ),
//             const Text('Lover Screen'),
//             SizedBox(height: 10.sp),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => const MainScreen()),
//                 );
//               },

//               style: ElevatedButton.styleFrom(
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10.sp),
//                 ),
//                 backgroundColor: Colors.yellow,
//                 foregroundColor: Colors.black,
//                 padding: EdgeInsets.symmetric(
//                   horizontal: getMySize(context).width / 4.sp,
//                   vertical: getMySize(context).width / 32.sp,
//                 ),
//                 textStyle: TextStyle(fontSize: 16.sp),
//               ),
//               child: Text('Visit'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:attendance_maker/otherUI/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'const.dart';

class LoverScreen extends StatelessWidget {
  const LoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Responsive image sizing
              Container(
                child: Image.asset(
                  'assets/images/bgcartoon.png',
                  fit: BoxFit.cover,
                  height: 200.h,
                  width: 200.w,
                ),
              ),

              Text(
                'Secure Transaction &'.toUpperCase(),
                style: TextStyle(
                  fontSize: getMySize(context).width / 25.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                'Reliable Service'.toUpperCase(),
                style: TextStyle(
                  fontSize: getMySize(context).width / 25.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),

              SizedBox(height: 5.h),
              Container(
                child: Column(
                  children: [
                    Text(
                      'We are here to help you with your needs.',
                      style: TextStyle(
                        fontSize: getMySize(context).width / 35.sp,
                        fontWeight: FontWeight.w200,
                        color: Colors.black87,
                        fontStyle: FontStyle.italic,
                      ),
                    ),

                    Text(
                      'Contact us for any assistance or queries.',
                      style: TextStyle(
                        fontSize: getMySize(context).width / 35.sp,
                        fontWeight: FontWeight.w200,
                        color: Colors.black87,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),

              Container(
                child: SizedBox(
                  width: double.infinity,
                  height:
                      getMySize(context).height *
                      0.08.sp, // Fixed button height
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MainScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      backgroundColor: Colors.yellow,
                      foregroundColor: Colors.black,
                    ),
                    child: Text(
                      'Continue',
                      style: TextStyle(
                        fontSize: getMySize(context).width * 0.05.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
