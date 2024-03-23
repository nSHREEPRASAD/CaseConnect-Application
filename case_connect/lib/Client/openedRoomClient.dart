import 'package:case_connect/Client/documentClient.dart';
import 'package:case_connect/Lawyer/documentLawyer.dart';
import 'package:case_connect/Lawyer/roomMembersLawyer.dart';
import 'package:flutter/material.dart';

class openedRoomClient extends StatefulWidget {
  var CaseName;
  openedRoomClient(
    this.CaseName,
  );

  @override
  State<openedRoomClient> createState() => _openedRoomClientState(CaseName);
}

class _openedRoomClientState extends State<openedRoomClient> {
  var CaseName;
  _openedRoomClientState(
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
              child: Card(elevation: 5,
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
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context)=>documentClient(CaseName)));
              },
            )
          ],
        ),
      ),
    );
  }
}