import 'package:case_connect/Authentication/signIn.dart';
import 'package:case_connect/Client/homePageClient.dart';
import 'package:case_connect/Lawyer/homePageLawyer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lottie/lottie.dart';

class signUp extends StatefulWidget {

  @override
  State<signUp> createState() => _signUpState();
}

class _signUpState extends State<signUp> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  bool _obscure = true;
  bool isPressed=false;
  String defVal="Lawyer";
  final key1=GlobalKey<FormState>();
  final key2=GlobalKey<FormState>();
  TextEditingController _EmailController = TextEditingController();
  TextEditingController _PasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Sign Up"),
      ),
      body: isPressed?Center(child: CircularProgressIndicator(),):
      Container(
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 30,),
              Container(
                width: 300,
                height: 200,
                child: Lottie.asset("assets/animation/LawAnimation1.json"),
              ),
              SizedBox(height: 20,),
              Container(
                width: 300,
                child: Form(
                  key: key1,
                  child: TextFormField(
                    maxLength: 35,
                    validator: (value) {
                      if(value!.isNotEmpty){
                        return null;
                      }
                      else{
                        return "Please Enter Email Address";
                      }
                    },
                    controller: _EmailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email),
                      hintText: "Email Address",
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
              Container(
                width: 300,
                child: Form(
                  key: key2,
                  child: TextFormField(
                    obscureText: _obscure,
                    validator: (value) {
                      if(value!.isNotEmpty){
                        return null;
                      }
                      else{
                        return "Please Enter Password";
                      }
                    },
                    controller: _PasswordController,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: (){
                          setState(() {
                            _obscure=!_obscure;
                          });
                        }, 
                        icon: _obscure?Icon(Icons.remove_red_eye):Icon(Icons.cancel)
                      ),
                      prefixIcon: Icon(Icons.lock),
                      hintText: "Password",
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
                child: DropdownButton(
                  value: defVal,
                  isExpanded: true,
                  items: [
                    DropdownMenuItem(
                      child: Text("Lawyer"),
                      value: "Lawyer",
                    ),
                    DropdownMenuItem(
                      child: Text("Client"),
                      value: "Client",
                    ),
                    DropdownMenuItem(
                      child: Text("Judge"),
                      value: "Judge",
                    )
                  ], 
                  onChanged: (String? newVal){
                    setState(() {
                      defVal=newVal!;
                    });
                  }
                ),
              ),
              SizedBox(height: 10,),
              Container(
                height: 40,
                child: Row(
                  children: [
                    SizedBox(width: 30,),
                    Text("Already have an Account ?"),
                    SizedBox(width: 5,),
                    TextButton(
                      onPressed: (){
                        setState(() {
                          isPressed=true;
                        });
                        Future.delayed(Duration(seconds: 1),(){
                          setState(() {
                            isPressed=false;
                          });
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>signIn()));
                        });
                      }, 
                      child: Text("Sign In")
                    )
                  ],
                ),
              ),
              SizedBox(height: 20,),
              Container(
                width: 300,
                child: ElevatedButton(
                  onPressed: (){
                    if(!key1.currentState!.validate() || !key2.currentState!.validate()){
                      return;
                    }
                    else{
                      _auth.createUserWithEmailAndPassword(
                        email: _EmailController.text.toString(), 
                        password: _PasswordController.text.toString()
                      ).then((value){  
                        _firestore.collection("User").
                          doc(_auth.currentUser!.uid.toString()).
                          set({
                            "Email":_EmailController.text.toString(),
                            "Role":defVal.toString(),
                            "Uid":_auth.currentUser!.uid.toString()
                          }).then((value){
                            if(defVal=="Lawyer"){
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>homePageLawyer()));
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Account Signed Up"),
                                  duration: Duration(seconds: 2),
                                )
                              );
                            }
                            else if(defVal=="Client"){
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>homePageClient()));
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Account Signed Up"),
                                  duration: Duration(seconds: 2),
                                )
                              );
                            }
                          });
                      }).onError((error, stackTrace){
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("User Already Exists"),
                            duration: Duration(seconds: 2),
                            backgroundColor: Colors.red,
                          )
                        );
                      });
                    }
                  }, 
                  child: Text("Sign Up")),
              )
            ],
          ),
        ),
      )
    );
  }
}