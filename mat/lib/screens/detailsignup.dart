import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart ' as http;
import 'package:mat/main.dart';
import 'package:mat/screens/detailsignup2.dart';
class Detailsignup extends StatefulWidget {
  final  String Mobilenumber;
  const Detailsignup({Key? key, required this.Mobilenumber}) : super(key: key);

  @override
  State<Detailsignup> createState() => _DetailsignupState();
}

class _DetailsignupState extends State<Detailsignup> {


  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  final String _requiredSuffix = '@gmail.com';
  String? _emailErrorText;

  void _validateEmail(String value) {
    setState(() {
      if (value.isEmpty) {
        _emailErrorText = 'Please enter an email';
      } else if (!value.endsWith(_requiredSuffix)) {
        _emailErrorText = 'Email must end with $_requiredSuffix';
      } else {
        _emailErrorText = null;
      }
    });
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _emailController.addListener(() {
      _validateEmail(_emailController.text);
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    super.dispose();
  }


  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }






  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/back.jpg'), // Replace with your image asset path
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 20,
              ),
              Center(
                child: Text(
                  "Find exactly",
                  style: TextStyle(fontSize: 14),
                ),
              ),
              SizedBox(
                height: 2,
              ),
              Center(
                child: Text(
                  "Right Partner for you",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(
                height: 35,
              ),
              CircleAvatar(
                backgroundImage: Image.asset(
                  "assets/prof.jpg",
                  fit: BoxFit.fill,
                ).image,
                radius: 55,
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: 250,
                padding: EdgeInsets.only(left: 12,right: 12),

                child: TextField(
                  controller: _firstNameController,
                  decoration: InputDecoration(
                      labelText: 'First Name',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 2.0, color: Colors.blue),
                        borderRadius: BorderRadius.circular(25),
                      )),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Container(
                padding: EdgeInsets.only(left: 12,right: 12),
                width: 250,
                child: TextField(
                  controller: _lastNameController,
                  decoration: InputDecoration(
                      labelText: 'Last Name',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 2.0, color: Colors.blue),
                        borderRadius: BorderRadius.circular(25),
                      )),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Container(
                padding: EdgeInsets.only(left: 12,right: 12),
                width: 250,
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 2.0, color: Colors.blue),
                        borderRadius: BorderRadius.circular(25),
                      ),
                  errorText: _emailErrorText),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Container(
                padding: EdgeInsets.only(left: 12,right: 12),
                width: 250,
                child: TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 2.0, color: Colors.blue),
                        borderRadius: BorderRadius.circular(25),
                      )),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 40,
                width: 170,
                padding: EdgeInsets.only(left: 12,right: 12),

                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        disabledForegroundColor: Colors.grey,
                        foregroundColor: Color(0xff008cfe),
                        elevation: 2.0,
                        backgroundColor: Color(0x62ffffff)),
                    onPressed: () {
                      if (_firstNameController.text != null &&
                          _lastNameController.text != null &&
                          _usernameController.text != null &&
                          _emailController.text !=
                              null) if (_emailErrorText != null) {
                        _showErrorDialog(context, _emailErrorText!);
                      } else {  Navigator.pushReplacement(context,
                           MaterialPageRoute(
                             builder: (context)=>Screenno1(firtsn: _firstNameController.text,
                             lastn: _lastNameController.text,
                           usern: _usernameController.text,
                         emailn: _emailController.text,
                         mobilen: widget.Mobilenumber,)));
                      } else {
                        _showSnackBar(context, "All fields mandatory");
                      }
                    },
                    child: Text("Next",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),)),
              ),
            ],
          ),
        ),
      ),
    );

  }
}




class Screenno1 extends StatefulWidget {
  final String firtsn;
  final String lastn;
  final String emailn;
  final String usern;
  final String mobilen;

  const Screenno1({super.key,required this.firtsn,required this.lastn,required this.usern,required this.emailn,required this.mobilen});

  @override
  State<Screenno1> createState() => _Screenno1State();
}

