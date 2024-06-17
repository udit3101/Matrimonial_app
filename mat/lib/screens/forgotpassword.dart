import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:mat/screens/login.dart';
class Forgotpassword extends StatefulWidget {
  const Forgotpassword({super.key});

  @override
  State<Forgotpassword> createState() => _ForgotpasswordState();
}

class _ForgotpasswordState extends State<Forgotpassword> {
  TextEditingController _mob=TextEditingController();
  TextEditingController _otp=TextEditingController();
  bool isFirstFieldActive = true;


  Future<void> sendOTP(String mobileNumber) async {
    final String apiUrl = 'http://192.168.133.76:3000/sendOTP'; // Change to your API endpoint

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'phoneNumber': mobileNumber,
      }),
    );

    if (response.statusCode == 200) {
     print("sent otp");
    } else {
      // Handle error
      print('Failed to send OTP');
    }
  }





  Future<void> verifyOTP(String otp) async {
    final String apiUrl = 'http://192.168.133.76:3000/verifyOTP'; // Change to your API endpoint

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'otp': otp,
        'enteredOTP': otp,
      }),
    );

    if (response.statusCode == 200) {
      print("verified");
      Navigator.push(context, MaterialPageRoute(builder: (context)=>Resetpassword(Mobil: _mob.text,)));
    } else {
      // Handle error
      print('Invalid OTP');
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Forgot Password"),),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(

            children: [
              SizedBox(
                height: 130,
              ),

                  CircleAvatar(
                    backgroundImage: Image.asset("assets/forgot.png" ,fit: BoxFit.fill,
                    ).image,
                    radius: 60,
                  ),

              SizedBox(height: 30,),
              TextField(controller: _mob,
                decoration: InputDecoration(
                    labelText: 'Mobile Number/Email',
                    focusColor: Colors.pinkAccent,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(width: 2.0, color: Colors.blue),
                      borderRadius: BorderRadius.circular(25),
                    )),
                enabled: isFirstFieldActive,),
              SizedBox(height: 5,),
              TextField(controller: _otp,
                decoration: InputDecoration(
                    labelText: 'Mobile Number/Email',
                    focusColor: Colors.pinkAccent,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(width: 2.0, color: Colors.blue),
                      borderRadius: BorderRadius.circular(25),
                    )),
                enabled: !isFirstFieldActive,),
              SizedBox(height: 5,),
              ElevatedButton(
                onPressed: () {


                  if (isFirstFieldActive) {
                    sendOTP(_mob.text);
                    setState(() {
                      isFirstFieldActive=false;
                    });
                  } else {
                    // Navigate to other page when button is pressed after entering data in the second field
                    verifyOTP(_otp.text);

                  }

                },
                child: Text(isFirstFieldActive ? 'Send OTP' : 'Verify'),
              ),

            ],
          ),
        ),
      )
    );
  }
}


class Resetpassword extends StatefulWidget {
  final String Mobil;
  const Resetpassword({super.key,required this.Mobil});

  @override
  State<Resetpassword> createState() => _ResetpasswordState();
}

class _ResetpasswordState extends State<Resetpassword> {
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController cnfnewPasswordController = TextEditingController();

  String message = '';


  Future<void> resetPassword(String mobileNumber, String newPassword) async {
    final apiUrl = 'http://192.168.133.76:3000/reset-password'; // Change it to your API URL
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'mobileNumber': mobileNumber,
        'newPassword': newPassword,
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        message = 'Password updated successfully';
        Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage()));
      });
    } else if (response.statusCode == 404) {
      setState(() {
        message = 'User not found';
      });
    } else {
      setState(() {
        message = 'Failed to update password';
      });
    }
  }






  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Reset Password"),),
      ),
      body:SingleChildScrollView(
        child:  Container(
          height: double.infinity,
          child: Column(

            children: [
              SizedBox(
                height: 130,
              ),

              CircleAvatar(
                backgroundImage: Image.asset("assets/forgot.png" ,fit: BoxFit.fill,
                ).image,
                radius: 60,
              ),

              SizedBox(height: 30,),
              TextField(
                controller: newPasswordController,
                decoration: InputDecoration(labelText: 'New Password'),
              ),
              TextField(
                controller: cnfnewPasswordController,
                decoration: InputDecoration(labelText: 'New Password'),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  String text1 = newPasswordController.text;
                  String text2 = cnfnewPasswordController.text;
                  if(text1==text2){
                    resetPassword(
                      widget.Mobil,
                      newPasswordController.text,
                    );
                  }
                  else{
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Passwprd Mismatch'),
                        )
                    );
                  }
                },
                child: Text('Reset Password'),
              ),
              SizedBox(height: 20.0),

            ],
          ),
        ),
      )
    );
  }
}
