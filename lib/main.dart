import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData (
      brightness: Brightness.dark,
      primaryColor: Colors.deepOrange,
      accentColor: Colors.grey
    ),
    home: MyApp (),
  ));
}

class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  String courseCode, examType, date;

  getCourseCode(code) {
    this.courseCode = code;
  }

  getExamType(type) {
    this.examType = type;
  }

  getDate(date) {
    this.date = date;
  }

  createData() {

    DocumentReference documentReference = Firestore.instance.collection("Exams")
        .document(courseCode);


    Map <String, dynamic> exams = {
      "courseCode": courseCode,
      "examType": examType,
      "date": date
    };
    documentReference.setData(exams).whenComplete(() =>
        print("$exams created"));
  }



  updateData() {
    DocumentReference documentReference = Firestore.instance.collection("Exams")
        .document(courseCode);

    Map <String, dynamic> exams = {
      "courseCode": courseCode,
      "examType": examType,
      "date": date
    };
    documentReference.setData(exams).whenComplete(() =>
        print("$exams updated"));
  }

  deleteData() {
    DocumentReference documentReference =
    Firestore.instance.collection("Exams").document(courseCode);

    documentReference.delete().whenComplete(() => print("$courseCode deleted"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Exam Dates"),
        ),
        body: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(5.0),
                child: TextFormField(
                  decoration: InputDecoration(
                      labelText: "Course Code",
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.cyanAccent,
                              width: 2.0)
                      )
                  ),
                  onChanged: (String code) {
                    getCourseCode(code);
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(5.0),
                child: TextFormField(
                  decoration: InputDecoration(
                      labelText: "Exam Type",
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.cyanAccent,
                              width: 2.0)
                      )
                  ),
                  onChanged: (String type) {
                    getExamType(type);
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(5.0),
                child: TextFormField(
                  decoration: InputDecoration(
                      labelText: "Date",
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.cyanAccent,
                              width: 2.0)
                      )
                  ),
                  onChanged: (String date) {
                    getDate(date);
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RaisedButton(
                    color: Colors.cyan,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Text("Create"),
                    textColor: Colors.white,
                    onPressed: () {
                      createData();
                    },
                  ),
                  RaisedButton(
                    color: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Text("Update"),
                    textColor: Colors.white,
                    onPressed: () {
                      updateData();
                    },
                  ),
                  RaisedButton(
                    color: Colors.red,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Text("Delete"),
                    textColor: Colors.white,
                    onPressed: () {
                      deleteData();
                    },
                  )
                ],
              ),
              StreamBuilder(
                  stream: Firestore.instance.collection("Exams").snapshots(),
                  // ignore: missing_return
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data.documents.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot documentSnapshot = snapshot.data
                                .documents[index];
                            return Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(documentSnapshot["courseCode"]),
                                ),
                                Expanded(
                                  child: Text(documentSnapshot["examType"]),
                                ),
                                Expanded(
                                  child: Text(documentSnapshot["date"]),
                                )
                              ],
                            );
                          });
                    }
                  }
              )
            ],
          ),
        )
    );
  }
}