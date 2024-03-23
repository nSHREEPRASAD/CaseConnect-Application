import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class createRoomLawyer extends StatelessWidget {
  const createRoomLawyer({super.key});

  @override
  Widget build(BuildContext context) {
    final _auth=FirebaseAuth.instance;
    final _firestore=FirebaseFirestore.instance;
    final key1=GlobalKey<FormState>();
    final key2=GlobalKey<FormState>();
    final key3=GlobalKey<FormState>();
    TextEditingController _RNameController = TextEditingController();
    TextEditingController _CaseTypeController = TextEditingController();
    TextEditingController _CaseDescriptionController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Create New Room"),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20,),
              Container(
                width: 300,
                height: 200,
                child: Lottie.asset("assets/animation/CreateCaseRoomAnimation.json"),
              ),
              SizedBox(height: 30,),
              Container(
                  width: 300,
                  child: Form(
                    key: key1,
                    child: TextFormField(
                      validator: (value) {
                        if(value!.isNotEmpty){
                          return null;
                        }
                        else{
                          return "Please Enter Room Name";
                        }
                      },
                      controller: _RNameController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.room),
                        hintText: "Room Name",
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11),
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 2,
                          )
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11),
                          borderSide: BorderSide(
                            color: Colors.black,
                            width: 2,
                          )
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11),
                          borderSide: BorderSide(
                            color: Colors.red,
                            width: 2,
                          )
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                Container(
                  width: 300,
                  child: Form(
                    key: key2,
                    child: TextFormField(
                      validator: (value) {
                        if(value!.isNotEmpty){
                          return null;
                        }
                        else{
                          return "Please Enter Case Type";
                        }
                      },
                      controller: _CaseTypeController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.type_specimen_sharp),
                        hintText: "Case Type",
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11),
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 2,
                          )
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11),
                          borderSide: BorderSide(
                            color: Colors.black,
                            width: 2,
                          )
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11),
                          borderSide: BorderSide(
                            color: Colors.red,
                            width: 2,
                          )
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                Container(
                  width: 300,
                  child: Form(
                    key: key3,
                    child: TextFormField(
                      maxLines: 2,
                      validator: (value) {
                        if(value!.isNotEmpty){
                          return null;
                        }
                        else{
                          return "Please Enter Case Description";
                        }
                      },
                      controller: _CaseDescriptionController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.description),
                        hintText: "Case Description",
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11),
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 2,
                          )
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11),
                          borderSide: BorderSide(
                            color: Colors.black,
                            width: 2,
                          )
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11),
                          borderSide: BorderSide(
                            color: Colors.red,
                            width: 2,
                          )
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Container(
                  width: 300,
                  child: ElevatedButton(
                      onPressed: (){
                        if(!key1.currentState!.validate() || !key2.currentState!.validate() || !key3.currentState!.validate()){
                          return;
                        }
                        else{
                          String CollectionName="Lawyer"+_auth.currentUser!.uid.toString();
                          _firestore.collection(CollectionName).
                          doc().
                          set({
                            "CaseName":_RNameController.text.toString()
                          }).then((value){
                            _firestore.collection("CaseRoom").
                            doc(_RNameController.text.toString()).
                            collection("Members").
                            doc("Lawyer").
                            set({
                              "User":_auth.currentUser!.email.toString(),
                            });
                            _firestore.collection("CaseRoom").
                            doc(_RNameController.text.toString()).
                            collection("Members").
                            doc("Client").
                            set({
                              "User":"Client",
                            });
                            _firestore.collection("CaseRoom").
                            doc(_RNameController.text.toString()).
                            collection("Members").
                            doc("Judge").
                            set({
                              "User":"Judge",
                            });
                            _firestore.collection("CaseRoom").
                            doc(_RNameController.text.toString()).
                            collection("AboutCase").doc("CaseInfo").set({
                              "CaseType":_CaseTypeController.text.toString(),
                              "CaseDescription":_CaseDescriptionController.text.toString()
                            });
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("CaseRoom Created  Successfully"),
                                backgroundColor: Colors.green,
                                duration: Duration(seconds: 2),
                              )
                            );
                          });
                        }
                      }, 
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add),
                          SizedBox(width: 5,),
                          Text("Create Case Room"),
                        ],
                      )),
                ),
            ],
          ),
        ),
      ),
    );
  }
}