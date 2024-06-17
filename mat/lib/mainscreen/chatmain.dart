import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:mat/mainscreen/searchpage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;


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

  @override
  void initState() {
    super.initState();
    fetchFriends();
  }

  Future<void> fetchFriends() async {
    try {
      final response = await http.get(Uri.parse(
          'http://192.168.133.76:3100/users/${widget.userId}/friends'));
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
          final response = await http.get(Uri.parse('http://192.168.133.76:3100/user/$id'));
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

  void _navigateToFriendDetailsPage(Friend friend,int id) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(senderId:widget.userId,receiverId: id,),
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
            onTap: () => _navigateToFriendDetailsPage(friend,friend.id),
            child: Container(
                width: 300,
                decoration: BoxDecoration(
                    color: Colors.blueGrey,

                    borderRadius: BorderRadius.circular(30)
                ),
                padding: EdgeInsets.all(8.0),
                margin: EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: [
                    if (friend.profileImage != null)
                    GestureDetector(
                      onTap:(){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FriendDetailsPage(friend: friend)
                          ),
                        );
                      },
                      child: ClipOval(
            child: Image.memory(
            friend.profileImage!,
              height: 50,
              width: 50,
              errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
            ),
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
  String firstName='';
  String lastName='';
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
    fetchUserDetails(widget.friend.id);
  }



  Future<void> fetchUserDetails(int id) async {
    final String apiUrl = 'http://$baserl:3100/user/$id/name'; // Replace 'your-api-url.com' with your API URL
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
        title: Text("$firstName $lastName"),
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
                padding: EdgeInsets.only(left: 30,),
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


class ChatScreen extends StatefulWidget {
  final int senderId;
  final int receiverId;

  const ChatScreen({Key? key, required this.senderId, required this.receiverId})
      : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late IO.Socket socket;
  TextEditingController messageController = TextEditingController();
  Uint8List? _imageData;
  String firstName='';
  String username='';
  String lastName='';
  String baserl="192.168.133.76";
  List<MessageModel>messages=[];
  ScrollController _scrollcontroller=ScrollController();

  @override
  void initState() {
    super.initState();
    fetchImage(widget.receiverId);
    fetchUserDetails(widget.receiverId);
    fetchusername(widget.receiverId);
    connectToSocket();
    // Load previous messages when the screen is opened
  }





  void connectToSocket() {
    socket = IO.io('http://192.168.133.76:5000', <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false
    });

    socket.connect();

    // Emit "join" event to join the chat room with the sender's user ID

    socket.emit("signin", widget.senderId);
    socket.onConnect((data){
      print("connected");
      socket.on("message", (msg)  {
        print(msg);
        setmessage("destination", msg["message"]);
        _scrollcontroller.animateTo(_scrollcontroller.position.maxScrollExtent, duration: Duration(milliseconds: 300), curve: Curves.easeOut);

      });
    });

    // Handle incoming private messages



  }









  void sendMessage(String message,int sourceId,int targetId) {
    setmessage("source", message);
    // Emit "private_message" event to send a private message to the receiver
    socket.emit("message", {
      'sourceId': sourceId,
      'targetId': targetId,
      'message': message,
    });


    messageController.clear();
  }

  void setmessage(String type,String message){
    MessageModel messagemodel=MessageModel(message: message, type: type,time: DateTime.now().toString().substring(10, 16));
    setState(() {
      setState(() {
        messages.add(messagemodel);

      });

    });
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


  Future<void> fetchUserDetails(int id) async {
    final String apiUrl = 'http://$baserl:3100/user/$id/name'; // Replace 'your-api-url.com' with your API URL
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: GestureDetector(
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
                    width: 40,
                    height:40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1),
                    ),
                    child: ClipOval(
                      child: Image.memory(
                        _imageData!,
                        fit: BoxFit.cover,
                        width: 40,
                        height: 40,
                      ),
                    ),
                  ),
                ),
              SizedBox(
                width: 4,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text("$firstName $lastName",style: TextStyle(fontSize: 14),),
                  SizedBox(
                    height: 2,
                  ),
                  Text("$username",style: TextStyle(fontSize: 10),),

                ],
              ),
              SizedBox(width: 2,),
              Icon(Icons.arrow_right)
            ],
          ),
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>NewPage(id: widget.receiverId)));


          },
        )
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/chatback.jpg'), // Replace with your image path
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              // height: MediaQuery.of(context).size.height - 150,
              child: ListView.builder(
                shrinkWrap: true,
                controller: _scrollcontroller,

                itemCount: messages.length + 1,
                itemBuilder: (context, index) {
                  if (index == messages.length) {
                    return Container(
                      height: 70,
                    );
                  }
                  if (messages[index].type == "source") {
                    return OwnMessageCard(
                      message: messages[index].message,
                      time: messages[index].time,
                    );
                  } else {
                    return ReplyCard(
                      message: messages[index].message,
                      time: messages[index].time,
                    );
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
              Expanded(
              child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.grey), // Optional: to add border
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 5),
                child: TextField(
                  controller: messageController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    fillColor: Colors.white,

                    hintText: "Type a message",
                    hintStyle: TextStyle(color: Colors.grey),

                  ),
                ),
              )
                  ),
                ),
      SizedBox(width: 10,),

      CircleAvatar(
        radius: 25,
        backgroundColor: Color(0xFF128C7E),
        child: IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () {
                      _scrollcontroller.animateTo(_scrollcontroller.position.maxScrollExtent, duration: Duration(milliseconds: 300), curve: Curves.easeOut);
                      String message = messageController.text.trim();
                      if (message.isNotEmpty) {
                        sendMessage(message,widget.senderId,widget.receiverId);
                      }
                    },
                  ),
      )
                ],
              ),
            ),
          ],
        ),
      )
    );
  }
}


class MessageModel {
  String type;
  String message;
  String time;
  MessageModel({required this.message, required this.type,required this.time});
}




class OwnMessageCard extends StatelessWidget {
  const OwnMessageCard({ required this.message,required this.time}) ;
  final String message;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 45,
        ),
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          color: Color(0xffdcf8c6),
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 50,
                  top: 5,
                  bottom: 20,
                ),
                child: Expanded(
                  child: Text(
                    message,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 4,
                right: 10,
                child: Row(
                  children: [
                    Text(
                      time,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Icon(
                      Icons.done_all,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class ReplyCard extends StatelessWidget {
  const ReplyCard({required this.message, required this.time}) ;
  final String message;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 45,
        ),
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          // color: Color(0xffdcf8c6),
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 8,
                  right: 50,
                  top: 5,
                  bottom: 10,
                ),
                child: Text(
                  message,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              Positioned(
                bottom: 4,
                right: 10,
                child: Text(
                  time,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


