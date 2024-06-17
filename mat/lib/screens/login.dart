
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mat/main.dart';
import 'package:mat/screens/forgotpassword.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController credential = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isEmailLogin = false;
  String message = "";
  final TextEditingController emailController = TextEditingController();
  final TextEditingController emailPasswordController = TextEditingController();



  Future<void> login(String credential, String password,BuildContext context) async {
    final apiUrl = 'http://192.168.133.76:3000/login'; // Replace with your API URL
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'credential': credential,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final userId = await getUserId(credential); // Obtain user ID

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('credential', credential); // Save credential
      await prefs.setInt('userId', userId);
      Navigator.push(context, MaterialPageRoute(builder: (context)=>MyHomePage(mobiles: credential,id_of_user: userId,)));

    } else {
      print("error");
    }
  }




  Future<void> loginemail(String email, String password,BuildContext context) async {
    final apiUrl = 'http://192.168.133.76:3000/loginem'; // Replace with your API URL
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'credential': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final userId = await getUserIdemail(email); // Obtain user ID
      final mobile = await getMobileByEmail(email);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('credential', mobile); // Save credential
      await prefs.setInt('userId', userId);
      Navigator.push(context, MaterialPageRoute(builder: (context)=>MyHomePage(mobiles: mobile.toString(),id_of_user: userId,)));

    } else {
      print("error");
    }
  }
  Future<String> getMobileByEmail(String email) async {
    final apiUrl = 'http://192.168.133.76:3000/mobileget?email=$email'; // Replace with your API URL
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData['mobile'];
    } else {
      throw Exception('Failed to fetch mobile number');
    }
  }



  Future<int> getUserId(String mobileNumber) async {
    final response = await http.get(Uri.parse('http://192.168.133.76:3100/userId/$mobileNumber'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final userId = data['userId'];
      return userId;
    } else {
      return 0;

    }
  }




  Future<int> getUserIdemail(String email) async {
    final response = await http.get(Uri.parse('http://192.168.133.76:3100/userIsd/$email'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final userId = data['userId'];
      return userId;
    } else {
      return 0;

    }
  }











  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/back.jpg'), // Replace with your image asset path
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: 40,
            ),
            ClipOval(
              child: Image.asset(
                "assets/loginsc.png",
                height: 250,
                width: 250,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                "Login",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            if (!isEmailLogin) ...[
              Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Container(
                  width: 300,
                  child: TextField(
                    controller: credential,
                    decoration: InputDecoration(
                        labelText: 'Mobile Number/Email',
                        focusColor: Colors.pinkAccent,
                        border: OutlineInputBorder(
                          borderSide:
                          BorderSide(width: 2.0, color: Colors.blue),
                          borderRadius: BorderRadius.circular(25),
                        )),
                  ),
                ),
              ),
              SizedBox(height: 5.0),
              Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Container(
                    width: 300,
                    child: TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                          labelText: 'Password',
                          focusColor: Colors.pinkAccent,
                          border: OutlineInputBorder(
                            borderSide:
                            BorderSide(width: 2.0, color: Colors.blue),
                            borderRadius: BorderRadius.circular(25),
                          )),
                      obscureText: true,
                    ),
                  )),
            ] else ...[
              Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                        hintText: 'Enter email',
                        border: OutlineInputBorder(
                          borderSide:
                          BorderSide(width: 2.0, color: Colors.blue),
                          borderRadius: BorderRadius.circular(25),
                        )),
                    keyboardType: TextInputType.emailAddress,
                  )),
              SizedBox(height: 5),
              Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: TextField(
                    controller: emailPasswordController,
                    decoration: InputDecoration(
                        hintText: 'Enter password',
                        border: OutlineInputBorder(
                          borderSide:
                          BorderSide(width: 2.0, color: Colors.blue),
                          borderRadius: BorderRadius.circular(25),
                        )),
                    obscureText: true,
                  )),
            ],
            SizedBox(height: 12.0),
            Padding(
              padding: EdgeInsets.fromLTRB(15, 4, 15, 4),
              child: ElevatedButton(
                onPressed: () {
                  if (isEmailLogin) {
                    loginemail(emailController.text,
                        emailPasswordController.text, context);
                  } else {
                    login(credential.text, _passwordController.text, context);
                  }
                },
                child: Text('Login'),
              ),
            ),
            Padding(
                padding: EdgeInsets.fromLTRB(15, 4, 15, 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          isEmailLogin = !isEmailLogin;
                        });
                      },
                      child: Text(isEmailLogin
                          ? 'Switch to Mobile Login'
                          : 'Switch to Email Login'),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 5),
                      child: TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Forgotpassword()));
                          },
                          child: Text("Forgot Password?")),
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }
}









