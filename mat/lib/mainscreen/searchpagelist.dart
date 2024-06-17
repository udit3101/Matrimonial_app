import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

class Friend {
  final int id;
  final String firstName;
  final String lastName;
  final Uint8List? profileImage;

  Friend({required this.id, required this.firstName, required this.lastName,required this.profileImage});

  factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
        profileImage:json['profileimage']
    );
  }
}

class FriendListPage extends StatefulWidget {
  final int userId;

  const FriendListPage({Key? key, required this.userId}) : super(key: key);

  @override
  _FriendListPageState createState() => _FriendListPageState();
}

class _FriendListPageState extends State<FriendListPage> {
  List<Friend> _friends = [];
  String baserl="192.168.133.76";


  @override
  void initState() {
    super.initState();
    fetchFriends();
  }

  Future<void> fetchFriends() async {
    try {
      final response = await http.get(Uri.parse(
          'http://$baserl:3100/users/${widget.userId}/friends'));
      if (response.statusCode == 200) {
        List<dynamic> friendIds = jsonDecode(response.body)['friends'];
        await fetchFriendDetails(friendIds);
        print("$friendIds");
      } else {
        print('Failed to fetch friends: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching friends: $e');
    }
  }

  Future<void> fetchFriendDetails(List<dynamic> friendIds) async {
    for (var id in friendIds) {
      if (id != null) {
        print('Fetching details for friend ID: $id');
        try {
          final response = await http.get(Uri.parse('http://$baserl:3100/users/$id'));
          if (response.statusCode == 200) {
            final Map<String, dynamic> jsonData = jsonDecode(response.body);
            if (jsonData.containsKey('firstName') && jsonData.containsKey('lastName')) {
              final firstName = jsonData['firstName'];
              final lastName = jsonData['lastName'];
              final profileImage = await fetchFriendimg(id);

              setState(() {
                _friends.add(Friend(id: id, firstName: firstName, lastName: lastName,profileImage: profileImage));
              });
            } else {
              print('Incomplete friend details for ID: $id');
              print('Response body for friend ID $id: $jsonData');
            }
          } else {
            print('Failed to fetch friend details: ${response.statusCode}');
          }
        } catch (e) {
          print('Error fetching friend details: $e');
        }
      }
    }
  }

  Future<Uint8List?> fetchFriendimg(int id) async {
    try {
      final response = await http.get(Uri.parse('http://192.168.133.76:3100/user/$id/image'));
      if (response.statusCode == 200) {
        return base64Decode(jsonDecode(response.body)['image'].split(',').last);
      } else {
        print('Failed to load image: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching image: $e');
      return null;
    }
  }

  void _navigateToFriendDetailsPage(Friend friend) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FriendDetailsPage(friend: friend),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Friend List'),
      ),
      body: ListView.builder(
        itemCount: _friends.length,
        itemBuilder: (context, index) {
          final friend = _friends[index];
          return GestureDetector(
            onTap: () => _navigateToFriendDetailsPage(friend),
            child:  Container(
                width: 300,
                decoration: BoxDecoration(
                    color: Colors.blueGrey,

                    borderRadius: BorderRadius.circular(15)
                ),
                padding: EdgeInsets.all(8.0),
                margin: EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: [
                    if (friend.profileImage != null)
                      ClipOval(
                        child: Image.memory(
                          friend.profileImage!,
                          height: 50,
                          width: 50,
                          errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
                        ),
                      ),
                    SizedBox(width: 20,),


                    Text(
                      '${friend.firstName} ${friend.lastName}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                )
            ),
          );
        },
      ),
    );
  }
}
class FriendDetailsPage extends StatefulWidget {
  final Friend friend;

  const FriendDetailsPage({Key? key, required this.friend}) : super(key: key);

  @override
  _FriendDetailsPageState createState() => _FriendDetailsPageState();
}
class _FriendDetailsPageState extends State<FriendDetailsPage> {
  Uint8List? _imageData;
  String? dob;
  String? username;
  String? about;
  int height=0;
  String baserl="192.168.133.76";
  String _education="failed to load";
  String prof="failed to load";
  String diet="failed to load";
  String smoke="failed to load";
  String drink="failed to load";
  String place="failed to load";

