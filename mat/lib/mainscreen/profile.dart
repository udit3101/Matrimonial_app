import 'dart:typed_data';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mat/screens/start.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:http/http.dart'as http;
class Profilepage extends StatefulWidget {
  final  String mob;
  final int ids;
  const Profilepage({Key? key, required this.mob,required this.ids}) : super(key: key);

  @override
  State<Profilepage> createState() => _ProfilepageState();
}

class _ProfilepageState extends State<Profilepage> {

  String? username;

  Uint8List? _imageData;
  Future<void> fetchImage(int userId) async {
    try {
      final response = await http.get(Uri.parse('http://192.168.133.76:3100/user/$userId/image'));
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





  String baseurlfetch ="192.168.133.76:3200";
    Future<String?> fetchusername(String mobileNumber) async {
    final apiUrl = 'http://$baseurlfetch/username'; // Replace with your API URL
    final response = await http.get(
      Uri.parse('$apiUrl?mobile=$mobileNumber'),
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
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchusername(widget.mob);
    fetchImage(widget.ids);


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Container(
          height: double.infinity,
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height/2.3,
                width: MediaQuery.of(context).size.width,
                color: Color(0xffae7e7b),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 25,),
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: FloatingActionButton(
                          mini: true,
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          child: Icon(
                            Icons.more_vert,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            showMenu(
                              context: context,
                              position: RelativeRect.fromLTRB(1000, 70, 16, 0),
                              items: [
                                PopupMenuItem<String>(
                                  value: 'logout',
                                  child: Text('Logout'),
                                ),
                              ],
                            ).then((value) {
                              if (value == 'logout') {
                                _logout();
                              }
                            });
                          },
                        ),
                      ),
                    ),

                    ClipOval(

                     child:Image.memory(_imageData!,
                     height: 200,
                     width: 200,),

                    ),
                    SizedBox(height: 10,),

                    Text(
                      " $username",
                      style: TextStyle(fontSize: 28,fontWeight: FontWeight.bold),
                    ),

                  ],
                ),
              ),
              Expanded(
                child: DefaultTabController(
                  length: 2,
                  child: Column(
                    children: <Widget>[
                      TabBar(
                        unselectedLabelColor: Colors.blue,
                        labelColor: Colors.red,
                        tabs: [
                          Container(
                            width: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Tab(text: 'Profile'),
                          ),
                          Container(
                            width: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Tab(text: 'Plans'),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Expanded(
                        child: Container(
                          height: 200,
                          child: TabBarView(
                            children: [
                              profiledet(mobj: widget.mob),
                             PlansPage(id: widget.ids)
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
],
          )),
    );
  }
}


class profiledet extends StatefulWidget {
  final String mobj;
  const profiledet({super.key,required this.mobj});

  @override
  State<profiledet> createState() => _profiledetState();
}

class _profiledetState extends State<profiledet> {
  String? dob;

  int height=0;
String _education="failed to load";
String prof="failed to load";
String diet="failed to load";
String smoke="failed to load";
String drink="failed to load";
String place="failed to load";
  String? email;
  String? religion;
  List<String> hobbies = [];
  String? firstname;
  String? lastname;
  Future<String?> fetchfirstname(String mobileNumber) async {
    final apiUrl = 'http://$baseurlfetch/firstName'; // Replace with your API URL
    final response = await http.get(
      Uri.parse('$apiUrl?mobile=$mobileNumber'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        firstname=data['firstName'];
      });
    } else {
      throw Exception('Failed to fetch date of birth');
    }
  }


  Future<String?> fetchlastname(String mobileNumber) async {
    final apiUrl = 'http://$baseurlfetch/lastName'; // Replace with your API URL
    final response = await http.get(
      Uri.parse('$apiUrl?mobile=$mobileNumber'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        lastname=data['lastName'];
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

  String baseurlfetch ="192.168.133.76:3200";
  Future<String?> fetchDOB(String mobileNumber) async {
    final apiUrl = 'http://$baseurlfetch/dob'; // Replace with your API URL
    final response = await http.get(
      Uri.parse('$apiUrl?mobile=$mobileNumber'),
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


  Future<String?> fetchemail(String mobileNumber) async {
    final apiUrl = 'http://$baseurlfetch/email'; // Replace with your API URL
    final response = await http.get(
      Uri.parse('$apiUrl?mobile=$mobileNumber'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        email=data['email'];
      });
    } else {
      throw Exception('Failed to fetch date of birth');
    }
  }

  Future<void> fetchHobbiesData() async {
    try {
      final baseurlfetch = '192.168.133.76:3200'; // Replace with your base URL
      final apiUrl = 'http://$baseurlfetch/hobbies'; // Replace with your API URL
      final response = await http.get(
        Uri.parse('$apiUrl?mobile=${widget.mobj}'),
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

  Future<String?> fetchreligion(String mobileNumber) async {
    final apiUrl = 'http://$baseurlfetch/religion'; // Replace with your API URL
    final response = await http.get(
      Uri.parse('$apiUrl?mobile=$mobileNumber'),
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

  Future<String?> fetchheight(String mobileNumber) async {
    final apiUrl = 'http://$baseurlfetch/height'; // Replace with your API URL
    final response = await http.get(
      Uri.parse('$apiUrl?mobile=$mobileNumber'),
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



  Future<String?> fetchedu(String mobileNumber) async {
    final apiUrl = 'http://$baseurlfetch/education'; // Replace with your API URL
    final response = await http.get(
      Uri.parse('$apiUrl?mobile=$mobileNumber'),
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



  Future<String?> fetchprof(String mobileNumber) async {
    final apiUrl = 'http://$baseurlfetch/job'; // Replace with your API URL
    final response = await http.get(
      Uri.parse('$apiUrl?mobile=$mobileNumber'),
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


  Future<String?> fetchplace(String mobileNumber) async {
    final apiUrl = 'http://$baseurlfetch/place'; // Replace with your API URL
    final response = await http.get(
      Uri.parse('$apiUrl?mobile=$mobileNumber'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        place=data['place'];
      });
    } else {
      throw Exception('Failed to fetch Place');
    }
  }






  Future<String?> fetchdiet(String mobileNumber) async {
    final apiUrl = 'http://$baseurlfetch/diet'; // Replace with your API URL
    final response = await http.get(
      Uri.parse('$apiUrl?mobile=$mobileNumber'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        diet=data['diet'];
      });
    } else {
      throw Exception('Failed to fetch Diet');
    }
  }






  Future<String?> fetchsmoke(String mobileNumber) async {
    final apiUrl = 'http://$baseurlfetch/smoke'; // Replace with your API URL
    final response = await http.get(
      Uri.parse('$apiUrl?mobile=$mobileNumber'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        smoke=data['smoke'];
      });
    } else {
      throw Exception('Failed to fetch Smoke');
    }
  }





  Future<String?> fetchdrink(String mobileNumber) async {
    final apiUrl = 'http://$baseurlfetch/drink'; // Replace with your API URL
    final response = await http.get(
      Uri.parse('$apiUrl?mobile=$mobileNumber'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        drink=data['drink'];
      });
    } else {
      throw Exception('Failed to fetch Drink');
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchDOB(widget.mobj);
    fetchemail(widget.mobj);
    fetchheight(widget.mobj);
    fetchHobbiesData();
    fetchlastname(widget.mobj);
    fetchfirstname(widget.mobj);
    fetchreligion(widget.mobj);
    fetchedu(widget.mobj);
    fetchprof(widget.mobj);
    fetchplace(widget.mobj);
    fetchdiet(widget.mobj);
    fetchdrink(widget.mobj);
    fetchsmoke(widget.mobj);


  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [

           Padding(padding: EdgeInsets.fromLTRB(8, 2, 8, 4),
           child:  Container(
             decoration:BoxDecoration(
                 border: Border.all(
                     width: 2.0,
                     color: Colors.black12
                 )


             ),
             height: 70,
             width: MediaQuery.of(context).size.width,
             child: firstname != null && lastname != null
                 ? Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
             Padding(padding: EdgeInsets.fromLTRB(8, 17, 8, 3),child: Text('Full Name: ',style: TextStyle(fontSize: 14),),),
                 Padding(padding: EdgeInsets.fromLTRB(8, 2, 8, 0),child: Text("$firstname $lastname",style: TextStyle(fontSize: 22),),),


               ],
             )
                 : CircularProgressIndicator(),
           ),),





            Padding(padding: EdgeInsets.fromLTRB(8, 2, 8, 4),
              child:  Container(
                decoration:BoxDecoration(
                    border: Border.all(
                        width: 2.0,
                        color: Colors.black12
                    )


                ),
                height: 70,
                width: MediaQuery.of(context).size.width,
                child: dob != null
                    ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(padding: EdgeInsets.fromLTRB(8, 17, 8,3),child: Text('DOB: ',style: TextStyle(fontSize: 14),),),
                    Padding(padding: EdgeInsets.fromLTRB(8, 2, 8, 0),child: Text("$dob",style: TextStyle(fontSize: 22),),),


                  ],
                )
                    : CircularProgressIndicator(),
              ),),






            Padding(padding: EdgeInsets.fromLTRB(8, 2, 8, 4),
              child:  Container(
                decoration:BoxDecoration(
                    border: Border.all(
                        width: 2.0,
                        color: Colors.black12
                    )


                ),
                height: 70,
                width: MediaQuery.of(context).size.width,
                child: religion!= null
                    ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(padding: EdgeInsets.fromLTRB(8, 17, 8, 3),child: Text('Religion: ',style: TextStyle(fontSize: 14),),),
                    Padding(padding: EdgeInsets.fromLTRB(8, 2, 8, 0),child: Text("$religion",style: TextStyle(fontSize: 22),),),

                  ],
                )
                    : CircularProgressIndicator(),
              ),),






            Padding(padding: EdgeInsets.fromLTRB(8, 2, 8, 4),
              child:  Container(
                decoration:BoxDecoration(
                    border: Border.all(
                        width: 2.0,
                        color: Colors.black12
                    )


                ),
                height: 70,
                width: MediaQuery.of(context).size.width,
                child: height != null
                    ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(padding: EdgeInsets.fromLTRB(8, 17, 8, 3),child: Text('Height: ',style: TextStyle(fontSize: 14),),),
                    Padding(padding: EdgeInsets.fromLTRB(8, 2, 8, 0),child: Text("$height",style: TextStyle(fontSize: 22),),),

                  ],
                )
                    : CircularProgressIndicator(),
              ),),






            Padding(padding: EdgeInsets.fromLTRB(8, 2, 8, 4),
              child:  Container(
                decoration:BoxDecoration(
                    border: Border.all(
                        width: 2.0,
                        color: Colors.black12
                    )


                ),
                height: 70,
                width: MediaQuery.of(context).size.width,
                child: widget.mobj != null
                    ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(padding: EdgeInsets.fromLTRB(8, 17, 8, 3),child: Text('Mobile: ',style: TextStyle(fontSize: 14),),),
                    Padding(padding: EdgeInsets.fromLTRB(8, 2, 8, 0),child: Text("${widget.mobj}",style: TextStyle(fontSize: 22),),),


                  ],
                )
                    : CircularProgressIndicator(),
              ),),





            Padding(padding: EdgeInsets.fromLTRB(8, 2, 8, 4),
              child:  Container(

                decoration:BoxDecoration(
                    border: Border.all(
                        width: 2.0,
                        color: Colors.black12
                    )


                ),
                height: 70,
                width: MediaQuery.of(context).size.width,
                child: hobbies != null
                    ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(padding: EdgeInsets.fromLTRB(8, 17, 8, 3),child: Text('Hobbies: ',style: TextStyle(fontSize: 14),),),
                    Padding(padding: EdgeInsets.fromLTRB(8, 2, 8, 0),child: Text("${hobbies.join(', ')}",style: TextStyle(fontSize: 22),),),


                  ],
                )
                    : CircularProgressIndicator(),
              ),),





            Padding(padding: EdgeInsets.fromLTRB(8, 2, 8, 4),
              child:  Container(
                decoration:BoxDecoration(
                    border: Border.all(
                        width: 2.0,
                        color: Colors.black12
                    )


                ),
                height: 70,
                width: MediaQuery.of(context).size.width,
                child: _education != null
                    ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(padding: EdgeInsets.fromLTRB(8, 17, 8, 3),child: Text('Education: ',style: TextStyle(fontSize: 14),),),
                    Padding(padding: EdgeInsets.fromLTRB(8, 2, 8, 0),child: Text("$_education",style: TextStyle(fontSize: 22),),),

                  ],
                )
                    : CircularProgressIndicator(),
              ),),





            Padding(padding: EdgeInsets.fromLTRB(8, 2, 8, 4),
              child:  Container(
                decoration:BoxDecoration(
                    border: Border.all(
                        width: 2.0,
                        color: Colors.black12
                    )


                ),
                height: 70,
                width: MediaQuery.of(context).size.width,
                child: prof != null
                    ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(padding: EdgeInsets.fromLTRB(8, 17, 8, 3),child: Text('Profession: ',style: TextStyle(fontSize: 14),),),
                    Padding(padding: EdgeInsets.fromLTRB(8, 2, 8, 0),child: Text("$prof",style: TextStyle(fontSize: 22),),),

                  ],
                )
                    : CircularProgressIndicator(),
              ),),




            Padding(padding: EdgeInsets.fromLTRB(8, 2, 8, 4),
              child:  Container(
                decoration:BoxDecoration(
                    border: Border.all(
                        width: 2.0,
                        color: Colors.black12
                    )


                ),
                height: 70,
                width: MediaQuery.of(context).size.width,
                child: place != null
                    ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(padding: EdgeInsets.fromLTRB(8, 17, 8, 3),child: Text('Place: ',style: TextStyle(fontSize: 14),),),
                    Padding(padding: EdgeInsets.fromLTRB(8, 2, 8, 0),child: Text("$place",style: TextStyle(fontSize: 22),),),

                  ],
                )
                    : CircularProgressIndicator(),
              ),),






            Padding(padding: EdgeInsets.fromLTRB(8, 2, 8, 4),
              child:  Container(
                decoration:BoxDecoration(
                    border: Border.all(
                        width: 2.0,
                        color: Colors.black12
                    )


                ),
                height: 70,
                width: MediaQuery.of(context).size.width,
                child: smoke != null
                    ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(padding: EdgeInsets.fromLTRB(8, 17, 8, 3),child: Text('Smoke: ',style: TextStyle(fontSize: 14),),),
                    Padding(padding: EdgeInsets.fromLTRB(8, 2, 8, 0),child: Text("$smoke",style: TextStyle(fontSize: 22),),),

                  ],
                )
                    : CircularProgressIndicator(),
              ),),






            Padding(padding: EdgeInsets.fromLTRB(8, 2, 8, 4),
              child:  Container(
                decoration:BoxDecoration(
                    border: Border.all(
                        width: 2.0,
                        color: Colors.black12
                    )


                ),
                height: 70,
                width: MediaQuery.of(context).size.width,
                child: diet != null
                    ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(padding: EdgeInsets.fromLTRB(8, 17, 8, 3),child: Text('Diet: ',style: TextStyle(fontSize: 14),),),
                    Padding(padding: EdgeInsets.fromLTRB(8, 2, 8, 0),child: Text("$diet",style: TextStyle(fontSize: 22),),),

                  ],
                )
                    : CircularProgressIndicator(),
              ),),






            Padding(padding: EdgeInsets.fromLTRB(8, 2, 8, 4),
              child:  Container(
                decoration:BoxDecoration(
                    border: Border.all(
                        width: 2.0,
                        color: Colors.black12
                    )


                ),
                height: 70,
                width: MediaQuery.of(context).size.width,
                child: drink != null
                    ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(padding: EdgeInsets.fromLTRB(8, 17, 8, 3),child: Text('Drink: ',style: TextStyle(fontSize: 14),),),
                    Padding(padding: EdgeInsets.fromLTRB(8, 2, 8, 0),child: Text("$drink",style: TextStyle(fontSize: 22),),),

                  ],
                )
                    : CircularProgressIndicator(),
              ),),






          ],
        ),
      ),
    );
  }
}



