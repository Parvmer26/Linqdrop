import 'dart:async';

import 'package:flutter/material.dart';
import 'package:linqdrop/pages/home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Timer(Duration(seconds: 4),(){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage()));
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.black,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(image: AssetImage('assets/appicon.png'),height: 200,width: 200,),
              SizedBox(height: 50,),
              Text('Linqdrop',style: TextStyle(fontSize: 38,fontWeight: FontWeight.w800,color: Colors.white)),
              SizedBox(height: 2),
              Text('offline peer-to-peer sharing',style: TextStyle(fontSize: 17,fontWeight: FontWeight.w500,color: Colors.white))
            ],
          ),
        ),
      ),
    );
  }
}
