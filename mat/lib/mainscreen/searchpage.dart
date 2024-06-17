import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mat/screens/plans.dart';
import 'dart:typed_data';
import 'searchpagelist.dart';

import 'package:shared_preferences/shared_preferences.dart';


class User {
  final String firstName;
  final String lastName;


  User({required this.firstName, required this.lastName});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      firstName: json['firstName'],
      lastName: json['lastName'],
    );
  }
}


class FriendRequest {
  final int id;
  final int fromUserId;
  final int toUserId;
  final String status;

  FriendRequest({
    required this.id,
    required this.fromUserId,
    required this.toUserId,
    required this.status,
  });

  factory FriendRequest.fromJson(Map<String, dynamic> json) {
    return FriendRequest(
      id: json['id'],
      fromUserId: json['fromUserId'],
      toUserId: json['toUserId'],
      status: json['status'],
    );
  }
}





class FriendRequestsPage extends StatefulWidget {
  final int userId;

  FriendRequestsPage({required this.userId}) ;

  @override
  _FriendRequestsPageState createState() => _FriendRequestsPageState();
}

class _FriendRequestsPageState extends State<FriendRequestsPage> {
  List<dynamic> friendRequests = [];

  @override
  void initState() {
    super.initState();
    fetchRequests();
  }

  String baserl="192.168.133.76";





  Future<void> fetchRequests() async {
    final response = await http.get(Uri.parse('http://$baserl:3100/friendRequests/${widget.userId}'));
    if (response.statusCode == 200) {
      setState(() {
        friendRequests = json.decode(response.body);
      });
    } else {
      // Handle error
    }
  }
  Future<String> fetchUsername(int userId) async {
    final response = await http.get(Uri.parse('http://$baserl:3100/user/$userId/name'));
    if (response.statusCode == 200) {
      final dynamic data = json.decode(response.body);
      return '${data['firstName']} ${data['lastName']}';
    } else {
      // Handle error
      return '';
    }
  }
  void _showFloatingSnackbar1(BuildContext context) {
    final snackBar = SnackBar(
      content: Text('Request Accepted!'),
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.all(16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _showFloatingSnackbar2(BuildContext context) {
    final snackBar = SnackBar(
      content: Text('Request Declined!'),
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.all(16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> acceptRequest(int requestId) async {
    final response = await http.post(Uri.parse('http://$baserl:3100/acceptRequest/$requestId'));
    if (response.statusCode == 200) {
      _showFloatingSnackbar1(context);
      // Refresh requests after accepting and remove the request from the list
      setState(() {
        friendRequests.removeWhere((request) => request['id'] == requestId);
      });


    } else {
      // Handle error
    }
  }

  Future<void> declineRequest(int requestId) async {
    final response = await http.post(Uri.parse('http://$baserl:3100/declineRequest/$requestId'));
    if (response.statusCode == 200) {
      _showFloatingSnackbar2(context);
      // Refresh requests after declining and remove the request from the list
      setState(() {
        friendRequests.removeWhere((request) => request['id'] == requestId);
      });

    } else {
      // Handle error
    }
  }




  @override
  Widget build(BuildContext context) {
    List<dynamic> pendingRequests = friendRequests
        .where((request) => request['status'] == 'pending')
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Friend Requests'),

      ),
      body:  ListView.builder(
        itemCount: pendingRequests.length,
        itemBuilder: (context, index) {
          final request = pendingRequests[index];
          final fromUserId = request['from_user_id'];

          return GestureDetector(
            child: FutureBuilder(
              future: fetchUsername(fromUserId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  final username = snapshot.data.toString();
                  final formattedRequest = '$username';
                  return ListTile(
                    title: Wrap(
                      children: [
                        Text("$formattedRequest ",style: TextStyle(fontWeight: FontWeight.bold),),
                        Text("requested to follow you"),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                            child: Text("Confirm"),
                            onPressed: () {
                              acceptRequest(request['id']);
                            },
                          ),

                        SizedBox(width:3 ,),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey
                          ),
                            child: Text("Decline",),
                            onPressed: () {
                              declineRequest(request['id']);
                            },


                        )

                      ],
                    ),
                  );
                }
              },
            ),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>NewPage(id: fromUserId)));
            },
          );
        },
      ),
    );
  }
}





class NewPage extends StatefulWidget {
  final int id;
  const NewPage({super.key,required this.id});

  @override
  State<NewPage> createState() => _NewPageState();
}