  String? religion;
  List<String> hobbies = [];
  @override
  void initState() {
    super.initState();
    fetchImage(widget.friend.id);
    fetchusername(widget.friend.id);
    fetchabout(widget.friend.id);
    fetchHobbiesData(widget.friend.id);
    fetchreligion(widget.friend.id);
    fetchheight(widget.friend.id);
    fetchDOB(widget.friend.id);
    fetchsmoke(widget.friend.id);
    fetchedu(widget.friend.id);
    fetchjob(widget.friend.id);
    fetchplace(widget.friend.id);
    fetchdrink(widget.friend.id);
    fetchsmoke(widget.friend.id);
  }




  Future<String?> fetchheight(int id) async {
    final apiUrl = 'http://$baserl:3100/height?id=$id'; // Replace with your API URL
    final response = await http.get(
      Uri.parse('$apiUrl'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        height=data['height'];
      });
    } else {
      throw Exception('Failed to fetch date of birth');
    }
  }



  Future<String?> fetchusername(int id) async {
    final apiUrl = 'http://$baserl:3100/username?id=$id'; // Replace with your API URL
    final response = await http.get(
      Uri.parse('$apiUrl'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        username=data['username'];
      });
    } else {
      throw Exception('Failed to fetch date of birth');
    }
  }




  Future<String?> fetchabout(int id) async {
    final apiUrl = 'http://$baserl:3100/about?id=$id'; // Replace with your API URL
    final response = await http.get(
      Uri.parse('$apiUrl'),
    );

    if (response.statusCode == 200) {

      final Map<String, dynamic> data = json.decode(response.body);

      setState(() {
        about=data['About'];
      });
    } else {
      throw Exception('Failed to fetch date of birth');
    }
  }



  String formatSQLDate(String sqlDate) {
    // Split the SQL date string by '-' separator
    List<String> parts = sqlDate.split('-');

    // Extract year, month, and day parts
    String year = parts[0];
    String month = parts[1];
    String day = parts[2];

    // Return the formatted date string in 'DD/MM/YYYY' format
    return '$day/$month/$year';
  }

  Future<String?> fetchDOB(int id) async {
    final apiUrl = 'http://$baserl:3100/dob'; // Replace with your API URL
    final response = await http.get(
      Uri.parse('$apiUrl?id=$id'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      setState(() {

        dob= formatSQLDate(data['dob']);
      });
    } else {
      throw Exception('Failed to fetch date of birth');
    }
  }

  Future<void> fetchHobbiesData(int id) async {
    try {
      final apiUrl = 'http://$baserl:3100/hobbies'; // Replace with your API URL
      final response = await http.get(
        Uri.parse('$apiUrl?id=$id'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> hobbiesJson = data['hobbies'];
        setState(() {

          hobbies = hobbiesJson.map((hobby) => hobby.toString()).toList();

        });
      } else {
        throw Exception('Failed to fetch hobbies');
      }
    } catch (error) {
      print('Error fetching hobbies: $error');
      setState(() {
        hobbies = [];
      });
    }
  }

  Future<String?> fetchreligion(int id) async {
    final apiUrl = 'http://$baserl:3100/religion'; // Replace with your API URL
    final response = await http.get(
      Uri.parse('$apiUrl?id=$id'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        religion=data['religion'];
      });
    } else {
      throw Exception('Failed to fetch date of birth');
    }
  }





  Future<void> fetchImage(int userId) async {
    try {
      final response = await http.get(Uri.parse('http://$baserl:3100/user/$userId/image'));
      if (response.statusCode == 200) {
        setState(() {
          // Decode base64-encoded image data
          _imageData = base64Decode(jsonDecode(response.body)['image'].split(',').last);
        });
      } else {
        print('Failed to load image: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching image: $e');
    }
  }








  Future<String?> fetchedu(int id) async {
    final apiUrl = 'http://$baserl:3100/edu?id=$id'; // Replace with your API URL
    final response = await http.get(
      Uri.parse('$apiUrl'),
    );

    if (response.statusCode == 200) {

      final Map<String, dynamic> data = json.decode(response.body);

      setState(() {
        _education=data['Education'];
      });
    } else {
      throw Exception('Failed to fetch Education');
    }
  }






  Future<String?> fetchjob(int id) async {
    final apiUrl = 'http://$baserl:3100/job?id=$id'; // Replace with your API URL
    final response = await http.get(
      Uri.parse('$apiUrl'),
    );

    if (response.statusCode == 200) {

      final Map<String, dynamic> data = json.decode(response.body);

      setState(() {
        prof=data['profession'];
      });
    } else {
      throw Exception('Failed to fetch Profession');
    }
  }






  Future<String?> fetchplace(int id) async {
    final apiUrl = 'http://$baserl:3100/place?id=$id'; // Replace with your API URL
    final response = await http.get(
      Uri.parse('$apiUrl'),
    );

    if (response.statusCode == 200) {

      final Map<String, dynamic> data = json.decode(response.body);

      setState(() {
        place=data['place'];
      });
    } else {
      throw Exception('Failed to fetch place');
    }
  }







  Future<String?> fetchdrink(int id) async {
    final apiUrl = 'http://$baserl:3100/drink?id=$id'; // Replace with your API URL
    final response = await http.get(
      Uri.parse('$apiUrl'),
    );

    if (response.statusCode == 200) {

      final Map<String, dynamic> data = json.decode(response.body);

      setState(() {
        drink=data['drink'];
      });
    } else {
      throw Exception('Failed to fetch drink');
    }
  }




  Future<String?> fetchsmoke(int id) async {
    final apiUrl = 'http://$baserl:3100/smoke?id=$id'; // Replace with your API URL
    final response = await http.get(
      Uri.parse('$apiUrl'),
    );

    if (response.statusCode == 200) {

      final Map<String, dynamic> data = json.decode(response.body);

      setState(() {
        smoke=data['smoke'];
      });
    } else {
      throw Exception('Failed to fetch smoke');
    }
  }






  Future<String?> fetchdiet(int id) async {
    final apiUrl = 'http://$baserl:3100/diet?id=$id'; // Replace with your API URL
    final response = await http.get(
      Uri.parse('$apiUrl'),
    );

    if (response.statusCode == 200) {

      final Map<String, dynamic> data = json.decode(response.body);

      setState(() {
        diet=data['diet'];
      });
    } else {
      throw Exception('Failed to fetch diet');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Friend Details'),
      ),
      body:SingleChildScrollView(

      child:Column(
        children: [
          if (_imageData != null) // Only display the image if _imageData is not null
            Container(
height: 250,
              width: 250,
              child: Image.memory(
                _imageData!,
                fit: BoxFit.contain,

              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child:
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              ' ${widget.friend.firstName}',
                              style: TextStyle(fontSize: 20),
                            ),

                            Text(
                              ' ${widget.friend.lastName}',
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                        Text(
                          "About:",
                          style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "$about", style: TextStyle(fontSize: 16.0),
                        ),
                        Row(
                          children: [
                            Text(
                              "height:" ,  style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "$height:" ,  style: TextStyle(fontSize: 18.0),
                            ),

                          ],
                        ),


                        Row(
                          children: [
                            Text(
                              "religion:" ,  style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "$religion:" ,  style: TextStyle(fontSize: 18.0),
                            ),

                          ],
                        ),



                        Row(
                          children: [
                            Text(
                              "dob:" ,  style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "$dob:" ,  style: TextStyle(fontSize: 18.0),
                            ),

                          ],
                        ),

                        Wrap(

                          children: [
                            Text(
                              "hobbies:" ,  style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),
                            ),
                            Text(
                              " ${hobbies.join(', ')}:" ,  style: TextStyle(fontSize: 18.0),
                            ),

                          ],
                        ),



                        Row(
                          children: [
                            Text(
                              "Education:" ,  style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "$_education:" ,  style: TextStyle(fontSize: 18.0),
                            ),

                          ],
                        ),




                        Row(
                          children: [
                            Text(
                              "Profession:" ,  style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "$prof:" ,  style: TextStyle(fontSize: 18.0),
                            ),

                          ],
                        ),



                        Row(
                          children: [
                            Text(
                              "place:" ,  style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "$place:" ,  style: TextStyle(fontSize: 18.0),
                            ),

                          ],
                        ),



                        Row(
                          children: [
                            Text(
                              "smoke:" ,  style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "$smoke:" ,  style: TextStyle(fontSize: 18.0),
                            ),

                          ],
                        ),





                        Row(
                          children: [
                            Text(
                              "Drink:" ,  style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "$drink:" ,  style: TextStyle(fontSize: 18.0),
                            ),

                          ],
                        ),





                        Row(
                          children: [
                            Text(
                              "diet:" ,  style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "$diet:" ,  style: TextStyle(fontSize: 18.0),
                            ),

                          ],
                        ),




                      ],
                    )
                ),

                // Add more details here like region, email, mob, etc.

          ),
        ],
      )),
    );
  }
}