class _Screenno1State extends State<Screenno1> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _cnfpasswordController = TextEditingController();

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/back2.jpg'), // Replace with your image asset path
            fit: BoxFit.cover,
          ),
        ),
        child:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Enter Password", style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
         SizedBox(height: 30,),
          Container(
            width: 290,
            child: TextField(
              controller: _passwordController,
              inputFormatters: [
                LengthLimitingTextInputFormatter(
                    8), // limit to 10 characters
              ],
              decoration: InputDecoration(labelText: 'Password',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(width: 2.0,color: Colors.blue),
                    borderRadius: BorderRadius.circular(25),
                  )),
              obscureText: true,
            ),
          ),
          SizedBox(height: 10,),
          Container(
            width: 290,
            child: TextField(
              controller: _cnfpasswordController,
              inputFormatters: [
                LengthLimitingTextInputFormatter(
                    8), // limit to 10 characters
              ],
              decoration: InputDecoration(labelText: 'Password',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(width: 2.0,color: Colors.blue),
                    borderRadius: BorderRadius.circular(25),
                  )),
              obscureText: false,
            ),
          ),
      Container(
        height: 40,
        width: 170,
          padding: EdgeInsets.only(left: 12,right: 12),

          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                disabledForegroundColor: Colors.blueGrey,
                foregroundColor: Color(0xff008cfe),
                elevation: 2.0,
                backgroundColor: Color(0x61ffffff)),
            onPressed: (){
            if(_cnfpasswordController.text==_passwordController.text && _passwordController!=null && _cnfpasswordController!=null){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Screen2(
                passwordn: _passwordController.text,
                firtsn: widget.firtsn,
                lastn: widget.lastn,
                usern: widget.usern,
                emailn: widget.emailn,
                mobilen: widget.mobilen,
              )));
            }
            else{
              _showSnackBar(context, "All fields mandatory");

            }
          }, child: Text("Next",style: TextStyle(fontWeight: FontWeight.bold),))
      ),
        ],
      ),)

    );
  }
}










class Screen2 extends StatefulWidget {
  final String firtsn;
  final String lastn;
  final String emailn;
  final String usern;
  final String mobilen;

  final String passwordn;
  const Screen2({super.key,required this.firtsn,required this.lastn,required this.usern,required this.mobilen,required this.emailn,required this.passwordn});

  @override
  State<Screen2> createState() => _Screen2State();
}

class _Screen2State extends State<Screen2> {
  final TextEditingController _dobController = TextEditingController();

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
  String message="";
  String _selectedgender = 'Choose Gender';



  DateTime? selectedDate; // Added for DOB
  void _showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Age Restriction'),
          content: Text(
              'You must be at least 21 years old if male or 18 years old if female.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }


  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      final int age = _calculateAge(pickedDate);

      if ((_selectedgender == "Male" && age < 21) ||
          (_selectedgender == "Female" && age < 18)) {
        _showErrorDialog(context);
      } else {
        setState(() {
          selectedDate = pickedDate;
          _dobController.text = DateFormat('yyyy-MM-dd').format(selectedDate!);
        });
      }
    }
  }

  int _calculateAge(DateTime birthDate) {
    DateTime today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
        image: DecorationImage(
        image: AssetImage('assets/back.jpg'), // Replace with your image asset path
    fit: BoxFit.cover,
    ),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 10),
          child: Text(
            "Select Gender",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 4, left: 15),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedgender = 'Male';
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: _selectedgender == 'Male'
                        ? Colors.lightGreen
                        : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.grey,
                    ),
                  ),
                  padding: const EdgeInsets.fromLTRB(4, 2, 4, 2),
                  child: Row(
                    children: [
                      Radio<String>(
                        value: 'Male',
                        groupValue: _selectedgender,
                        onChanged: (String? value) {
                          setState(() {
                            _selectedgender = value!;
                          });
                        },
                      ),
                      const Text('Male'),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 20),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedgender = 'Female';
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: _selectedgender == 'Female'
                        ? Colors.lightGreen
                        : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.grey,
                    ),
                  ),
                  padding: const EdgeInsets.fromLTRB(4, 2, 4, 2),
                  child: Row(
                    children: [
                      Radio<String>(
                        value: 'Female',
                        groupValue: _selectedgender,
                        onChanged: (String? value) {
                          setState(() {
                            _selectedgender = value!;
                          });
                        },
                      ),
                      const Text('Female'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Padding(
            padding: EdgeInsets.only(left: 10),
            child: Text(
              "Date-of-Birth",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            )),
        Padding(
          padding: EdgeInsets.only(top: 4, left: 15),
          child: Container(
            width: 300,
            child: TextField(
              controller: _dobController,
              readOnly: true,
              onTap: () => _selectDate(context),
              decoration: InputDecoration(
                  labelText: 'Date of Birth',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(width: 2.0, color: Colors.blue),
                    borderRadius: BorderRadius.circular(5),
                  )),
            ),
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Center(
            child: ElevatedButton(
                onPressed: () {
                  if (_dobController.text.isNotEmpty &&
                      _selectedgender != 'Choose Gender') {
                    DateTime? dob = selectedDate;
                    if (dob != null) {
                      final int age = _calculateAge(dob);
                      if ((_selectedgender == "Male" && age < 21) ||
                          (_selectedgender == "Female" && age < 18)) {
                        _showErrorDialog(context);
                      } else {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Screen3(
                              passwordn: widget.passwordn,
                              firtsn: widget.firtsn,
                              lastn: widget.lastn,
                              usern: widget.usern,
                              emailn: widget.emailn,
                              dobn: _dobController.text,
                              gendern: _selectedgender,
                              mobilen: widget.mobilen,
                            ),
                          ),
                        );
                      }
                    }
                  } else {
                    _showSnackBar(context, "All fields mandatory");
                  }
                },

                child: Text(
                  "Next",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )))
      ],
    ),)
    );
  }
}