class _NewPageState extends State<NewPage> {
  String? dob;
  String? username;
  String? about;
  int height=0;
  String? religion;
  Uint8List? _imageData;
  String baserl="192.168.133.76";
  List<String> hobbies = [];

  String firstName = '';
  String _education="failed to load";
  String prof="failed to load";
  String diet="failed to load";
  String smoke="failed to load";
  String drink="failed to load";
  String place="failed to load";
  String lastName = '';


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








  Future<void> fetchUserDetails() async {
    final String apiUrl = 'http://$baserl:3100/user/${widget.id}/name'; // Replace 'your-api-url.com' with your API URL
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final dynamic data = json.decode(response.body);
      setState(() {
        firstName = data['firstName'];
        lastName = data['lastName'];
      });
    } else {
      setState(() {
        firstName = '';
        lastName = '';
      });
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
  void initState() {
    super.initState();
    fetchusername(widget.id);
    fetchDOB(widget.id);
    fetchheight(widget.id);
    fetchreligion(widget.id);
    fetchHobbiesData(widget.id);
    fetchabout(widget.id);
    fetchImage(widget.id);
    fetchsmoke(widget.id);
    fetchedu(widget.id);
    fetchjob(widget.id);
    fetchplace(widget.id);
    fetchdrink(widget.id);
    fetchsmoke(widget.id);
    fetchUserDetails();

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:    Text("$username",style: TextStyle(fontSize: 16),),


        backgroundColor: Colors.blueGrey,
      ),
      body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.only(left: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (_imageData !=
                        null) // Only display the image if _imageData is not null
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.blueGrey, width: 4),
                        ),
                        child: Container(
                          width: 110,
                          height: 110,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 1),
                          ),
                          child: ClipOval(
                            child: Image.memory(
                              _imageData!,
                              fit: BoxFit.cover,
                              width: 100,
                              height: 100,
                            ),
                          ),
                        ),
                      ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 20,
                    ),

                    Expanded(
                      child:  Text(
                        "$firstName $lastName ",
                        style: TextStyle(
                            fontSize: 26.0, fontWeight: FontWeight.bold),
                      ),
                    )



                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "About:",
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "$about",
                          style: TextStyle(fontSize: 16.0),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Height:",
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "$height",
                              style: TextStyle(fontSize: 18.0),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Religion:",
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "$religion",
                              style: TextStyle(fontSize: 18.0),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Date-of-birth:",
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "$dob",
                              style: TextStyle(fontSize: 18.0),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Education:",
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "$_education",
                              style: TextStyle(fontSize: 18.0),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Profession:",
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "$prof",
                              style: TextStyle(fontSize: 18.0),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Place:",
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "$place",
                              style: TextStyle(fontSize: 18.0),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Smoke:",
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "$smoke",
                              style: TextStyle(fontSize: 18.0),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Drink:",
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "$drink",
                              style: TextStyle(fontSize: 18.0),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Diet:",
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "$diet",
                              style: TextStyle(fontSize: 18.0),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "Hobbies:",
                              style: TextStyle(
                                  fontSize: 22.0, fontWeight: FontWeight.bold),
                            ),
                            Expanded(
                              child: Text(
                                " ${hobbies.join(', ')}:",
                                style: TextStyle(fontSize: 18.0),
                                textAlign: TextAlign.end,
                              ),
                            )
                          ],
                        ),
                      ],
                    )),

                // Add more details here like region, email, mob, etc.
              ),
            ],
          )),
    );
  }
}






class UserDetailsPage extends StatefulWidget {
  final int id;
  const UserDetailsPage({required this.id});

