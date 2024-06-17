import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart ' as http;
import 'package:mat/main.dart';
import 'login.dart';

class Detailsignup2 extends StatefulWidget {
  final  String mob;
  final int id;
  const Detailsignup2({Key? key, required this.mob,required this.id}) ;

  @override
  State<Detailsignup2> createState() => _Detailsignup2State();
}

class _Detailsignup2State extends State<Detailsignup2> {
  String _educatuion = 'Choose Education';
  List<String> _educationlist = [
    'Technical School',
    'High School',
    'Bachelors',
    'Masters',
    'MBBS',
    'Associates',
    'PhD',
    'CA/ACCA',
    'Other'
  ];

  String _profession = 'Choose Profession';
  List<String> _professionlist = [
    'Engineer',
    'Lawyer',
    'Manager',
    'Doctor',
    'Teacher',
    'Banker',
    'Other'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    'assets/back.jpg',
                  ),
                  // Replace with your image asset path
                  fit: BoxFit.fill,
                ),
              ),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 10,
                  ),
                  Text(
                    "Education",
                    style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  _buildEducationOptions(),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Proffesion",
                    style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  _buildprofessionoption(),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DetailSignup12(
                                  mob: widget.mob,
                                  id: widget.id,
                                  edu: _educatuion,
                                  prof: _profession,
                                )));
                      },
                      child: Text("submit"))
                ],
              ),
            )));
  }

  Widget _buildEducationOptions() {
    return Wrap(
      spacing: 10.0,
      runSpacing: 10.0,
      children: _educationlist.map((education) {
        return GestureDetector(
          onTap: () {
            setState(() {
              _educatuion = education;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color:
              _educatuion == education ? Colors.lightGreen : Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.grey,
              ),
            ),
            padding: const EdgeInsets.fromLTRB(2, 2, 8, 2),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Radio<String>(
                  value: education,
                  groupValue: _educatuion,
                  onChanged: (String? value) {
                    setState(() {
                      _educatuion = value!;
                    });
                  },
                ),
                Text(education),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildprofessionoption() {
    return Wrap(
      spacing: 10.0,
      runSpacing: 10.0,
      children: _professionlist.map((profession) {
        return GestureDetector(
          onTap: () {
            setState(() {
              _profession = profession;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color:
              _profession == profession ? Colors.lightGreen : Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.grey,
              ),
            ),
            padding: const EdgeInsets.fromLTRB(4, 2, 4, 2),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Radio<String>(
                  value: profession,
                  groupValue: _profession,
                  onChanged: (String? value) {
                    setState(() {
                      _profession = value!;
                    });
                  },
                ),
                Text(profession),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}





class DetailSignup12 extends StatefulWidget {
  final String mob;
  final int id;
  final String edu;
  final String prof;
  const DetailSignup12(
      {Key? key,
        required this.mob,
        required this.id,
        required this.edu,
        required this.prof});

  @override
  State<DetailSignup12> createState() => _DetailSignup12State();
}

class _DetailSignup12State extends State<DetailSignup12> {
  TextEditingController _place = TextEditingController();

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
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Where do you Live?",
                  style: TextStyle(fontSize: 24),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 7, 10, 8),
                  child: TextField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(width: 5.0, color: Colors.blue),
                          borderRadius: BorderRadius.circular(25),
                        )),
                    controller: _place,
                  ),
                ),
                ElevatedButton(
                    onPressed: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DetailSignup21(
                                mob: widget.mob,
                                id: widget.id,
                                edu: widget.edu,
                                prof: widget.prof,
                                plc: _place.text,
                              )));
                    },
                    child: Text("submit"))
              ],
            )));
  }
}




class DetailSignup21 extends StatefulWidget {
  final  String mob;
  final int id;
  final String edu;
  final String prof;
  final String plc;
  const DetailSignup21({Key? key, required this.mob,required this.id,required this.edu,required this.prof,required this.plc}) ;

  @override
  State<DetailSignup21> createState() => _DetailSignup21State();
}

class _DetailSignup21State extends State<DetailSignup21> {
  String _diet = 'Choose Diet';
  List<String> _dietlist = [
    'Veg',
    'Non-Veg',
  ];


  String _drink = 'Choose Drink';
  List<String> _drinklist = [
   'Often',
    'Ocassionally',
    'Never',
  ];


  String _smoke = 'Choose Smoke frequency';
  List<String> _smokelist = [
    'Smoke Often',
    'Never Smoke',
    'Casual'
  ];



  String message="";

