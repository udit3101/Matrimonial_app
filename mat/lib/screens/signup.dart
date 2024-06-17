import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';

import 'package:mat/screens/detailsignup.dart';
class Mobilesignup extends StatefulWidget {
  const Mobilesignup({super.key});

  @override
  State<Mobilesignup> createState() => _MobilesignupState();
}

class _MobilesignupState extends State<Mobilesignup> {
  final TextEditingController mobileController = TextEditingController();
 String mobileNumber1="";
  Future<void> sendOTP(String mobileNumber) async {
    final String apiUrl = 'http://192.168.133.76:3000/sendOTP'; // Change to your API endpoint

    // Check if mobileNumber doesn't start with "+91"
    if (!mobileNumber.startsWith('+91')) {
      // Prepend "+91" to the mobile number
      mobileNumber1 = '+91' + mobileNumber;
    }

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'phoneNumber': mobileNumber1,
      }),
    );

    if (response.statusCode == 200) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => VerifyOTPPage(mobileNumber: mobileNumber)),
      );
    } else {
      // Handle error
      print('Failed to send OTP');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Center(
          child: Text("Registration"),
        )
      ),

      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/back.jpg'), // Replace with your image asset path
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

        Container(
        child: Column(children: [
          SizedBox(
          height: 50,
        ),
        Center(
          child: CircleAvatar(
            backgroundImage: Image.asset(
              "assets/auth.png",
              fit: BoxFit.fill,
            ).image,
            radius: 65,
          ),
        ),
        SizedBox(
          height: 40,
        ),
        Text(
          'Mobile No.',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 15,
        ),
            Container(
              width: 300,

              child: TextField(

                controller: mobileController,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(
                      10), // limit to 10 characters
                ],
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  prefixText: "+91",
                  labelText: 'Enter Mobile Number ',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(width: 5.0,color: Colors.blue),
                      borderRadius: BorderRadius.circular(25),
                    )
                ),
              ),
            ),

            SizedBox(height: 20),
        Container(
          height: 40,
          width: 170,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                disabledForegroundColor: Colors.blueGrey,
                foregroundColor: Color(0xff008cfe),
                elevation: 2.0,
                backgroundColor: Color(0x61ffffff)),

              onPressed: () => sendOTP(mobileController.text),
              child: Text('Send OTP',style: TextStyle(fontWeight: FontWeight.bold),),
            ),
          )
          ],
        ),
      ),


            Container(
              padding: EdgeInsets.only(bottom: 7.0),
              child: Column(children: [
                Center(
                  child: Text(
                    'By creating account you agree',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                Center(
                  child: Text(
                    ' to our policy and T&C ',
                    style: TextStyle(fontSize: 14),
                  ),
                )
              ]),
            )
          ],
        ),
      ));
  }
}









class VerifyOTPPage extends StatefulWidget {
  final String mobileNumber;

  VerifyOTPPage({required this.mobileNumber});

  @override
  _VerifyOTPPageState createState() => _VerifyOTPPageState();
}

class _VerifyOTPPageState extends State<VerifyOTPPage> {
  final TextEditingController otpController = TextEditingController();

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
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Detailsignup(Mobilenumber: widget.mobileNumber)),
      );
    } else {
      // Handle error
      print('Invalid OTP');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Verify OTP'),
        )
      ),
      body:  Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/back.jpg'), // Replace with your image asset path
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            Center(
              child: CircleAvatar(
                backgroundImage: Image.asset(
                  "assets/auth.png",
                  fit: BoxFit.fill,
                ).image,
                radius: 65,
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Text(
              'Enter OTP sent to ${widget.mobileNumber}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Container(
              width: 300,
              child: TextField(
                controller: otpController,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(
                      10), // limit to 10 characters
                ],
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: 'Enter OTP',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(width: 2.0, color: Colors.blue),
                      borderRadius: BorderRadius.circular(25),
                    )),
              ),
            ),
            SizedBox(height: 20),
            Container(
              height: 40,
              width: 170,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    disabledForegroundColor: Colors.blueGrey,
                    foregroundColor: Color(0xff008cfe),
                    elevation: 2.0,
                    backgroundColor: Color(0x61ffffff)),
                onPressed: () => verifyOTP(otpController.text),
                child: Text('Verify OTP',style: TextStyle(fontWeight: FontWeight.bold),),
              ),
            ),
          ],
        ),
      )
    );
  }
}


