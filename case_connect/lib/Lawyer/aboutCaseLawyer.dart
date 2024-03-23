import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class aboutCaseLawyer extends StatefulWidget {
  var CaseName;
  aboutCaseLawyer(
    this.CaseName,
  );
  @override
  State<aboutCaseLawyer> createState() => _aboutCaseLawyerState(CaseName);
}

class _aboutCaseLawyerState extends State<aboutCaseLawyer> {
  final _firestore =FirebaseFirestore.instance;
  Map<String,dynamic>? CaseInfoMap;
  var CaseName;
  _aboutCaseLawyerState(
    this.CaseName,
  );
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _firestore.collection("CaseRoom").doc(CaseName).
    collection("AboutCase").doc("CaseInfo").get().then((value){
      setState(() {
        CaseInfoMap=value.data()!;
      });
    });
    
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("About Case"),
      ),
      body: 
      CaseInfoMap!=null?
      Container(
        width: double.infinity,
        height: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // SizedBox(height: 20,),
                Container(
                  width: 300,
                  height: 200,
                  child: Lottie.asset("assets/animation/AboutCaseAnimation.json"),
                ),
                // SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text("Case Type :-",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
                ),
                Card(
                  child: Container(
                    width: 300,
                    height: 50,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(CaseInfoMap!["CaseType"],style: TextStyle(fontSize: 18),),
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text("Case Description :-",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
                ),
                Card(
                  child: Container(
                    width: 300,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(CaseInfoMap!["CaseDescription"],style: TextStyle(fontSize: 18),),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ):Center(child: CircularProgressIndicator())
    );
  }
}