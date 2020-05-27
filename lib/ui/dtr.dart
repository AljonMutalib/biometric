import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/employee.dart';
import './biometric.dart';
import './changepassword.dart';
import './login.dart';

class DtrPage extends StatefulWidget {
  DtrPage({Key key, 
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
  
  final String title = 'Daily Time Report';
 
  @override
  DtrPageState createState() => DtrPageState();
}
 
class DtrPageState extends State<DtrPage> {
  
  bool visible = false ;

  final monthController = TextEditingController();
  final yearController = TextEditingController();
  
  List<Employee> _employees;
  GlobalKey<ScaffoldState> _scaffoldKey;
  String _titleProgress;
  
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

  //static const ROOT = 'http://58.69.90.12/biometric/db/dtr.php';
  Future<List<Employee>> getEmployees() async {
    setState(() {
      visible = true ; 
    });
    String month = monthController.text;
    String year = yearController.text;
    String id = widget.id;
    
    var url = 'http://58.69.90.12/biometric/db/dtr.php';
    var data = {'month': month, 'year' : year, 'id': id}; 
    try {
      var response = await http.post(url, body: json.encode(data));
      print('getEmployees Response: ${response.body}');
      if (response.statusCode == 200) {
        setState(() {
          visible = false ; 
        });
        List<Employee> employee = parseResponse(response.body);
        return employee;

      } else {
        setState(() {
          visible = false ; 
        });
        return List<Employee>();
      }
    } catch (e) {
      setState(() {
          visible = false ; 
        });
      return List<Employee>();
    }
  } 
  static List<Employee> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Employee>((json) => Employee.fromJson(json)).toList();
  }

  @override
  void initState() {
    super.initState();
    _employees = [];
    _titleProgress = widget.title;
    _scaffoldKey = GlobalKey(); // key to get the context to show a SnackBar
    _getEmployees();
  }
 
  // Method to update title in the AppBar Title
  _showProgress(String message) {
    setState(() {
      _titleProgress = message;
    });
  }
 
  _getEmployees() {
    _showProgress('Loading Employees...');
    getEmployees().then((employee) {
      setState(() {
        _employees = employee;
      });
      _showProgress(widget.title); // Reset the title...
      print("Length ${employee.length}");
      print(employee);
    });
  }
  SingleChildScrollView _dataBody() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(
              label: Text('Period'),
            ),
            DataColumn(
              label: Text('Day'),
            ),
            DataColumn(
              label: Text('In'),
            ),
            DataColumn(
              label: Text('Out'),
            ),
            DataColumn(
              label: Text('In'),
            ),
            DataColumn(
              label: Text('Out'),
            ),
          ],
          rows: _employees
          .map(
            (employee) => DataRow(cells: [
              DataCell(
                Text(
                  employee.period,
                ),
              ),
              DataCell(
                Text(
                  employee.nday,
                ),
              ),
              DataCell(
                Text(
                  employee.inAm,
                ),
              ),
              DataCell(
                Text(
                  employee.outAm,
                ),
              ),
              DataCell(
                Text(
                  employee.inPm,
                ),
              ),
              DataCell(
                Text(
                  employee.outPm,
                ),
              ),
            ]),
          )
          .toList(),
        ),
      ),
    );
  }
 @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return new Future(() => false);
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(_titleProgress), // we show the progress in the title...
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
                title: Row(
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
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 140,
                   // child: DropdownButton(
                      
                    //  value: _btnmonth,
                    //  hint: Text('Month'),
                   //   onChanged: ((String newValue){
                   //     setState(() {
                   //       _btnmonth = newValue;
                   //     });
                    //  }),
                    //    items: _dropDownMonthItems,
                    //),
                    child: TextField(
                      controller: monthController,
                      decoration: InputDecoration(
                        hintText: 'Month'
                      )
                    ),
                  ),
                  Text('  '),
                  Container(
                    width: 140,
                    child: TextField(
                      controller: yearController,
                      decoration: InputDecoration(
                        hintText: 'Year'
                      )
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20,),
              Center(
                child: Container(
                  width: 200,
                  child: new RaisedButton(
                    onPressed: (){_getEmployees();},//userLogin,
                    textColor: Colors.white,
                    color: Colors.red,
                    padding: const EdgeInsets.all(20.0),
                    child: new Text(
                      "Generate",
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Visibility(
                visible: visible, 
                child: Container(
                  color: Colors.transparent,
                  margin: EdgeInsets.all(0),
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.transparent,
                  )
                  )
                ),
              Expanded(
                child: _dataBody(),
              ),     
            ],
          ),
        ),
      ),
    );
  }
}