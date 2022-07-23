// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:listview_in_blocpattern/Groups/GroupList.dart';

// import 'package:listview_in_blocpattern/home_page.dart';

// class BottomNavigation extends StatefulWidget {
//   const BottomNavigation({Key? key}) : super(key: key);

//   @override
//   State<BottomNavigation> createState() => _BottomNavigationState();
// }

// class _BottomNavigationState extends State<BottomNavigation> {
//   int currentIndex = 0;
//   final screen = [
//     HomePage(),GroupList()
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
      
//       body: IndexedStack(
//         index:currentIndex,
//         children: screen),

//       bottomNavigationBar: BottomNavigationBar(
        
//         type: BottomNavigationBarType.shifting,
//         currentIndex: currentIndex,
//         onTap: (index) => setState(() => currentIndex = index),
//         iconSize: 20,
//         items: const [
//           BottomNavigationBarItem(
//               icon: Icon(Icons.home),
//               label: 'Home',
//               backgroundColor: Color.fromARGB(255, 109, 124, 52)),
//           BottomNavigationBarItem(
//               icon: Icon(Icons.group_rounded),
//               label: 'Groups',
//               backgroundColor: Color.fromARGB(212, 219, 66, 194)),
//         ],
//       ),
//     );
//   }
// }