class Screen3 extends StatefulWidget {
  final String firtsn;
  final String lastn;
  final String emailn;
  final String usern;
  final String mobilen;

  final String passwordn;
  final String dobn;
  final String gendern;
  const Screen3({super.key,required this.firtsn,required this.lastn,required this.usern,required this.mobilen,required this.emailn,required this.passwordn,required this.dobn,required this.gendern});

  @override
  State<Screen3> createState() => _Screen3State();
}

class _Screen3State extends State<Screen3> {
  double _selectedHeight=150;
  String _selectedReligion ="";


  String message="";


  void _showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.red,
              ),
              SizedBox(width: 10),
              Text('Error'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/error_image.png', // Replace with your error image
                height: 100,
              ),
              SizedBox(height: 10),
              Text('An error occurred. Please try again later.'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> registerUser() async {
    final apiUrl = 'http://192.168.133.76:3000/users'; // Replace with your API URL
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'firstName':  widget.firtsn,
        'lastName':  widget.lastn,
        'email':  widget.emailn,
        'username':  widget.usern,
        'mobile': widget.mobilen,
        'password':  widget.passwordn,
        'dob': widget.dobn,
        'religion': _selectedReligion,
        'gender': widget.gendern,
        'friends':'[]',
        'height':_selectedHeight.toString()
      }),
    );

    if (response.statusCode == 201) {

      setState(() {
        message = 'User registered successfully';
        Navigator.push(context, MaterialPageRoute(builder: (context)=>HobbiesPage(mob: widget.mobilen,)));

      });
    } else {
      setState(() {
        message = 'Failed to register user';
        _showErrorDialog;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
        image: DecorationImage(
        image: AssetImage('assets/back.jpg'), // Replace with your image asset path
    fit: BoxFit.cover,
    ),
    ),
    child:Padding(
      padding: EdgeInsets.only(left: 5.0, right: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 5),
            child: Text(
              "Select Religion",
              style:
              TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
          ),
          SizedBox(
            height: 4,
          ),
          Padding(
              padding: EdgeInsets.only(left: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildReligionOption('Hindu'),
                  SizedBox(width: 10),
                  _buildReligionOption('Muslim'),
                  SizedBox(width: 10),
                  _buildReligionOption('Sikh'),
                ],
              )),
          SizedBox(height: 15),
          Padding(
              padding: EdgeInsets.only(left: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildReligionOption('Christian'),
                  SizedBox(width: 10),
                  _buildReligionOption('Other'),
                ],
              )),
          SizedBox(
            height: 10,
          ),
          Text(
            'Select your height(in Cms.)',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
          ),
          Slider(
            value: _selectedHeight,
            min: 0,
            max: 221,
            divisions: 221,
            label: _selectedHeight >= 220
                ? '220+'
                : _selectedHeight.toStringAsFixed(0),
            onChanged: (double value) {
              setState(() {
                _selectedHeight = value;
              });
            },
          ),
          Center(
            child: ElevatedButton(
                onPressed: () {
                  registerUser();
                },
                child: Text(
                  "Next",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
          )
        ],
      ),
    )));
  }

  Widget _buildReligionOption(String religion) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedReligion = religion;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color:
          _selectedReligion == religion ? Colors.lightGreen : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.grey,
          ),
        ),
        padding: const EdgeInsets.fromLTRB(4, 2, 12, 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Radio<String>(
              value: religion,
              groupValue: _selectedReligion,
              onChanged: (String? value) {
                setState(() {
                  _selectedReligion = value!;
                });
              },
            ),
            Text(religion),
          ],
        ),
      ),
    );
  }
}






