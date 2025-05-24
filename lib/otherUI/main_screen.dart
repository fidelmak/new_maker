import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'const.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // transaction lists
  final List<Transaction> transactions = [
    Transaction(
      userName: "Ogunniran Ifedayo",
      date: "May 24, 2024",
      amount: 120.50,
      userImageUrl: "assets/images/dummy.jpg", // Local asset
    ),
    Transaction(
      userName: "Ajepe OLawale",
      date: "May 22, 2024",
      amount: -75.30,
      userImageUrl: "assets/images/bgcartoon.png", // Local asset
    ),
  ];

  void _handleDelete(Transaction transaction) {
    // Remove from database or state management
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        selectedFontSize: 12.sp,
        unselectedFontSize: 10.sp,
        selectedIconTheme: IconThemeData(
          size: 30.sp, // Set the size of the selected icon
        ),
        unselectedIconTheme: IconThemeData(
          size: 24.sp, // Set the size of the unselected icon
        ),
        currentIndex: 1, // Set the current index to the first item
        onTap: (index) {
          // Handle navigation based on index
          if (index == 0) {
            // Navigate to Home
          } else if (index == 1) {
            // Navigate to Scan
          } else if (index == 2) {
            // Navigate to Profile
          }
        },
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        showSelectedLabels: false,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 30.sp),
            activeIcon: Container(
              // Selected icon with yellow circle
              padding: EdgeInsets.all(8), // Adjust padding as needed
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.yellow.shade800, // Yellow background
              ),
              child: Icon(Icons.home, size: 30.sp), // Selected icon size
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner, size: 30.sp),
            activeIcon: Container(
              // Selected icon with yellow circle
              padding: EdgeInsets.all(8), // Adjust padding as needed
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.yellow.shade800, // Yellow background
              ),
              child: Icon(
                Icons.qr_code_scanner,
                size: 30.sp,
              ), // Selected icon size
            ),
            label: 'Scan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, size: 30.sp),
            label: 'Profile',
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.sp),
        child: SingleChildScrollView(
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
                                "Akintunde Oluborode",
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
                            borderRadius: BorderRadius.all(
                              Radius.circular(50.r),
                            ),
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
                MyContainer(
                  backgroundColor: Colors.yellow.shade800,

                  child1: // main row for section A
                      Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      Column(
                        // mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10.sp),
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CircleImageWithText(
                        name: "Balance",
                        yourIcon: Icons.attach_money,
                        backgroundColor: Colors.white,
                      ),
                      CircleImageWithText(
                        name: "Add money",
                        yourIcon: Icons.wallet_giftcard_outlined,
                        backgroundColor: Colors.white,
                      ),
                      CircleImageWithText(
                        name: "Send",
                        yourIcon: Icons.send,
                        backgroundColor: Colors.white,
                      ),
                      CircleImageWithText(
                        name: "Receive",
                        yourIcon: Icons.call_received,
                        backgroundColor: Colors.white,
                      ),
                      CircleImageWithText(
                        name: "History",
                        yourIcon: Icons.history,
                        backgroundColor: Colors.white,
                      ),

                      ///////
                      ///
                    ],
                  ),
                ),
                SizedBox(height: 20.sp),
                MyContainer(
                  backgroundColor: Colors.white,

                  child1: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            "Other Services",
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CircleImageWithText(
                            name: "Recharge",
                            yourIcon: Icons.mobile_friendly_outlined,
                            backgroundColor: Colors.white,
                          ),
                          CircleImageWithText(
                            name: "Bill Pay",
                            yourIcon: Icons.payment,

                            backgroundColor: Colors.white,
                          ),
                          CircleImageWithText(
                            name: "Bank Transfer",
                            yourIcon: Icons.account_balance,

                            backgroundColor: Colors.white,
                          ),
                          CircleImageWithText(
                            name: "Savings",
                            yourIcon: Icons.savings,

                            backgroundColor: Colors.white,
                          ),

                          ///////
                          ///
                        ],
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CircleImageWithText(
                        name: "Electricity",
                        yourIcon: Icons.lightbulb_outline,

                        backgroundColor: Colors.yellow.shade800,
                      ),
                      CircleImageWithText(
                        name: "Movie",
                        yourIcon: Icons.movie_outlined,

                        backgroundColor: Colors.yellow.shade800,
                      ),
                      CircleImageWithText(
                        name: "Add Money",
                        yourIcon: Icons.attach_money,
                        backgroundColor: Colors.yellow.shade800,
                      ),
                      CircleImageWithText(
                        name: "Others",
                        yourIcon: Icons.more_horiz,
                        backgroundColor: Colors.yellow.shade800,
                      ),

                      ///////
                      ///
                    ],
                  ),
                ),

                SizedBox(height: 20.sp),

                // Example in a ListView
                Container(
                  height: 200.sp,
                  child: TransactionList(
                    transactions: transactions,
                    onDelete: _handleDelete, // Optional
                    showSwipeActions: true, // Enable swipe-to-delete
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyContainer extends StatelessWidget {
  final Color backgroundColor;
  final Widget? child;
  final Widget? child1;
  const MyContainer({
    super.key,
    required this.backgroundColor,
    required this.child,
    required this.child1,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 200.sp,
        width: MediaQuery.of(context).size.width,

        decoration: BoxDecoration(
          color: backgroundColor,
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
              //SizedBox(height: 2.sp),
              child1 ?? Container(),
              child ?? Container(),

              // secrion b of row
            ],
          ),
        ),
      ),
    );
  }
}

