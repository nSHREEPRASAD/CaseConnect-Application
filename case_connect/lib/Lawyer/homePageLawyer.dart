import 'package:case_connect/Authentication/signUp.dart';
import 'package:case_connect/Lawyer/createRoomLawyer.dart';
import 'package:case_connect/Lawyer/openedRoomLawyer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class homePageLawyer extends StatefulWidget {
  const homePageLawyer({super.key});

  @override
  State<homePageLawyer> createState() => _homePageLawyerState();
}

class _homePageLawyerState extends State<homePageLawyer> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  // Future<List<String>> getDocumentNames(CollectionReference collectionRef) async {
  //   QuerySnapshot querySnapshot = await collectionRef.get();
  //   List<String> documentNames = [];
  //   for (DocumentSnapshot documentSnapshot in querySnapshot.docs) {
  //     documentNames.add(documentSnapshot.id);
  //   }
  //   return documentNames;
  // }
  @override
  Widget build(BuildContext context) {
    final _auth = FirebaseAuth.instance;
    final _firestore = FirebaseFirestore.instance;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Home Page"),
      ),
      drawer: Drawer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 50,),
            Card(
              elevation: 5,
              child: Container(
                width: 290,
                height: 130,
                child: Row(
                  children: [
                    Container(
                      width: 80,
                      height: 150,
                      child: Column(
                        children: [
                          SizedBox(height: 10,),
                          Container(
                            width: 70,
                            height: 70,
                            child: CircleAvatar(
                              child: Icon(Icons.person,size: 50,),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(width: 10,),
                    Container(
                      width: 180,
                      height: 150,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10,),
                          Container(
                            width: 200,
                            height: 60,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(_auth.currentUser!.email.toString()),
                                SizedBox(height: 5,),
                                Text("Role: Lawyer"),
                              ],
                            )
                          ),
                          Container(
                            width: 140,
                            child: ElevatedButton(
                              onPressed: (){
                                _auth.signOut().then((value){
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>signUp()));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Account Signed Out"),
                                      duration: Duration(seconds: 2),
                                    )
                                  );
                                });
                              }, 
                              child: Row(
                                children: [
                                  Text("Sign Out"),
                                  SizedBox(width: 10,),
                                  Icon(Icons.logout)
                                ],
                              )
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20,),
            InkWell(
              child: Card(
                elevation: 10,
                child: Container(
                  width: 180,
                  height: 60,
                  child: Row(
                    children: [
                      SizedBox(width: 10,),
                      Icon(Icons.add),
                      SizedBox(width: 5,),
                      Text("Create New Room")
                    ],
                  ),
                ),
              ),
              onTap: (){
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context)=>createRoomLawyer()));
              },
            )
          ],
        ),
      ),
      body: StreamBuilder(
        stream: _firestore.collection("Lawyer"+_auth.currentUser!.uid.toString()).snapshots(),
        builder: (context,snapshot){
          if(snapshot.hasData){
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context,index){
                return InkWell(
                  child: Card(
                    elevation: 10,
                    child: Container(
                      height: 150,
                      child: Stack(
                        children: [
                          Container(
                            height: 150,
                            width: 400,
                            child: Image.asset("assets/images/LawImage.jpg",fit: BoxFit.cover,),
                          ),
                          Positioned(
                            bottom: 20,
                            left: 10,
                            child: Text(snapshot.data!.docs[index]["CaseName"],style: TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold),),
                          )
                        ],
                      ),
                    ),
                  ),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>openedRoomLawyer(snapshot.data!.docs[index]["CaseName"])));
                  },
                );
              }
            );
          }
          else{
            return Center(child: CircularProgressIndicator());
          }
        }
      )
    );
  }
}