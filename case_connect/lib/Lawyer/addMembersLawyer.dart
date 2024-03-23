import 'package:case_connect/Lawyer/openedRoomLawyer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class addMembersLawyer extends StatefulWidget {
  var CaseName;
  addMembersLawyer(
    this.CaseName,
  );

  @override
  State<addMembersLawyer> createState() => _addMembersLawyerState(CaseName);
}

class _addMembersLawyerState extends State<addMembersLawyer> {
  var CaseName;
  _addMembersLawyerState(
    this.CaseName,
  );
  Map<String,dynamic>userMap={};
  Map<String,dynamic>memberMap={};
  @override
  Widget build(BuildContext context) {
    final key = GlobalKey<FormState>();
    TextEditingController _SearchController = TextEditingController();
    final _firestore = FirebaseFirestore.instance;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Add Members"),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            SizedBox(height: 30,),
            Container(
              width: 300,
              child: Form(
                key: key,
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: _SearchController,
                  validator: (value) {
                    if(value!.isNotEmpty){
                      return null;
                    }
                    else{
                      return "Please Search the Member";
                    }
                  },
                  decoration: InputDecoration(
                    hintText: "Search",
                    suffixIcon: IconButton(
                      onPressed: (){
                        if(!key.currentState!.validate()){
                          return;
                        }
                        else{
                          _firestore.collection("User").
                          where("Email",isEqualTo: _SearchController.text.toString()).
                          get().then((value){
                            setState(() {
                              userMap=value.docs[0].data();
                            });
                            _SearchController.clear();
                          }).then((value) async{
                            if(userMap["Role"]=="Lawyer"){
                              setState(() {
                                userMap={};
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Another Lawyer can not be added"),
                                  backgroundColor: Colors.red,
                                  duration: Duration(seconds: 2),
                                )
                              );
                            }
                            else if(userMap["Role"]=="Client"){
                              _firestore.collection("CaseRoom").doc(CaseName).
                              collection("Members").doc("Client").get().then((value){
                                setState(() {
                                  memberMap=value.data()!;
                                });
                                if(memberMap["User"]!="Client"){ 
                                  setState(() {
                                    userMap={};
                                    memberMap={};
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Another Client Cannot be added"),
                                      backgroundColor: Colors.red,
                                      duration: Duration(seconds: 2),
                                    )
                                  );
                                }
                              }); 
                            }
                            else if(userMap["Role"]=="Judge"){
                              _firestore.collection("CaseRoom").doc(CaseName).
                              collection("Members").doc("Judge").get().then((value){
                                setState(() {
                                  memberMap=value.data()!;
                                });
                                if(memberMap["User"]!="Judge"){ 
                                  setState(() {
                                    userMap={};
                                    memberMap={};
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Another Judge Cannot be added"),
                                      backgroundColor: Colors.red,
                                      duration: Duration(seconds: 2),
                                    )
                                  );
                                }
                              }); 
                            }
                          }).
                          onError((error, stackTrace){
                            setState(() {
                              userMap={};
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("No Such User"),
                                backgroundColor: Colors.red,
                                duration: Duration(seconds: 2),
                              )
                            );
                          });
                        }
                      }, 
                      icon: Icon(Icons.search)
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 2
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 2
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        color: Colors.red,
                        width: 2
                      ),
                    )
                  ),
                )
              ),
            ),
            SizedBox(height: 50,),
            userMap.isNotEmpty?
            Card(
              child: Container(
                child: ListTile(
                  leading: CircleAvatar(child: Icon(Icons.person)),
                  title: Text(userMap["Email"]),
                  subtitle: Text("Role : ${userMap["Role"]}"),
                  trailing: IconButton(
                    onPressed: (){
                      if(userMap["Role"]=="Client"){
                        _firestore.collection("CaseRoom").
                        doc(CaseName).collection("Members").
                        doc("Client").update({
                          "User": userMap["Email"],
                        }).whenComplete((){
                          String userEmail=userMap["Email"].toString();
                          String _CollectionName="Client"+userMap["Uid"];
                          _firestore.collection(_CollectionName).doc().set({
                            "CaseName":CaseName
                          }).whenComplete((){
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>openedRoomLawyer(CaseName)));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("${userEmail} Added"),
                                backgroundColor: Colors.green,
                                duration: Duration(seconds: 2),
                              )
                            );
                          });
                        });
                      }
                      else if(userMap["Role"]=="Judge"){
                        _firestore.collection("CaseRoom").
                        doc(CaseName).collection("Members").
                        doc("Judge").update({
                          "User": userMap["Email"],
                        }).whenComplete((){
                          String userEmail=userMap["Email"].toString();
                          String _CollectionName="Judge"+userMap["Uid"];
                          _firestore.collection(_CollectionName).doc().set({
                            "CaseName":CaseName
                          }).whenComplete((){
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>openedRoomLawyer(CaseName)));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("${userEmail} Added"),
                                backgroundColor: Colors.green,
                                duration: Duration(seconds: 2),
                              ) 
                            );
                          });
                        });
                      }
                    }, 
                    icon: Icon(Icons.add)
                  ),
                ),
              ),
            ):
            Container()
          ],
        ),
      ),
    );
  }
}