class CircleImageWithText extends StatefulWidget {
  final String name;
  final Color? backgroundColor;
  final yourIcon;
  const CircleImageWithText({
    super.key,
    required this.name,
    required this.yourIcon,
    required this.backgroundColor,
  });

  @override
  State<CircleImageWithText> createState() => _CircleImageWithTextState();
}

class _CircleImageWithTextState extends State<CircleImageWithText> {
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
              color: widget.backgroundColor,
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
              icon: Icon(widget.yourIcon, size: 18.sp, color: Colors.black),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(), // Remove default constraints
            ),
          ),
        ),
        SizedBox(height: 5.sp),
        Text(
          widget.name,
          style: TextStyle(
            fontSize: 10.sp, // Slightly smaller font
            color: Colors.black,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
          maxLines: 2, // Allow text to wrap to 2 lines if needed
          overflow: TextOverflow.ellipsis, // Handle long text
        ),
      ],
    );
  }
}
// transaction history

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function(Transaction)? onDelete;
  final bool showSwipeActions;

  const TransactionList({
    Key? key,
    required this.transactions,
    this.onDelete,
    this.showSwipeActions = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return const Center(
        child: Text(
          "No transactions yet!",
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                spreadRadius: 1,
                offset: Offset(0, 2),
              ),
            ],
          ),
          margin: EdgeInsets.symmetric(vertical: 4.sp, horizontal: 4.sp),
          padding: EdgeInsets.all(8.sp),
          child: ClipRRect(child: _buildTransactionTile(transaction, context)),
        );
      },
    );
  }

  Widget _buildTransactionTile(Transaction transaction, BuildContext context) {
    final tile = ListTile(
      leading: CircleAvatar(
        backgroundImage:
            transaction.userImageUrl.startsWith('http')
                ? NetworkImage(transaction.userImageUrl)
                : AssetImage(transaction.userImageUrl) as ImageProvider,
        radius: 24.sp,
        onBackgroundImageError: (_, __) => const Icon(Icons.person),
      ),
      title: Text(
        transaction.userName,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16.sp,
          color: Colors.black,
        ),
      ),
      subtitle: Text(
        transaction.date,
        style: TextStyle(
          color: Colors.grey.shade600,
          fontSize: 12.sp,
          fontWeight: FontWeight.w400,
        ),
      ),
      trailing: Text(
        "${transaction.amount >= 0 ? '+' : '-'} \$${transaction.amount.abs().toStringAsFixed(2)}",
        style: TextStyle(
          color: transaction.amount >= 0 ? Colors.green : Colors.red,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    // Add swipe-to-delete if enabled
    return showSwipeActions && onDelete != null
        ? Slidable(
          endActionPane: ActionPane(
            motion: const DrawerMotion(),
            children: [
              SlidableAction(
                onPressed: (_) => onDelete!(transaction),
                backgroundColor: Colors.red,
                icon: Icons.delete,
                label: 'Delete',
              ),
            ],
          ),
          child: tile,
        )
        : tile;
  }
}

// transaction model

class Transaction {
  final String userName;
  final String date;
  final double amount;
  final String userImageUrl;

  const Transaction({
    required this.userName,
    required this.date,
    required this.amount,
    required this.userImageUrl,
  });
}
