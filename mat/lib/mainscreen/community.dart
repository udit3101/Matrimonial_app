import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';

import 'package:mat/mainscreen/profile.dart';

class HomePage extends StatefulWidget {
  final String mobiled;

  HomePage({required this.mobiled}) ;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
 String _username="";
   List<dynamic> _users=[];
int id=0;
  @override
  void initState() {
    super.initState();
    fetchUsername();
    fetchUsers().then((users) {
      setState(() {
        _users = users;
      });
    }).catchError((error) {
      print('Error loading users: $error');
      // Handle error (e.g., show error message)
    });
    getUserId(widget.mobiled);
  }



 Future<void> getUserId(String mobileNumber) async {
   final response = await http.get(Uri.parse('http://192.168.133.76:3100/userId/$mobileNumber'));
   if (response.statusCode == 200) {
     final data = json.decode(response.body);
      id = data['userId'];

   } else {


   }
 }
  Future<List<dynamic>> fetchUsers() async {
    final response = await http.get(Uri.parse('http://192.168.133.76:3500/users'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['users'];
    } else {
      throw Exception('Failed to load users');
    }
  }
  Future<void> fetchUsername() async {
    final response = await http.get(Uri.parse('http://192.168.133.76:3200/username?mobile=${widget.mobiled}'));
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      setState(() {

        _username = jsonResponse['username'];
      });
      print("usernameis $_username");
    } else {
      // Handle error (e.g., show error message)
      print('Failed to fetch username: ${response.statusCode}');
    }
  }
 void refreshHomePage() {
   fetchUsers();
 }
 Future<void> _refreshData() async {
   await   fetchUsers().then((users) {
     setState(() {
       _users = users;
     });
   }).catchError((error) {
     print('Error loading users: $error');
     // Handle error (e.g., show error message)
   });
 }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Stack(
          children: [
      // Background image
      Container(
      decoration: BoxDecoration(
      image: DecorationImage(
          image: AssetImage('assets/5.jpg'), // Replace with your image asset path
      fit: BoxFit.cover,
    ),
    ),
    ),Column(

        children: [

          Padding(
            padding: const EdgeInsets.only(top: 35),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  Text(
                    'Blogs for',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                   child:Text( ' $_username',
                     style: TextStyle(
                       fontSize: 26,
                       fontWeight: FontWeight.bold,
                     ),),
                    onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>Profilepage(mob: widget.mobiled, ids: id)));
    } ),
                ],
              )
            )
          ),
         Expanded(child:  RefreshIndicator(
           onRefresh: _refreshData,
           child:_users == null
               ? Center(child: CircularProgressIndicator())
               : ListView.builder(

             itemCount: _users.length,

             itemBuilder: (BuildContext context, int index) {

               return UserDetailCard(user: _users[index]);
             },
           ),
         ),)
        ],
      ),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle floating button press (e.g., navigate to upload page)
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UploadPage(usern: _username, onUploadSuccess: refreshHomePage),
            ),
          ); },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class UserDetailCard extends StatelessWidget {
  final dynamic user;

  UserDetailCard({required this.user});

  @override
  Widget build(BuildContext context) {
    List<Widget> imageWidgets = [];
    for (var i = 1; i <= 3; i++) {
      if (user['image_url$i'] != null && user['image_url$i'] != '') {
        imageWidgets.add(
          Expanded(

            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Image.network(
                user['image_url$i'],

                fit: BoxFit.fill,
              ),

            ),


          ),
        );
      }
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color:Color(0xFFCCFFFF),


        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '@${user['username']}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
             Padding(padding: EdgeInsets.only(left: 15),
             child:  Text(
               user['text'],
               style: TextStyle(fontSize: 14),
             ),),
              SizedBox(height: 16),
              Padding(padding: EdgeInsets.only(left: 10),
                child: Row(
                  children: imageWidgets,
                ),),

              Divider(),
            ],
          ),
        ),
      ),
    );
  }
}








class UploadPage extends StatefulWidget {
  final String usern;

  final Function() onUploadSuccess;

  UploadPage({required this.usern, required this.onUploadSuccess});

  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  TextEditingController textController = TextEditingController();
  List<File> _imageList = [];

  Future<void> _getImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        _imageList.add(File(pickedImage.path));
      });
    }
  }

  Future<void> _uploadData() async {
    if ( textController.text.isEmpty || _imageList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please enter username, text, and select at least one image.'),
      ));
      return;
    }

    var uri = Uri.parse('http://192.168.133.76:3500/upload');
    var request = http.MultipartRequest('POST', uri);

    // Add text fields
    request.fields['username'] = widget.usern;
    request.fields['text'] = textController.text;

    // Add images
    for (var i = 0; i < _imageList.length; i++) {
      var multipartFile = await http.MultipartFile.fromPath('images', _imageList[i].path);
      request.files.add(multipartFile);
    }

    var response = await request.send();

    if (response.statusCode == 200) {
      widget.onUploadSuccess(); // Call the callback function to refresh the home page
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Data uploaded successfully'),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to upload data. Please try again.'),
      ));
    }
  }



  void _showImageDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop(); // Close the dialog when tapped outside the image
            },
            child: Container(
              width: double.infinity,
              height: double.infinity,
              child: Stack(
                children: [
                  Center(
                    child: Image.file(
                      _imageList[index],
                      fit: BoxFit.contain,
                    ),
                  ),
                  Positioned(
                    top: 8.0,
                    right: 8.0,
                    child: IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Page'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [


            Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  TextField(
                    controller: textController,
                    textAlign: TextAlign.start,
                    maxLines: null,// Align text entry to start from top left
                    decoration: InputDecoration(
                      border: InputBorder.none, // Remove border of TextField
                      hintText: 'Text', // Placeholder text
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(onPressed: (){  _getImage(ImageSource.gallery);}, icon: Icon(Icons.add_a_photo))
                    ],
                  )
                ],
              )

            ),


            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _uploadData,
              child: Text('Upload Data'),
            ),
            SizedBox(height: 16),

            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 0.5,
                  mainAxisSpacing: 4.0,
                ),
                itemCount: _imageList.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(

                    onTap:() {
                      _showImageDialog(context, index);
                    },
                      child: Image.file(
                        _imageList[index],
                        height: 150,
                        width: 150,
                        fit: BoxFit.scaleDown,
                      ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}