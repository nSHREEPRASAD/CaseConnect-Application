import 'package:case_connect/Lawyer/addMembersLawyer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class roomMembersLawyer extends StatefulWidget {
  var CaseName;
  roomMembersLawyer(
    this.CaseName,
  );

  @override
  State<roomMembersLawyer> createState() => _roomMembersLawyerState(CaseName);
}

class _roomMembersLawyerState extends State<roomMembersLawyer> {
  Map<String,dynamic>? LawyerMember;
  Map<String,dynamic>? ClientMember;
  Map<String,dynamic>? JudgeMember;
  var CaseName;
  _roomMembersLawyerState(
    this.CaseName,
  );
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseFirestore.instance.collection("CaseRoom").
      doc(CaseName).collection("Members").
      doc("Lawyer").get().then((value){
        setState(() {
          LawyerMember=value.data()!;
        });
      });
      FirebaseFirestore.instance.collection("CaseRoom").
      doc(CaseName).collection("Members").
      doc("Client").get().then((value){
        setState(() {
          ClientMember=value.data()!;
        });
      });
      FirebaseFirestore.instance.collection("CaseRoom").
      doc(CaseName).collection("Members").
      doc("Judge").get().then((value){
        setState(() {
          JudgeMember=value.data()!;
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    
    final _firestore=FirebaseFirestore.instance;
    
    String defVal="";
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Members"),
        actions: [
          DropdownButton(
            icon: Icon(Icons.more_vert),
            items: [
              DropdownMenuItem(
                child: Text("Add Member"),
                value: "Add Member",
              )
            ], 
            onChanged: (String? newVal){
              setState(() {
                defVal=newVal!;
              });
              if(defVal=="Add Member"){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>addMembersLawyer(CaseName)));
              }
            }
          )
        ],
      ),
      body: 
      LawyerMember!=null && ClientMember!=null && JudgeMember!=null?
      Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            Card(
              elevation: 5,
              child: Container(
                width: 320,
                height: 80,
                child: ListTile(
                  leading: CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                  title: Text("${LawyerMember!["User"]}"),
                  subtitle: Text("Role : Lawyer"),
                )
              ),
            ),
            SizedBox(height: 5,),
            ClientMember!["User"]!="Client"?
            Card(
              elevation: 5,
              child: Container(
                width: 320,
                height: 80,
                child: ListTile(
                  leading: CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                  title: Text("${ClientMember!["User"]}"),
                  subtitle: Text("Role : Client"),
                )
              ),
            ):Text(""),
            SizedBox(height: 5,),
            JudgeMember!["User"]!="Judge"?
            Card(
              elevation: 5,
              child: Container(
                width: 320,
                height: 80,
                child: ListTile(
                  leading: CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                  title: Text("${JudgeMember!["User"]}"),
                  subtitle: Text("Role : Judge"),
                )
              ),
            ):Text("")
          ],
        ),
      ):
      Center(child: CircularProgressIndicator(),)
    );
  }
}