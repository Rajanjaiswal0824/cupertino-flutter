// @dart=2.9
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
      ),
      home: physicalInspectionDetails3(),
    );
  }
}

// ignore: camel_case_types
class physicalInspectionDetails3 extends StatefulWidget {
  @override
  _physicalInspectionDetails3State createState() =>
      new _physicalInspectionDetails3State();
}

// ignore: camel_case_types
class _physicalInspectionDetails3State
    extends State<physicalInspectionDetails3> {
  TextEditingController _information = TextEditingController();
  TextEditingController _latitude = TextEditingController();
  TextEditingController _longitude = TextEditingController();
  TextEditingController _latitude2 = TextEditingController();
  TextEditingController _longitude2 = TextEditingController();
  String fileName;
  String path;
  Map<String, String> paths;
  String extensions;
  bool isLoadingPath = false;
  bool isMultiPick = false;
  bool hasValidMime = false;
  FileType fileType;
  TextEditingController _controller =TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() =>
    extensions = _controller.text);
  }

  void _openFileExplorer() async {
    if (fileType != FileType.custom || hasValidMime) {
      setState(() => isLoadingPath = true);
      try {
        if (isMultiPick) {
          path = null;
          paths = await FilePicker.getMultiFilePath(type: fileType != null? fileType: FileType.custom, allowedExtensions:['pdf']);
        }
        else {
          paths = null;
          path = await FilePicker.getFilePath(
              type: fileType != null? fileType: FileType.custom, allowedExtensions: ['pdf']);
        }
      }
      on PlatformException catch (e) {
        print("Unsupported operation" + e.toString());
      }
      if (!mounted) return;
      setState(() {
        isLoadingPath = false;
        fileName = path != null ? path
            .split('/')
            .last : paths != null
            ? paths.keys.toString() : '...';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          title: new Text("Physical Inspection Details"),
          flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: loginGradients),
              )),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: Colors.white,
            onPressed: () {
              Navigator.of(context).pop(null);
            },
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(left: 15.0, right: 15, top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Any other information/Issues"),
              SizedBox(
                height: height / 90,
              ),
              Container(
                width: double.infinity,
                height: height / 15,
                margin: const EdgeInsets.only(left: 8.0, right: 8.0),
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.0),
                    color: Colors.white,
                    boxShadow: [BoxShadow(blurRadius: 0, color: Colors.grey)]),
                child: TextFormField(
                  controller: _information,
                  decoration: InputDecoration(border: InputBorder.none),
                  maxLines: 1,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Plot size as per measurment';
                    }
                    return null;
                  },
                ),
              ),
              Divider(
                thickness: 1,
              ),
              SizedBox(
                height: height / 90,
              ),
              Text("Inspection Report"),
              SizedBox(
                height: height / 90,
              ),
              Container(
                  width: double.infinity,
                  height: height / 20,
                  margin: const EdgeInsets.only(left: 8.0, right: 8.0),
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.0),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(blurRadius: 0, color: Colors.grey)
                      ]),
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 7),
                        width: width / 4.7,
                        height:height / 25,
                        child: MaterialButton(
                          onPressed: () {
                            _openFileExplorer();
                          },
                          color: Colors.grey[300],
                          shape: RoundedRectangleBorder(
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(1.0),
                              )),
                          child: Text(
                            "Choose file",
                            style: TextStyle(color: Colors.black, fontSize: 10),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: width / 60,
                      ),
                      Text(
                          "No file chosen"
                      )
                    ],
                  )),
              new Builder(
                builder: (BuildContext context) => isLoadingPath ? Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: const CircularProgressIndicator(),
                ):path != null || paths != null ? new Container(
                  padding: const EdgeInsets.only(bottom: 30.0),
                  height: MediaQuery.of(context).size.height * 0.50,
                  child: new Scrollbar(
                      child: new ListView.separated(
                        itemCount: paths != null && paths.isNotEmpty ? paths.length : 1,
                        itemBuilder: (BuildContext context, int index) {
                          final bool isMultiPath = paths != null && paths.isNotEmpty;
                          final int fileNo = index + 1;
                          final String name = ('File $fileNo : ' +
                              (isMultiPath ? paths.keys.toList()[index] : fileName ?? '...'));
                          final filePath = isMultiPath
                              ? paths.values.toList()[index].toString() : path;
                          return new ListTile(title: new Text(name,),
                            subtitle: new Text(filePath),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) => new Divider(),
                      )),
                )
                    : new Container(),)
            ],
          ),
        ));
  }
}

const List<Color> loginGradients = [
  Color(0xFF132954),
  Color(0xFF132954),
];
