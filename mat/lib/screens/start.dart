import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:mat/screens/login.dart';
import 'package:mat/screens/signup.dart';
class Startpage extends StatefulWidget {
  const Startpage({super.key});

  @override
  State<Startpage> createState() => _StartpageState();
}

class _StartpageState extends State<Startpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Container(
                height: MediaQuery.of(context).size.height / 1.7,
                width: double.infinity,
                child: Padding(
                  padding: EdgeInsets.only(top: 70),
                  child: Image.asset("assets/strt.png"),
                )),
            Text(
              "Welcome Back",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "For Suggesting Life Partner Match",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(
              height: 4,
            ),
            Text(
              "Anytime, Anywhere",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(
              height: 40,
            ),

            Container(
             width: 300,

             child:  ElevatedButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage()));},

                 style: ElevatedButton.styleFrom(
                  primary: Colors.pinkAccent,

                 ),

                 child: Row(

                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     Text("Already a User ",style: TextStyle(fontSize: 14),),
                     Text("Login",style: TextStyle(fontSize: 24),),


                   ],
                 )),

           ),
            SizedBox(
              height: 10,
            ),

            Container(
              width: 300,

              child:  ElevatedButton(onPressed: (){Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Mobilesignup()));},

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("New User! ",style: TextStyle(fontSize: 14),),

                      Text("Register",style: TextStyle(fontSize: 24),),


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
