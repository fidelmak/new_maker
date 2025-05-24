import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'const.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.sp),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // this is the header
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 50.sp,
                          width: 50.sp,
                          color: Colors.white,
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: AssetImage(
                              'assets/images/dummy.jpg',
                            ),
                          ),
                        ),
                        SizedBox(width: 15.sp),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            Text(
                              "Ben WHite",
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Welcome Back",
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Center(
                      child: Container(
                        height: 40.sp,
                        width: 60.sp,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(50.r)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              spreadRadius: 1,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.notifications_active_outlined,
                            size: 24.sp,
                            color: Colors.black,
                          ),
                          padding: EdgeInsets.zero,
                          constraints:
                              const BoxConstraints(), // Remove default constraints
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.sp),

              /// this is the body
              Center(
                child: Container(
                  height: 200.sp,
                  width: MediaQuery.of(context).size.width,

                  decoration: BoxDecoration(
                    color: Colors.yellow.shade800,
                    borderRadius: BorderRadius.all(Radius.circular(20.r)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        spreadRadius: 1,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16.sp),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(height: 5.sp),
                        // main row for section A
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,

                          children: [
                            Column(
                              // mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.wallet_giftcard_outlined,
                                      size: 24.sp,
                                      color: Colors.black,
                                    ),
                                    SizedBox(width: 10.sp),
                                    Text(
                                      "Your Wallet Balance",
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "\$ 34,678.00",
                                      style: TextStyle(
                                        fontSize: 36.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            // this is the right side of the section A
                            Center(
                              child: Icon(
                                Icons.qr_code,
                                size: 48.sp,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),

                        // secrion b of row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CircleImageWithText(
                              name: "balance",
                              yourIcon: Icons.attach_money,
                            ),
                            CircleImageWithText(
                              name: "add money",
                              yourIcon: Icons.wallet_giftcard_outlined,
                            ),
                            CircleImageWithText(
                              name: "send",
                              yourIcon: Icons.send,
                            ),
                            CircleImageWithText(
                              name: "receive",
                              yourIcon: Icons.call_received,
                            ),
                            CircleImageWithText(
                              name: "history",
                              yourIcon: Icons.history,
                            ),

                            ///////
                            ///
                          ],
                        ),
                      ],
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

class CircleImageWithText extends StatelessWidget {
  final String name;
  final yourIcon;
  const CircleImageWithText({
    super.key,
    required this.name,
    required this.yourIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      //crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        /// small divisions
        Center(
          child: Container(
            height: 40.sp,
            width: 40.sp,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(50.r)),
              boxShadow: [
                BoxShadow(
                  color: Colors.white,
                  blurRadius: 3,
                  spreadRadius: 1,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              onPressed: () {},
              icon: Icon(yourIcon, size: 18.sp, color: Colors.black),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(), // Remove default constraints
            ),
          ),
        ),
        SizedBox(height: 5.sp),
        Text(
          name,
          style: TextStyle(
            fontSize: getMySize(context).width * 0.03,
            //fontSize: 12.sp,
            color: Colors.black,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
