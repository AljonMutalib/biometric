import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import './biometric.dart';

String username='';
String fname='';
String lname='';
String id='';
String mes='';
String user='';
String pass='';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

bool _showpass = false;

final _formKey = GlobalKey<FormState>();

Future<bool> saveUser(String username) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("username", username);
  return prefs.commit();
}

Future<bool> savePass(String password) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("password", password);
  return prefs.commit();
}

Future<bool> saveFname(String fname) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("fname", fname);
  return prefs.commit();
}

Future<bool> saveLname(String lname) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("lname", lname);
  return prefs.commit();
}
Future<bool> saveID(String id) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("id", id);
  return prefs.commit();
}


//Login code start here
bool visible = false ;
final usernameController = TextEditingController();
final passwordController = TextEditingController();

Future userLogin() async{
  setState(() {
    visible = true ; 
  });
 
  String username = usernameController.text;
  String pass = passwordController.text;

  var url = 'http://58.69.90.12/biometric/db/login_user.php';
  
  var data = {'username': username, 'password' : pass};
 
  var response = await http.post(url, body: json.encode(data));
 
  var message = jsonDecode(response.body);
  
  if(message == 'Invalid Username or Password Please Try Again')
  {
    setState(() {
      visible = false;
      mes= 'Please check your Username & Password!'; 
    });
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(
            mes,
            style: TextStyle(fontSize: 14),
          ),
          actions: <Widget>[
            FlatButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }else{
    setState(() {
      visible = false;
      username= message['username'];
      //pass= message['password'];
      fname= message['fname'];
      lname= message['lname'];
      id= message['ID']; 
    });
    savePass(pass).then((bool committed){});
    saveLname(lname).then((bool committed){});
    saveFname(fname).then((bool committed){});
    saveID(id).then((bool committed){});
    saveUser(username).then((bool committed){
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BiometricPage(username : username, password: pass, fname: fname, lname: lname, id: id)
        )
      );
    }
    );
  }
}
//login code ends here
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return new Future(() => false);
      },
      child: Scaffold(
        //appBar: AppBar(title: Text("Login Form"),),
        body: Container(
          child: SingleChildScrollView(
            child: Form(          
              key: _formKey,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 100,),
                  Container(
                    width: 100,
                    child: Image.asset('assets/logo_dict.png'),
                  ),
                  SizedBox(height: 20,),
                  Container(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      'Username', 
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 18.0
                      ),
                    )
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: TextFormField(
                      controller: usernameController,
                      decoration: InputDecoration(
                        hintText: 'Username',
                      ),
                      validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter your username';
                      }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 20,),
                  Container(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      'Password', 
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 18.0
                      ),
                    )
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: TextFormField(
                      controller: passwordController,
                      obscureText: !this._showpass,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        suffixIcon: IconButton(
                          icon: Icon(
                            Icons.remove_red_eye,
                            color: this._showpass ? Colors.red : Colors.grey,
                          ),
                          onPressed: (){
                            setState(() {
                              this._showpass = !this._showpass;
                            });
                          },
                        )
                      ),
                      validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter your Password.';
                      }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 20,),
                  Center(
                    child: Container(
                      width: 350,
                      child: new RaisedButton(
                        //onPressed: userLogin,
                        onPressed: (){
                          if (_formKey.currentState.validate()) {
                            userLogin();
                          }
                        },
                        textColor: Colors.white,
                        color: Colors.red,
                        padding: const EdgeInsets.all(20.0),
                        child: new Text(
                          "Login",
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: visible, 
                    child: Container(
                      margin: EdgeInsets.only(bottom: 30),
                      child: CircularProgressIndicator()
                      )
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}