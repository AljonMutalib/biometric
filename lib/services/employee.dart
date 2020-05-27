class Employee{
  String id;
  String empID;
  String period;
  String nday;
  String inAm;
  String outAm;
  String inPm;
  String outPm; 

  Employee({
    this.id,
    this.empID,
    this.period,
    this.nday,
    this.inAm,
    this.outAm,
    this.inPm,
    this.outPm
  });
  factory Employee.fromJson(Map<String, dynamic> json){
    return Employee(
      id: json['ID'] as String,
      empID: json['emp_ID'] as String,
      period: json['period'] as String,
      nday: json['nday'] as String,
      inAm: json['in_am'] as String,
      outAm: json['out_am'] as String,
      inPm: json['in_pm'] as String,
      outPm: json['out_pm'] as String,
    );
  }
}