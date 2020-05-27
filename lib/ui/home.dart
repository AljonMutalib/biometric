import './biometric.dart';
import 'package:flutter/material.dart';
import './login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login', 
      theme: ThemeData(primaryColor: Colors.red, backgroundColor: Colors.black),    
      home: susername != null  ? BiometricPage(username : susername, password: spassword, fname: sfname, lname: slname,id: sid,) : LoginPage(),
    );
  }
}

