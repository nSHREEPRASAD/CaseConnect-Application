import 'package:case_connect/Lawyer/pdfViewerScreenLawyer.dart';
import 'package:case_connect/Lawyer/uploadDocumentLawyer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class documentClient extends StatefulWidget {
  var CaseName;
  documentClient(
    this.CaseName,
  );
  @override
  State<documentClient> createState() => _documentClientState(CaseName);
}

class _documentClientState extends State<documentClient> {
  var CaseName;
  _documentClientState(
    this.CaseName,
  );
  @override
  Widget build(BuildContext context) {
    final _firestore = FirebaseFirestore.instance;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Documents"),
      ),
      body: StreamBuilder(
        stream: _firestore.collection("CaseRoom").doc(CaseName).collection("Documents").snapshots(), 
        builder: (context,snapshot){
          if(snapshot.hasData){
            return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context,index){
              return InkWell(
                  child: Card(
                    elevation: 5,
                    child: Container(
                      width: 300,
                      height: 200,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.picture_as_pdf,size: 140,),
                          Container(
                            width: 300,
                            height: 60,
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(snapshot.data!.docs[index]["pdfName"],style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>pdfViewerScreenLawyer(snapshot.data!.docs[index]["pdfUrl"])));
                  },
                );
              }
            );
          }
          else{
            return Center(child: CircularProgressIndicator());
          }
        }
      ),
    );
  }
}