class PlansPage extends StatefulWidget {

  final int id;
  const PlansPage({super.key,required this.id});

  // Constructor to receive the user ID from the previous page
  @override
  _PlansPageState createState() => _PlansPageState();
}

class _PlansPageState extends State<PlansPage> {


  final TextEditingController amountController = TextEditingController();
  Razorpay _razorpay = Razorpay();

  Razorpay _razorpay1 = Razorpay();
  Razorpay _razorpay2 = Razorpay();
  // Replace with actual user email

  @override
  void initState() {
    super.initState();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    _razorpay1.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess1);
    _razorpay1.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError1);
    _razorpay1.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet1);
    _razorpay2.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess2);
    _razorpay2.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError2);
    _razorpay2.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet2);




  }

  @override
  void dispose() {
    _razorpay.clear();
    _razorpay1.clear();
    _razorpay2.clear();

    super.dispose();
  }

  Future<void> addPlan() async {


    final Uri url = Uri.parse('http://192.168.133.76:3100/plan?userId=${widget.id}&plan=Basic');

    final response = await http.post(url);

    if (response.statusCode == 200) {
      // Plan added successfully
      print('Plan added successfully');
    } else {
      // Error adding plan
      print('Error adding plan: ${response.body}');
    }
  }



  Future<void> addPlan1() async {


    final Uri url = Uri.parse('http://192.168.133.76:3100/plan?userId=${widget.id}&plan=Advanced');

    final response = await http.post(url);

    if (response.statusCode == 200) {
      // Plan added successfully
      print('Plan added successfully');
    } else {
      // Error adding plan
      print('Error adding plan: ${response.body}');
    }
  }



  Future<void> addPlan2() async {


    final Uri url = Uri.parse('http://192.168.133.76:3100/plan?userId=${widget.id}&plan=Advanced++');

    final response = await http.post(url);

    if (response.statusCode == 200) {
      // Plan added successfully
      print('Plan added successfully');
    } else {
      // Error adding plan
      print('Error adding plan: ${response.body}');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Handle successful payment
    addPlan();
    print('Payment Successful: ${response.paymentId}');

    // Update the user's balance using the API

  }
  void _handlePaymentSuccess1(PaymentSuccessResponse response) {
    // Handle successful payment
    addPlan1();
    print('Payment Successful: ${response.paymentId}');

    // Update the user's balance using the API

  }
  void _handlePaymentSuccess2(PaymentSuccessResponse response) {
    // Handle successful payment
    addPlan2();
    print('Payment Successful: ${response.paymentId}');

    // Update the user's balance using the API

  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Handle payment failure
    print('Payment Error: ${response.message}');
  }

  void _handlePaymentError1(PaymentFailureResponse response) {
    // Handle payment failure
    print('Payment Error: ${response.message}');
  }

  void _handlePaymentError2(PaymentFailureResponse response) {
    // Handle payment failure
    print('Payment Error: ${response.message}');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Handle external wallet usage
    print('External Wallet: ${response.walletName}');
  }
  void _handleExternalWallet1(ExternalWalletResponse response) {
    // Handle external wallet usage
    print('External Wallet: ${response.walletName}');
  }
  void _handleExternalWallet2(ExternalWalletResponse response) {
    // Handle external wallet usage
    print('External Wallet: ${response.walletName}');
  }



  void _openRazorpay() {
    int amount = 10000; // Amount in paisa

    var options = {
      'key': 'rzp_test_NeP3oUSyPpL26A', // Replace with your Razorpay key
      'amount': amount,
      'name': 'Your App Name',
      'description': 'Payment for services',
      'prefill': {'contact': '1234567890', },
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print('Error opening Razorpay: $e');
    }
  }






  void _openRazorpay1() {
    int amount = 50000; // Amount in paisa

    var options = {
      'key': 'rzp_test_NeP3oUSyPpL26A', // Replace with your Razorpay key
      'amount': amount,
      'name': 'Your App Name',
      'description': 'Payment for services',
      'prefill': {'contact': '1234567890', },
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay1.open(options);
    } catch (e) {
      print('Error opening Razorpay: $e');
    }
  }





  void _openRazorpay2() {
    int amount = 100000; // Amount in paisa

    var options = {
      'key': 'rzp_test_NeP3oUSyPpL26A', // Replace with your Razorpay key
      'amount': amount,
      'name': 'Your App Name',
      'description': 'Payment for services',
      'prefill': {'contact': '1234567890', },
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay2.open(options);
    } catch (e) {
      print('Error opening Razorpay: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body:SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [




            GestureDetector(
              child:  Padding(
                padding: EdgeInsets.fromLTRB(10,4,10,4),
                child: Stack(
                  children: [
                    Container(

                      decoration: BoxDecoration(
                          shape:BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Colors.yellow,Colors.blue,Colors.yellow],
                              stops: [0.1,0.6,1.0]
                          )
                      ),
                      height: 100,
                    ),
                    Positioned(
                        top: 30,
                        left: 20,
                        child: Text("Basic",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),)),
                    Positioned(
                        top: 40,
                        right: 20,
                        child: Text("Rs.100",style: TextStyle(fontSize: 20,),)),
                    Positioned(
                        top: 55,
                        left: 30,
                        child: Column(
                          children: [
                            Text("* Send upto 10 requests"),

                          ],
                        ))
                  ],
                ),
              ),
              onTap: _openRazorpay,
            ),


            SizedBox(height: 5,),


            GestureDetector(
              child: Padding(
                padding: EdgeInsets.fromLTRB(10,4,10,4),
                child:  Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          shape:BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Colors.yellow,Colors.blue,Colors.yellow],
                              stops: [0.1,0.6,1.0]
                          )
                      ),
                      height: 100,
                    ),
                    Positioned(
                        top: 30,
                        left: 20,
                        child: Text("Pro",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),)),
                    Positioned(
                        top: 40,
                        right: 20,
                        child: Text("Rs.500",style: TextStyle(fontSize: 20,),)),
                    Positioned(
                        top: 55,
                        left: 30,
                        child: Column(
                          children: [
                            Text("* Send upto 50 requests"),

                          ],
                        ))
                  ],
                ),
              ),
              onTap: _openRazorpay1,
            ),

            SizedBox(height: 5,),


            GestureDetector(
              child: Padding(
                padding: EdgeInsets.fromLTRB(10,4,10,4),
                child:  Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          shape:BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Colors.yellow,Colors.blue,Colors.yellow],
                              stops: [0.1,0.6,1.0]
                          )
                      ),
                      height: 100,
                    ),
                    Positioned(
                        top: 30,
                        left: 20,
                        child: Text("Pro+",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),)),
                    Positioned(
                        top: 40,
                        right: 20,
                        child: Text("Rs.1000",style: TextStyle(fontSize: 20,),)),
                    Positioned(
                        top: 55,
                        left: 30,
                        child: Column(
                          children: [
                            Text("* Send upto 100 requests"),

                          ],
                        ))
                  ],
                ),
              ),
              onTap: _openRazorpay2,
            ),

          ],
        ),
      )



    );

  }
}
