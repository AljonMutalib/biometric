import 'dart:async';
import 'package:biometric/ui/biometric.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './login.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String slname;
  String susername;
  String sfname;
  String sid;
  String spassword;

  @override
  initState() {
    super.initState();
    getUser();
    getPass();
    getLname();
    getFname();
    getID();
    Timer(Duration(seconds: 2), () {
       navigateFromSplash();
    });
  }

  getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var username = prefs.getString('username');
    setState(() {
      susername = username;
    });
  }
  getPass() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var password = prefs.getString('password');
    setState(() {
      spassword = password;
    });
  }
  getLname() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var lname = prefs.getString('lname');
    setState(() {
      slname = lname;
    });
  }
  getFname() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var fname = prefs.getString('fname');
    setState(() {
      sfname = fname;
    });
  }
  getID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString('id');
    setState(() {
      sid = id;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
        child: Container(
          color: Colors.transparent,
          child: Image.asset("assets/logo_splash.png")
        )
      )
    );
  }

  Future navigateFromSplash () async {
    if(susername ==null){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
    }else{
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BiometricPage(username : susername, password: spassword, fname: sfname, lname: slname,id: sid))); 
    }
  }
}