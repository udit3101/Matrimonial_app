import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:http/http.dart'as http;
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
  body:Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [



          SizedBox(height: 25,),

         Row(
           mainAxisAlignment: MainAxisAlignment.end,

           children: [
             IconButton(
               onPressed: (){
                 Navigator.pop(context);
               },
               icon: Icon(Icons.clear ),
               color: Colors.redAccent,
               iconSize: 35,
             ),
           ],
         ),
          SizedBox(height: 20,),

          Center(
            child: Text("Subscribe",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 26,color: Colors.deepPurple),),
          ),
          SizedBox(height: 15,),

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



    );

  }
}