class HobbiesPage extends StatefulWidget {
  final  String mob;
  const HobbiesPage({Key? key, required this.mob}) : super(key: key);

  @override
  _HobbiesPageState createState() => _HobbiesPageState();
}

class _HobbiesPageState extends State<HobbiesPage> {

  List<String> selectedHobbies = [];

  List<String> allHobbies = [
    'Reading',
    'Painting',
    'Cooking',
    'Gardening',
    'Photography',
    // Add more default hobbies as needed
  ];

  TextEditingController customHobbyController = TextEditingController();
  Future<void> updateHobbies(String mobile, List<String> hobbies) async {
    final url = 'http://192.168.133.76:3000/hobbies';
    final body = jsonEncode({'mobile': mobile, 'hobbies': hobbies});

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode == 200) {
      final userId = await getUserId(mobile);



      // Hobbies updated successfully
      print('Hobbies updated successfully');
      Navigator.push(context, MaterialPageRoute(builder: (context)=> Detailsignup2(mob: widget.mob,id: userId,)));
    } else {
      // Failed to update hobbies
      print('Failed to update hobbies: ${response.body}');
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

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  'assets/back.jpg'), // Replace with your image asset path
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 4.8,
              ),
              ClipOval(
                child: Center(
                  child: Image.asset(
                    "assets/hob.png",
                    height: 100,
                    width: 100,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Center(
                child: Text(
                  "Hobbies",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 25, top: 10),
                child: Wrap(
                  spacing: 10.0,
                  runSpacing: 10.0,
                  children: allHobbies.map((hobby) {
                    final isSelected = selectedHobbies.contains(hobby);
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            selectedHobbies.remove(hobby);
                          } else {
                            selectedHobbies.add(hobby);
                          }
                        });
                      },
                      child: Container(
                        padding:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.green : Colors.grey[300],
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Text(
                          hobby,
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 10.0),
              Padding(
                  padding: EdgeInsets.only(right: 10.0, left: 25),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(right: 10.0),
                          child: TextField(
                            controller: customHobbyController,
                            decoration: InputDecoration(
                              hintText: 'Enter Custom Hobby',
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(right: 10),
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              final customHobby = customHobbyController.text.trim();
                              if (customHobby.isNotEmpty) {
                                selectedHobbies.add(customHobby);
                                customHobbyController.clear();
                              }
                            });
                          },
                          icon: Icon(Icons.check),
                        ),
                      )
                    ],
                  )),
              SizedBox(height: 10.0),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: selectedHobbies
                    .map(
                      (hobby) => Chip(
                    label: Text(hobby),
                    onDeleted: () {
                      setState(() {
                        selectedHobbies.remove(hobby);
                      });
                    },
                  ),
                )
                    .toList(),
              ),
              Center(
                  child: ElevatedButton(
                      onPressed: () {
                        updateHobbies(widget.mob, selectedHobbies);
                      },
                      child: Text("proceed")))
            ],
          ),
        ));
  }
}