  @override
  _UserDetailsPageState createState() => _UserDetailsPageState();
}
class _UserDetailsPageState extends State<UserDetailsPage> {
  User? _user;
int currentindex=0;
  Uint8List? _imageData;
  bool _isContainerUp = true;
int followerCount=0;
  String? dob;
String? username;
  String? about;
  int height=0;
  String baserl="192.168.133.76";
  String? religion;
  List<String> hobbies = [];
  List<int> _nonFriendUserIds = [];
  String _education="failed to load";
  String prof="failed to load";
  String diet="failed to load";
  String smoke="failed to load";
  String drink="failed to load";
  String place="failed to load";
  @override
  void initState() {
    super.initState();
    loadNonFriendUser();
    fetchFollowerCount();

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




  Future<void> fetchUserDetails(int userId) async {
    try {
      final response = await http.get(Uri.parse('http://$baserl:3100/user/$userId/name'));
      if (response.statusCode == 200) {
        setState(() {
          _user = User.fromJson(jsonDecode(response.body));
        });
      } else {
        print('Failed to load user details: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching user details: $e');
    }
  }




  Future<void> loadNonFriendUser() async {
    _nonFriendUserIds = await fetchNonFriendUserIds(widget.id); // Assign value to member variable
   print("non friend : $_nonFriendUserIds");
    if (_nonFriendUserIds!=0) {
      fetchUserDetails(_nonFriendUserIds[currentindex]);
      fetchImage(_nonFriendUserIds[currentindex]);
      fetchheight(_nonFriendUserIds[currentindex]);
      fetchDOB(_nonFriendUserIds[currentindex]);
      fetchreligion(_nonFriendUserIds[currentindex]);
      fetchHobbiesData(_nonFriendUserIds[currentindex]);
      fetchabout(_nonFriendUserIds[currentindex]);
      fetchusername(_nonFriendUserIds[currentindex]);

      fetchFollowerCount();

    } else {
      setState(() {
        Center(
          child: Container(
            color: Colors.red,
            child: CircularProgressIndicator(),
          ),
        );
      });
    }
  }



  Future<List<int>> fetchNonFriendUserIds(int userId) async {
    try {
      final response = await http.get(Uri.parse('http://$baserl:3100/users/$userId/non-friends'));
      if (response.statusCode == 200) {
        final nonFriends = jsonDecode(response.body)['nonFriends'] as List<dynamic>;
        // Convert dynamic list to List<int>
        final nonFriendUserIds = nonFriends.map((id) => id as int).toList();
        return nonFriendUserIds;
      } else {
        print('Failed to fetch non-friends: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching non-friends: $e');
    }
    // Return an empty list if no non-friend user IDs are found
    return []; // Empty list
  }



  Future<void> fetchFollowerCount() async {
    final String apiUrl = 'http://$baserl:3200/folor?id=${widget.id}';
    // Replace 'your-api-url.com' with your API URL

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          followerCount = data['flr'];
        });
      } else {
        print('Failed to fetch follower count: ${response.body}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> sendFriendRequest(int toUserId) async {
    // Set the fromUserId to a fixed value
    try {
      final response = await http.post(
        Uri.parse('http://$baserl:3000/friendRequests'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, dynamic>{
          'fromUserId': widget.id,
          'toUserId': toUserId,
        }),
      );

      loadNextUser();
      increaseFollowerCount(widget.id);

      if (response.statusCode == 201) {

        print('Friend request sent successfully');
      } else {
        print('Failed to send friend request: ${response.statusCode}');

      }
    } catch (e) {
      print('Error sending friend request: $e');
    }
  }

  void loadNextUser() {
    setState(() {
      currentindex++;
    });
    if (currentindex < _nonFriendUserIds.length) {
      fetchheight(_nonFriendUserIds[currentindex]);
      fetchDOB(_nonFriendUserIds[currentindex]);
      fetchreligion(_nonFriendUserIds[currentindex]);
      fetchHobbiesData(_nonFriendUserIds[currentindex]);
      fetchUserDetails(_nonFriendUserIds[currentindex]);
      fetchImage(_nonFriendUserIds[currentindex]);
      fetchabout(_nonFriendUserIds[currentindex]);
      fetchusername(_nonFriendUserIds[currentindex]);

      fetchFollowerCount();


    } else {
      // Display a message indicating that all IDs have been checked
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("All IDs Checked"),
            content: Text("You have checked all non-friend user IDs."),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
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



  Future<void> increaseFollowerCount(int userId) async {
    final String apiUrl = 'http://$baserl:3100/increaseFollowerCount/$userId';
    // Replace 'your-api-url.com' with your API URL

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
      );

      if (response.statusCode == 200) {
        print('Follower count increased successfully');
      } else {
        print('Failed to increase follower count: ${response.body}');
      }
    } catch (error) {
      print('Error: $error');
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
backgroundColor: Color(0xFFFFFF99),
appBar:AppBar(
backgroundColor: Color(0xFFFFFF99),
  title:
  Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text("Var-Vadhu",style:TextStyle(color: Colors.blue,) ,),
      Padding(padding: EdgeInsets.only(top: 5,),
        child: IconButton(
          onPressed: (){
            Navigator.push(context,MaterialPageRoute(builder: (context)=>FriendRequestsPage(userId: widget.id,)));
          },
          alignment: Alignment.topRight,
          icon: Icon(Icons.favorite_border_outlined),
          color: Colors.lightBlueAccent,
          iconSize: 30,
        ),)

    ],
  )
) ,
       body: SingleChildScrollView(


          child: Padding(
            padding: EdgeInsets.only(top:1.0,left: 8.0,bottom: 2.0,right: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [


                if (_user != null)
                 GestureDetector(
                   child:  AnimatedContainer(
                     duration: Duration(milliseconds: 300),
                     decoration: BoxDecoration(
                       borderRadius: BorderRadius.circular(8),
                       boxShadow: [
                         BoxShadow(
                           color: Colors.black.withOpacity(0.5),
                           spreadRadius: 10,
                           blurRadius: 5,
                           offset: Offset(0, 3), // changes position of shadow
                         ),
                       ],
                     ),

                     margin: EdgeInsets.only(top: _isContainerUp ? 50 : 0),
                     height: MediaQuery.of(context).size.height/1.6,
                     width: MediaQuery.of(context).size.width/1.1,
                     child: Stack(
                       children: [

                         if (_imageData != null) // Only display the image if _imageData is not null
                           Container(
                   decoration: BoxDecoration(
                   borderRadius: BorderRadius.circular(15),
    ),
                   child: Image.memory(
                               _imageData!,
                               fit: BoxFit.fill,

                               height: MediaQuery.of(context).size.height,
                               width: MediaQuery.of(context).size.width,

                             ),
                            ),
                         Container(
                           decoration: BoxDecoration(
                             gradient: LinearGradient(
                               begin: Alignment.topCenter,
                               end: Alignment.bottomCenter,
                               colors: [ Colors.transparent,Colors.black],
                               stops: [0.4, 1.0],
                             ),
                           ),
                           height: MediaQuery.of(context).size.height/1.6,
                           width: MediaQuery.of(context).size.width,
                         ),

                         Positioned(child:
                         Row(
                           children: [
                             Text("${_user!.firstName} ",style: TextStyle(fontSize: 18,color: Colors.white70),),
                             Text(" ${_user!.lastName}",style: TextStyle(fontSize: 18,color: Colors.white70),)
                           ],
                         ),
                           left: 20,
                           bottom: 30,),

                         Positioned(child:

                             Text("@ ${username}",style: TextStyle(fontSize: 22,fontWeight:FontWeight.bold,color: Colors.white),),

                           left: 20,
                           bottom: 50,)
                       ],
                     ),
                   ),
                   onTap:  () {
                     setState(() {
                       fetchheight(_nonFriendUserIds[currentindex]);
                       fetchDOB(_nonFriendUserIds[currentindex]);
                       fetchreligion(_nonFriendUserIds[currentindex]);
                       fetchHobbiesData(_nonFriendUserIds[currentindex]);
                       fetchabout(_nonFriendUserIds[currentindex]);
                       fetchusername(_nonFriendUserIds[currentindex]);
                       fetchsmoke(_nonFriendUserIds[currentindex]);
                       fetchedu(_nonFriendUserIds[currentindex]);
                       fetchjob(_nonFriendUserIds[currentindex]);
                       fetchplace(_nonFriendUserIds[currentindex]);
                       fetchdrink(_nonFriendUserIds[currentindex]);
                       fetchsmoke(_nonFriendUserIds[currentindex]);

fetchFollowerCount();
                       _isContainerUp = !_isContainerUp;
                     });
                   },
                 ),

                SizedBox(height: 15,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,

                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.purple, // Change the color as needed
                      ),
                      child: IconButton(
                        onPressed: () {
                          if(followerCount<=5){
                            loadNextUser();

                          }
                          else{
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>PlansPage(id: widget.id)));

                          }

                        },
                        icon: Icon(Icons.clear),
                        color: Colors.redAccent,
                        iconSize: 40,
                      ),
                    ),

                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.purple, // Change the color as needed
                      ),
                      child: IconButton(

                        onPressed: ()async{
                          if(followerCount<=5){
                            sendFriendRequest(_nonFriendUserIds[currentindex]);


                          }
                          else{
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>PlansPage(id: widget.id,)));

                          }

                            },
                        icon: Icon(Icons.favorite_outline),
                        color: Colors.redAccent,
                        iconSize: 40,

                      ),
                    )

                  ],
                ),

                if (_isContainerUp == false)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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

              ],
            ),
          ),
        )
    );
  }
}
