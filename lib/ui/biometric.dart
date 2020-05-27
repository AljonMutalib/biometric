import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as paths;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './dtr.dart';
import './login.dart';
import './changepassword.dart';
import 'package:http/http.dart' as http;

class BiometricPage extends StatefulWidget {

  BiometricPage({Key key, this.username, this.password, this.fname, this.lname, this.id}) : super(key: key);
  
  final String password;
  final String username;
  final String fname;
  final String lname;
  final String id;
  
  @override
  _BiometricPageState createState() => _BiometricPageState();
}

class _BiometricPageState extends State<BiometricPage> {  
  
  String mes='';
  CameraController _controller;
  Future<void> _initializeControllerFuture;
  bool isCameraReady = false;
  bool showCapturedPhoto = false;
  var ImagePath;


  String status = '';
  String base64Image;
  String errMessage = 'Error Uploading Image';
 
  @override
  void initState() {
    super.initState();
    _initializeCamera();   
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _controller != null
          ? _initializeControllerFuture = _controller.initialize()
          : null; //on pause camera is disposed, so we need to call again "issue is only for android"
    }
  }

  setStatus(String message) {
    setState(() {
      status = message;
    });
  }

  bool visible = false ;

  Future addTimeIn() async{
    setState(() {
      visible = true ; 
   });
  
    String id = widget.id;
    
    var url = 'http://58.69.90.12/biometric/db/addDTR.php';
    var data = {'id': id};

    try {
      var response = await http.post(url, body: json.encode(data));
      print('addEmployee Response: ${response.body}');
      if (200 == response.statusCode) {
        try {
          final path = paths.join(
            (await getTemporaryDirectory()).path, //Temporary path
            '$lname${DateTime.now()}.png',
          );
          ImagePath = path;
          await _controller.takePicture(path); //take photo
          
          print(ImagePath);

          // Code for Uploading Image Starts Here
          var now = new DateTime.now();
          var formatter = new DateFormat('yyyy-MM-dd-hh-mm');
          String formattedDate = formatter.format(now);
          String iN='In';

          String fname = widget.lname;
          String fileName = '$fname$formattedDate$iN.png';
          
          List<int> imageBytes = File(ImagePath).readAsBytesSync();
          String base64Image = base64Encode(imageBytes);
          
          var url2 = 'http://58.69.90.12/biometric/db/image/upload.php';
          var data2 = {'image': base64Image, 'name' : fileName};           
          
          print(fileName);
          print(base64Image);
          http.post(url2, body: data2).then((result) {
            setStatus(result.statusCode == 200 ? result.body : errMessage);
          }).catchError((error) {
            setStatus(error);
          });
          // Code for uploading Image Ends Here

          setState(() {
            showCapturedPhoto = true;
          });
        } catch (e) {
          print(e);
        }
        setState(() {
          visible = false;
          mes= 'Thank you! Signed in!';
          showCapturedPhoto = false; 
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
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      setState(() {
        visible = false;
        mes= 'Something went wrong!'; 
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
      return "error";
    }
  }
  Future addTimeOut() async{
    setState(() {
      visible = true ; 
    });
  
    String id = widget.id;
    
    var url = 'http://58.69.90.12/biometric/db/addDTRout.php';
    var data = {'id': id};
    
    try {
      var response = await http.post(url, body: json.encode(data));
      print('addEmployee Response: ${response.body}');
      if (200 == response.statusCode) {
        try {
          final path = paths.join(
            (await getTemporaryDirectory()).path, //Temporary path
            '$lname${DateTime.now()}.png',
          );
          ImagePath = path;await _controller.takePicture(path); //take photo
          setState(() {
            showCapturedPhoto = true;
          });
          var now = new DateTime.now();
          var formatter = new DateFormat('yyyy-MM-dd-hh-mm');
          String formattedDate = formatter.format(now);
          String out = 'Out';

          String fname = widget.lname;
          String fileName = '$fname$formattedDate$out.png';
          
          List<int> imageBytes = File(ImagePath).readAsBytesSync();
          String base64Image = base64Encode(imageBytes);
          
          var url2 = 'http://58.69.90.12/biometric/db/image/upload.php';
          var data2 = {'image': base64Image, 'name' : fileName};           
          
          print(fileName);
          print(base64Image);
          http.post(url2, body: data2).then((result) {
            setStatus(result.statusCode == 200 ? result.body : errMessage);
          }).catchError((error) {
            setStatus(error);
          });
        } catch (e) {
          print(e);
        }
        setState(() {
          visible = false;
          mes= 'Thank you! Signed Out!';
          showCapturedPhoto = false; 
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
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      setState(() {
        visible = false;
        mes= 'Something went wrong!'; 
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
      return "error";
    }
  }
  
  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras[1];
    _controller = CameraController(firstCamera,ResolutionPreset.high, enableAudio: false);
    _initializeControllerFuture = _controller.initialize();
    if (!mounted) {
      return;
    }
    setState(() {
      isCameraReady = true;
    });
  }
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
  
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final deviceRatio = size.width / size.height;
    return WillPopScope(
      onWillPop: () {
        return new Future(() => false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Biometric'),
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
                title: Row(
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
                )
              ),
              ListTile(
                title: GestureDetector(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChangePasswordPage(
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
                  ),
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
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 70),
                showCapturedPhoto == false ?
                Container(
                  height: 300,
                  child: FutureBuilder<void>(
                    future: _initializeControllerFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return Transform.scale(
                            scale: _controller.value.aspectRatio / deviceRatio,
                            child: Center(
                              child: AspectRatio(
                                aspectRatio: _controller.value.aspectRatio,
                                child: CameraPreview(_controller), //cameraPreview
                              ),
                            ));
                      } else {
                        return Center(
                          child: CircularProgressIndicator());
                      }
                    },
                  ),                  
                ) 
                :
                Center(
                  child: Container(
                    height: 400,
                    child: Image.file(File(ImagePath))
                  )
                ),
                const SizedBox(height: 70),
                Container(
                  width: double.infinity,
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: 320,
                        child: new RaisedButton(
                          elevation: 4,
                          padding: const EdgeInsets.all(20.0),
                          textColor: Colors.white,
                          color: Colors.blue,
                          onPressed: () {addTimeIn();},
                          child: new Text("Time In"),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: 320,
                        child: new RaisedButton(
                          onPressed: () {addTimeOut();},
                          textColor: Colors.white,
                          color: Colors.red,
                          padding: const EdgeInsets.all(20.0),
                          child: new Text(
                            "Time Out",
                          ),
                        ),
                      ),
                      Visibility(
                        visible: visible, 
                        child: Container(
                          color: Colors.transparent,
                          margin: EdgeInsets.only(bottom: 100),
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.transparent,
                          )
                          )
                        ),
                    ],
                  ),
                )
              ]
            ),
          ),
        ),
      ),
    );
  }
  
}
