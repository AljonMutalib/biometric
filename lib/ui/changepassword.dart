import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import './dtr.dart';
import './biometric.dart';
import './login.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:encrypt/encrypt.dart';

class ChangePasswordPage extends StatefulWidget {
  ChangePasswordPage({Key key, 
    this.username,
    this.password, 
    this.fname, 
    this.lname, 
    this.id
  }) : super(key: key);
  final String username;
  final String password;
  final String fname;
  final String lname;
  final String id;
  
  @override
  ChangePasswordPageState createState() => ChangePasswordPageState();
}
 
class ChangePasswordPageState extends State<ChangePasswordPage> {
  
  bool visible = false ;

  String mes='';
  
  final _formKey = GlobalKey<FormState>();

  bool _showcurrent = false;
  bool _shownew = false;

  final currentpass = TextEditingController();
  final newpass = TextEditingController();
  
  Future<String> logout() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(
            'Logout!',
            style: TextStyle(fontSize: 14),
          ),
          actions: <Widget>[
            FlatButton(
              child: new Text("Ok"),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(
                      
                    )
                  )
                );
              },
            ),
          ],
        );
      },
    );
  }

  Future<String> changePass() async {
    
    String password = newpass.text;
    String id = widget.id;
    
    var url = 'http://58.69.90.12/biometric/db/updatePass.php';
    var data = {'ID': id, 'password' : password}; 
    
    try {
      var response = await http.post(url, body: json.encode(data));
      if (200 == response.statusCode) {
        setState(() {
          visible = false;
          mes= 'Password changed.'; 
        });
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.clear();
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
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginPage()
                      )
                    );
                  },
                ),
              ],
            );
          },
        );
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }

 @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return new Future(() => false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Change Password'), // we show the progress in the title...
        ),
        drawer: Drawer(
          child: ListView(
            children: <Widget> [
              DrawerHeader(
                margin: EdgeInsets.zero,
                padding: EdgeInsets.zero,
                decoration: BoxDecoration(
                  color: Colors.red
                ),
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      bottom: 60,
                      left: 16,
                      child: CircleAvatar(
                        maxRadius: 35,
                        backgroundColor: Colors.transparent,
                        child: Image.asset('assets/logo_dict.png',)
                      ),
                    ),
                    Positioned(
                      bottom: 12.0,
                      left: 16.0,
                      child: Row(
                        children: <Widget>[
                          Text(
                            widget.fname,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22.0,
                              fontWeight: FontWeight.w500
                            ),
                          ),
                          Text(' '),
                          Text(
                            widget.lname,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22.0,
                              fontWeight: FontWeight.w500
                            ),
                          ),
                        ]
                      )
                    ),
                  ],
                )
              ),
              ListTile(
                title: GestureDetector(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BiometricPage(
                        username: widget.username,
                        password: widget.password,
                        lname: widget.lname,
                        fname: widget.fname,
                        id: widget.id,
                      )),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Icon(
                        Icons.fingerprint,
                        color: Colors.red,
                        size: 18,
                      ),
                      Text(' Biometric',
                       style: TextStyle(
                          color: Colors.red,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                    ],
                  ),
                )
              ),
              ListTile(
                title: GestureDetector(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DtrPage(
                        username: widget.username,
                        password: widget.password,
                        lname: widget.lname,
                        fname: widget.fname,
                        id: widget.id,
                      )),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Icon(
                        Icons.print,
                        color: Colors.red,
                        size: 18,
                      ),
                      Text(' Daily Time Report',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Icon(
                      Icons.settings,
                      color: Colors.red,
                      size: 18,
                    ),
                    Text(' Change Password',
                     style: TextStyle(
                        color: Colors.red,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500
                      ),
                    ),
                  ],
                )
              ),
              ListTile(
                title: GestureDetector(
                  onTap: logout,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Icon(
                        Icons.arrow_back,
                        color: Colors.red,
                        size: 18,
                      ),
                      Text('Logout',
                       style: TextStyle(
                          color: Colors.red,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                    ],
                  ),
                )
              ),
            ]
          ),
        ),
        body: Container(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 20,),
                  Container(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      'Current Password', 
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 18.0
                      ),
                    )
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: 
                      TextFormField(
                        controller: currentpass,
                        obscureText: !this._showcurrent,
                        decoration: InputDecoration(
                          hintText: 'Current Password.',
                          suffixIcon: IconButton(
                            icon: Icon(
                              Icons.remove_red_eye,
                              color: this._showcurrent ? Colors.red : Colors.grey,
                            ),
                            onPressed: (){
                              setState(() {
                                this._showcurrent = !this._showcurrent;
                              });
                            },
                          )
                        ),
                        validator: (value) {
                        if (value != widget.password) {
                          return 'Incorrect Current Password!';
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
                      'New Password', 
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 18.0
                      ),
                    )
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: TextFormField(
                      controller: newpass,
                      obscureText: !this._shownew,
                      decoration: InputDecoration(
                        hintText: 'New Password.',
                        suffixIcon: IconButton(
                            icon: Icon(
                              Icons.remove_red_eye,
                              color: this._shownew ? Colors.red : Colors.grey,
                            ),
                            onPressed: (){
                              setState(() {
                                this._shownew = !this._shownew;
                              });
                            },
                          )
                      ),
                      validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter your New Password.';
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
                        onPressed: (){
                          if (_formKey.currentState.validate()) {
                            changePass();
                          }
                        },
                        textColor: Colors.white,
                        color: Colors.red,
                        padding: const EdgeInsets.all(20.0),
                        child: new Text(
                          "Change Password",
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}