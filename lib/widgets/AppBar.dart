import 'package:flutter/material.dart';

class FormAppBar {
  // final String title;
  // final bool isBackBtnVisible;
  // FormAppBar({required this.title, required this.isBackBtnVisible});

 static appBar(String title, Function? function,context,bool isBackVisible){
   // return AppBar(
   //   title: Text(
   //     title,
   //     style: Theme.of(context)
   //         .textTheme
   //         .headline6!
   //         .copyWith(color: Colors.deepPurple, fontWeight: FontWeight.bold),
   //   ),
   //   toolbarHeight: 50,
   //   elevation: 1,
   //   automaticallyImplyLeading: isBackVisible,
   //   iconTheme: IconThemeData(color: Colors.deepPurple),
   //   actions: [
   //     if(function!=null)
   //       InkWell(
   //       onTap: (){
   //         function();
   //       },
   //       child: Container(
   //         margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
   //         padding: EdgeInsets.symmetric(horizontal: 5),
   //         child: Icon(
   //           Icons.clear_rounded,
   //           color: Colors.white,
   //           size: 18,
   //         ),
   //         decoration: BoxDecoration(
   //           color: Colors.deepPurple,
   //           shape: BoxShape.circle,
   //           // borderRadius: BorderRadius.circular(100),
   //         ),
   //       ),
   //     )
   //   ],
   // );
   return AppBar(
     toolbarHeight: 0,
   );
 }
 static appBar1(String title, Function? function,context,bool isBackVisible){
   return AppBar(
     title: Text(
       title,
       style: Theme.of(context)
           .textTheme
           .headline6!
           .copyWith(color: Colors.deepPurple, fontWeight: FontWeight.bold),
     ),
     toolbarHeight: 50,
     elevation: 1,
     automaticallyImplyLeading: isBackVisible,
     iconTheme: IconThemeData(color: Colors.deepPurple),
     actions: [
       if(function!=null)
         InkWell(
         onTap: (){
           function();
         },
         child: Container(
           margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
           padding: EdgeInsets.symmetric(horizontal: 5),
           child: Icon(
             Icons.clear_rounded,
             color: Colors.white,
             size: 18,
           ),
           decoration: BoxDecoration(
             color: Colors.deepPurple,
             shape: BoxShape.circle,
             // borderRadius: BorderRadius.circular(100),
           ),
         ),
       )
     ],
   );

 }
 static appBarLeft(String title, Function? function,context,bool isBackVisible){
   return AppBar(
     title: Text(
       title,
       style: Theme.of(context)
           .textTheme
           .headline6!
           .copyWith(color: Colors.deepPurple, fontWeight: FontWeight.bold),
     ),
     toolbarHeight: 50,
     elevation: 1,
     centerTitle: false,
     automaticallyImplyLeading: isBackVisible,
     iconTheme: IconThemeData(color: Colors.deepPurple),
     actions: [
       if(function!=null)
         InkWell(
         onTap: (){
           function();
         },
         child: Container(
           margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
           padding: EdgeInsets.symmetric(horizontal: 5),
           child: Icon(
             Icons.clear_rounded,
             color: Colors.white,
             size: 18,
           ),
           decoration: BoxDecoration(
             color: Colors.deepPurple,
             shape: BoxShape.circle,
             // borderRadius: BorderRadius.circular(100),
           ),
         ),
       )
     ],
   );
 }
}