  Future<void> registerUserdet(String education,String place,String profession, String diet,String drink,String smoke) async {
    final apiUrl = 'http://192.168.133.76:3000/userdetails'; // Replace with your API URL
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{

        'mobile':widget.mob,
        'education':education,
        'placeOfBirth':place,
        'profession':profession,
        'diet':diet,
        'drink':drink,
        'smoke':smoke

      }),
    );

    if (response.statusCode == 201) {


      print("success");


    } else {
      setState(() {
        message = 'Failed to register user';

      });
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 30,
              ),
              Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipOval(
                        child: Image.asset(
                          "assets/french-fries.png",
                          height: 40,
                          width: 40,
                        ),
                      ),
                      Text(
                        "Diet-Preferences",
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ],
                  )),
              Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Wrap(
                    children: [_builddiets()],
                  )),
              SizedBox(
                height: 20,
              ),
              Center(
                  child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    ClipOval(
                      child: Image.asset(
                        "assets/cigg.png",
                        height: 40,
                        width: 40,
                      ),
                    ),
                    SizedBox(
                      width: 3,
                    ),
                    Text("Do you Smoke?",
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  ])),
              Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Wrap(
                    children: [_buildsmokes()],
                  )),
              SizedBox(
                height: 20,
              ),
              Center(
                  child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    ClipOval(
                      child: Image.asset(
                        "assets/glass.png",
                        height: 30,
                        width: 30,
                      ),
                    ),
                    SizedBox(
                      width: 3,
                    ),
                    Text("Drinking Frequency",
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  ])),
              Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Wrap(
                    children: [_builddrinks()],
                  )),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: () async {
                    print("button tsap");
                    registerUserdet(
                        widget.edu, widget.plc, widget.prof, _diet, _drink, _smoke);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                UploadImagePage(mob: widget.mob, id: widget.id)));
                  },
                  child: Text("submit"))
            ],
          ),
        ));
  }

  Widget _builddiets() {
    return Wrap(
      spacing: 10.0,
      runSpacing: 10.0,
      children: _dietlist.map((diet) {
        return GestureDetector(
          onTap: () {
            setState(() {
              _diet = diet;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: _diet == diet ? Colors.lightGreen : Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.grey,
              ),
            ),
            padding: const EdgeInsets.fromLTRB(2, 2, 8, 2),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Radio<String>(
                  value: diet,
                  groupValue: _diet,
                  onChanged: (String? value) {
                    setState(() {
                      _diet = value!;
                    });
                  },
                ),
                Text(diet),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildsmokes() {
    return Wrap(
      spacing: 10.0,
      runSpacing: 10.0,
      children: _smokelist.map((smoke) {
        return GestureDetector(
          onTap: () {
            setState(() {
              _smoke = smoke;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: _smoke == smoke ? Colors.lightGreen : Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.grey,
              ),
            ),
            padding: const EdgeInsets.fromLTRB(2, 2, 8, 2),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Radio<String>(
                  value: smoke,
                  groupValue: _smoke,
                  onChanged: (String? value) {
                    setState(() {
                      _smoke = value!;
                    });
                  },
                ),
                Text(smoke),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _builddrinks() {
    return Wrap(
      spacing: 10.0,
      runSpacing: 10.0,
      children: _drinklist.map((drink) {
        return GestureDetector(
          onTap: () {
            setState(() {
              _drink = drink;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: _drink == drink ? Colors.lightGreen : Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.grey,
              ),
            ),
            padding: const EdgeInsets.fromLTRB(2, 2, 8, 2),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Radio<String>(
                  value: drink,
                  groupValue: _drink,
                  onChanged: (String? value) {
                    setState(() {
                      _drink = value!;
                    });
                  },
                ),
                Text(drink),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class UploadImagePage extends StatefulWidget {
  final String mob;
  final int id;
  const UploadImagePage({Key? key, required this.mob,required this.id}) ;


  @override
  _UploadImagePageState createState() => _UploadImagePageState();
}

class _UploadImagePageState extends State<UploadImagePage> {
  final TextEditingController _textController = TextEditingController();
  File? _image;

  Future<void> _getImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedImage != null) {
        _image = File(pickedImage.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _uploadData(String mobile, String text, File? imageFile) async {
    var uri = Uri.parse('http://192.168.133.76:3000/uploaddet');
    var request = http.MultipartRequest('POST', uri);
    request.fields['mobile'] = mobile;
    request.fields['text'] = text;
    if (imageFile != null) {
      request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));
    }

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        print('Data uploaded successfully');
      } else {
        print('Failed to upload data: ${response.reasonPhrase}');
      }
    } catch (error) {
      print('Error uploading data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/back.jpg'), // Replace with your image asset path
                fit: BoxFit.cover,
              ),
            ),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 10,
                ),
                GestureDetector(
                  onTap: _getImage,
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[200],
                      border: Border.all(width: 2.0, color: Colors.black),
                    ),
                    child: _image != null
                        ? Image.file(
                      _image!,
                      fit: BoxFit.cover,
                    )
                        : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_a_photo),
                            Text("Add Profile Image")
                          ],
                        )),
                  ),
                ),
                SizedBox(height: 16.0),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: TextField(
                    maxLines: 8,
                    controller: _textController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        labelText: 'Write something about you',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(width: 5.0, color: Colors.blue),
                          borderRadius: BorderRadius.circular(25),
                        )),
                  ),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    String mobile = widget.mob;
                    String text = _textController.text.trim();
                    if (mobile.isNotEmpty && text.isNotEmpty) {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
                      _uploadData(mobile, text, _image);
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Error'),
                            content: Text('All fields are mandatory.'),
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
                  },
                  child: Text('Next'),
                ),
              ],
            ),
          )),
    );
  }
}
