
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

class uploadDocumentLawyer extends StatefulWidget {
  var CaseName;
  uploadDocumentLawyer(
    this.CaseName,
  );

  @override
  State<uploadDocumentLawyer> createState() => _uploadDocumentLawyerState(CaseName);
}

class _uploadDocumentLawyerState extends State<uploadDocumentLawyer> {
  bool isChosen=false;
  String pdfName="";
  String pdfPath="";
  String pdfUrl="";
  bool isClicked=false;
  var CaseName;
  _uploadDocumentLawyerState(
    this.CaseName,
  );
  @override
  Widget build(BuildContext context) {
    final _firestore = FirebaseFirestore.instance;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Upload Document"),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            SizedBox(height: 40,),
            isChosen==false?
            InkWell(
              child: Card(
                color: Colors.grey,
                child: Container(
                  width: 300,
                  height: 240,
                  child: Lottie.asset("assets/animation/uploadPdfAnimation.json")
                ),
              ),
              onTap: ()async{
                var pickedFile=await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ["pdf"],
                );
                if(pickedFile!=null){
                  setState(() {
                    isChosen=true;
                  });
                  pdfName=pickedFile.files[0].name;
                  pdfPath=pickedFile.files[0].path!;
                }
              },
            ):
            Card(
              color: Colors.grey,
              child: Container(
                width: 300,
                height: 240,
                child: Stack(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.picture_as_pdf,size: 170,),
                      ],
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: IconButton(
                        onPressed: (){
                          setState(() {
                            isChosen=false;
                          });
                        }, 
                        icon: Icon(Icons.cancel,size: 40,)
                      )
                    ),
                    Positioned(
                      bottom: 0,
                      child: Container(
                        width: 300,
                        height: 70,
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(pdfName,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ),
            ),
            SizedBox(height: 50,),
            Container(
              width: 200,
              height: 60,
              child: ElevatedButton(
                onPressed: ()async{
                  Reference ref = FirebaseStorage.instance.ref().
                  child("pdfs").child(pdfName);
                  try{
                    if(isChosen==true){
                      setState(() {
                        isClicked=true;
                      });
                      Future.delayed(Duration(seconds: 8),(){
                        setState(() {
                          isClicked=false;
                        });
                      });
                      await ref.putFile(File(pdfPath));
                    pdfUrl=await ref.getDownloadURL();
                    _firestore.collection("CaseRoom").doc(CaseName).
                      collection("Documents").doc().set({
                        "pdfName":pdfName,
                        "pdfUrl":pdfUrl,
                      }).whenComplete((){
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Document Uploaded Successfully"),
                            backgroundColor: Colors.green,
                            duration: Duration(seconds: 2),
                          )
                        );
                      });
                    }
                    else{
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Please Select the pdf File"),
                          duration: Duration(seconds: 2),
                        )
                      );
                    }
                  }
                  catch(e){
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Please Select the pdf File"),
                        duration: Duration(seconds: 2),
                      )
                    );
                  }
                }, 
                child: 
                isClicked==true?
                Center(child: CircularProgressIndicator(),):
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.upload_file),
                    SizedBox(width: 5,),
                    Text("Upload Pdf")
                  ],
                )
              ),
            )
          ],
        ),
      ),
    );
  }
}