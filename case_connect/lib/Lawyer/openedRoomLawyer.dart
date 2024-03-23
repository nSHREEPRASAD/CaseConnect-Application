import 'package:case_connect/Lawyer/aboutCaseLawyer.dart';
import 'package:case_connect/Lawyer/documentLawyer.dart';
import 'package:case_connect/Lawyer/roomMembersLawyer.dart';
import 'package:flutter/material.dart';

class openedRoomLawyer extends StatefulWidget {
  var CaseName;
  openedRoomLawyer(
    this.CaseName,
  );

  @override
  State<openedRoomLawyer> createState() => _openedRoomLawyerState(CaseName);
}

class _openedRoomLawyerState extends State<openedRoomLawyer> {
  var CaseName;
  _openedRoomLawyerState(
    this.CaseName,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(CaseName.toString()),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            SizedBox(height: 50,),
            InkWell(
              child: Card(
                elevation: 5,
                child: Container(
                  height: 50,
                  width: 300,
                  child: Row(
                    children: [
                      SizedBox(width: 10,),
                      Icon(Icons.info),
                      SizedBox(width: 5,),
                      Text("About Case",style: TextStyle(fontSize: 20,),),
                    ],
                  ),
                ),
              ),
              onTap: (){
                // Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context)=>aboutCaseLawyer(CaseName)));
              },
            ),
            InkWell(
              child: Card(
                elevation: 5,
                child: Container(
                  height: 50,
                  width: 300,
                  child: Row(
                    children: [
                      SizedBox(width: 10,),
                      Icon(Icons.people),
                      SizedBox(width: 5,),
                      Text("Room Members",style: TextStyle(fontSize: 20,),),
                    ],
                  ),
                ),
              ),
              onTap: (){
                // Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context)=>roomMembersLawyer(CaseName)));
              },
            ),
            InkWell(
              child: Card(
                elevation: 5,
                child: Container(
                  height: 50,
                  width: 300,
                  child: Row(
                    children: [
                      SizedBox(width: 10,),
                      Icon(Icons.picture_as_pdf),
                      SizedBox(width: 5,),
                      Text("Documents",style: TextStyle(fontSize: 20,),),
                    ],
                  ),
                ),
              ),
              onTap: (){
                // Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context)=>documentLawyer(CaseName)));
              },
            )
          ],
        ),
      ),
    );
  }
}