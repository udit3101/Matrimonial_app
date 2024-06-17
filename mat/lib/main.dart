import 'package:flutter/material.dart';
import 'package:mat/mainscreen/community.dart';
import 'package:mat/screens/detailsignup.dart';
import 'package:mat/mainscreen/aboutus.dart';
import 'package:mat/mainscreen/profile.dart';
import 'package:mat/screens/signup.dart';
import 'package:mat/screens/detailsignup.dart';
import 'package:mat/screens/start.dart';
import 'package:mat/screens/forgotpassword.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'mainscreen/chatmain.dart';
import 'mainscreen/searchpage.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  String? savedCredential = prefs.getString('credential'); // Retrieve saved credential
  int? saved_id_of_user = prefs.getInt('userId'); // Retrieve saved credential

  runApp(MyApp(isLoggedIn: isLoggedIn, saved_id_of_user:saved_id_of_user ?? 0,savedCredential: savedCredential ?? ""));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final String savedCredential;
  final int saved_id_of_user;

  MyApp({required this.isLoggedIn, required this.savedCredential,required this.saved_id_of_user});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: isLoggedIn ? MyHomePage(mobiles: savedCredential,id_of_user: saved_id_of_user,) : Startpage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
final id_of_user;
  final String mobiles;
  const MyHomePage({super.key,required this.mobiles,required this.id_of_user});


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedpage = 0;
  PageController _pagecontroller = PageController();

  void ontap(int index) {
    setState(() {
      selectedpage = index;
    });

  }





  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn'); // Clear isLoggedIn flag
    // You can clear other user data if needed
    // Navigate the user back to the login page or any other page
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => Startpage()),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

        bottomNavigationBar: BottomNavigationBar(

          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.group), label: "Community",),
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
            BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chat"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Person"),
  ],
          currentIndex: selectedpage,

          onTap: ontap,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.green,
        ),

        body:IndexedStack(
          index: selectedpage,



          children: [
            HomePage(mobiled: widget.mobiles),
            Aboutus(),
          UserDetailsPage(id: widget.id_of_user),
            FriendListPage(userId: widget.id_of_user,),
         Profilepage(mob: widget.mobiles,ids: widget.id_of_user,)
          ],
        ));
  }
}
