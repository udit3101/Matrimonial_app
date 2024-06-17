import 'package:flutter/material.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mat/screens/start.dart';
class Aboutus extends StatefulWidget {
  const Aboutus({Key? key}) : super(key: key);

  @override
  State<Aboutus> createState() => _AboutusState();
}

class _AboutusState extends State<Aboutus> {


  final List<String> _imageUrls = [
    'assets/comp logo.jpg',
    'assets/comp poster.jpg',
    'assets/post.jpg'
  ];
  int _currentPage = 0;
  late PageController _pageController;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();
    super.dispose();
  }



  final String shorttext =
      "Welcome to Var-Vadhu, where we redefine the pursuit of love. Our mobile app provides a secure haven for individuals seeking lifelong companionship. Utilizing advanced technology and personalized matchmaking algorithms, we facilitate connections based on compatibility and shared values.";
  final String Longtext =
      "Var-Vadhu is committed to guiding you on your journey to finding your perfect match. With a user-friendly interface and stringent privacy measures, we prioritize your satisfaction and safety above all else. Join us in the pursuit of meaningful connections, where every interaction brings you closer to your soulmate. Embrace the joy of discovering genuine companionship and lasting love with Var-Vadhu. Start your journey today and let us be your trusted partner in finding the one who complements your life.";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 15,),

                Container(
                    height: 230,
                    width: double.infinity,
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount:
                        _imageUrls.length + 2, // Add 2 for infinite scrolling
                        itemBuilder: (BuildContext context, int index) {
                          if (index == 0) {
                            // Last item becomes the first item for infinite scrolling
                            return Image.asset(
                              _imageUrls[_imageUrls.length - 1],
                              fit: BoxFit.fill,
                            );
                          } else if (index == _imageUrls.length + 1) {
                            // First item becomes the last item for infinite scrolling
                            return Image.asset(
                              _imageUrls[0],
                              fit: BoxFit.cover,
                            );
                          } else {
                            return Image.asset(
                              _imageUrls[index - 1],
                              fit: BoxFit.cover,
                            );
                          }
                        },
                        onPageChanged: (int index) {
                          // Update current page for indicator
                          setState(() {
                            _currentPage = index % _imageUrls.length;
                          });
                        },
                      ),
                    )),
                Text(
                  shorttext,
                  style: TextStyle(fontSize: 16),
                ),
                ReadMoreText(longText: Longtext),
                SizedBox(
                  height: 8,
                ),
                Center(
                  child: Container(
                    height: 30,
                    color: Colors.blue,
                    child: Text(
                      "Trusted by millions",
                      style: TextStyle(fontSize: 22, color: Colors.white),
                    ),
                  ),
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 20,
                      child: Icon(Icons.person_2),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text("Best Matches    ")
                  ],
                ),
                SizedBox(
                  height: 4,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 20,
                      child: Icon(Icons.verified),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text("Verified Profiles")
                  ],
                ),
                SizedBox(
                  height: 4,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 20,
                      child: Icon(Icons.privacy_tip),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text("100% Privacy    ")
                  ],
                ),
                Divider(),
                Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Contact us @"),
                    GestureDetector(
                      onTap: () {
                        // Replace with the desired phone number
                      },
                      child: Text(
                        '+1234567890', // Replace with the desired phone number
                        style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    )
                  ],
                ),


              ],
            )));
  }
}

class ReadMoreText extends StatefulWidget {
  final String longText;

  ReadMoreText({required this.longText});

  @override
  _ReadMoreTextState createState() => _ReadMoreTextState();
}

class _ReadMoreTextState extends State<ReadMoreText> {
  bool showFullText = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              showFullText = !showFullText;
            });
          },
          child: Text(
            showFullText ? widget.longText : 'Read More',
            style: TextStyle(color: Colors.black, fontSize: 16.0),
          ),
        ),




      ],
    );
  }



}
