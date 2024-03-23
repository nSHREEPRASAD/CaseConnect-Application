import 'package:case_connect/Authentication/signUp.dart';
import 'package:case_connect/Client/homePageClient.dart';
import 'package:case_connect/Lawyer/homePageLawyer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class signIn extends StatefulWidget {
  const signIn({super.key});

  @override
  State<signIn> createState() => _signInState();
}

class _signInState extends State<signIn> {

  final _auth = FirebaseAuth.instance;
  final _firestore =FirebaseFirestore.instance;
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
        title: Text("Sign In"),
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
                child: Lottie.asset("assets/animation/LawAnimation1.json")
              ),
              SizedBox(height: 40,),
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
                      prefixIcon: Icon(Icons.lock),
                      suffixIcon: IconButton(
                        onPressed: (){
                          setState(() {
                            _obscure=!_obscure;
                          });
                        }, 
                        icon: _obscure?Icon(Icons.remove_red_eye):Icon(Icons.cancel)
                      ),
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
                height: 40,
                child: Row(
                  children: [
                    SizedBox(width: 30,),
                    Text("Dont Have An Account ?"),
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
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>signUp()));
                        });
                      }, 
                      child: Text("Sign Up")
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
                      _auth.signInWithEmailAndPassword(
                              email: _EmailController.text.toString(), 
                              password: _PasswordController.text.toString()
                            ).then((value){
                              Map<String,dynamic>?userMap={};
                              _firestore.collection("User").
                              doc(_auth.currentUser!.uid.toString()).
                              get().then((value){
                                setState(() {
                                  userMap=value.data();
                                });
                                if(userMap?["Role"]=="Lawyer"){
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>homePageLawyer()));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Account Signed In"),
                                      duration: Duration(seconds: 2),
                                    )
                                  );
                                }
                                else if(userMap?["Role"]=="Client"){
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>homePageClient()));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Account Signed In"),
                                      duration: Duration(seconds: 2),
                                    )
                                  );
                                }
                              }).onError((error, stackTrace){
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Incorrect Email Address or Password"),
                                    backgroundColor: Colors.red,
                                    duration: Duration(seconds: 2),
                                  )
                                );
                              });
                            });
                    }
                  }, 
                  child: Text("Sign In")),
              )
            ],
          ),
        ),
      )
    );
  }
}