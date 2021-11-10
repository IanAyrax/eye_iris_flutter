import 'package:flutter/material.dart';
import 'package:eye_iris_app/screens/home_screen.dart';
import 'package:eye_iris_app/models/variable.dart';
import 'package:flutter/services.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:async/async.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';

class DetailScreen extends StatefulWidget {
  const DetailScreen({Key? key, required this.selectedIndex}) : super(key: key);
  final int selectedIndex;
  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  String resultAPI = "";
  bool loading = true;
  Future<bool> _requestPermission(Permission permission) async{
    if(await permission.isGranted){
      return true;
    }else{
      var result = await permission.request();
      if (result == PermissionStatus.granted){
        return true;
      }
    }
    return false;
  }

  upload(String fileName) async {
    Directory directory;
    try {
      if (Platform.isAndroid) {
        if (await _requestPermission(Permission.storage)) {
          directory = await getExternalStorageDirectory();
          String newPath = "";
          List<String> folders = directory.path.split("/");

          for (int x = 1; x < folders.length; x++) {
            String folder = folders[x];
            if (folder != "Android") {
              newPath += "/" + folder;
            } else {
              break;
            }
          }
          newPath = newPath + "/EyeIris";
          directory = Directory(newPath);
        } else {
          return false;
        }
      } else {
        if (await _requestPermission(Permission.photos)) {
          directory = await getTemporaryDirectory();
        } else {
          return false;
        }
      }
    }catch(e){
      print(e);
      return false;
    }

    File imageFile = File(directory.path + '/${fileName}');
    // open a bytestream
    var stream = new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    // get file length
    var length = await imageFile.length();

    // string to uri
    var uri = Uri.parse(linkAPIPredict);

    // create multipart request
    var request = new http.MultipartRequest("POST", uri);

    // multipart that takes file
    var multipartFile = new http.MultipartFile('image', stream, length,
        filename: basename(imageFile.path));

    // add file to multipart
    request.files.add(multipartFile);

    // send
    var response = await request.send();
    print(response.statusCode);

    var responsed = await http.Response.fromStream(response);
    Map<String, dynamic> responseData = json.decode(responsed.body);

    if(response.statusCode == 200){
      print("SUCCESS");
      print(responseData['result']);
      resultAPI = responseData['result'];
      setState((){ loading = false; });
    }else{
      print("ERROR");
    }

    return true;
    // listen for response
    // response.stream.transform(utf8.decoder).listen((value) {
    //   print(value);
    //   result = value;
    // });
  }

  @override
  void initState(){
    upload("input.jpg");
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    if(loading)
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    else
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 30.0),
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 20.0, right: 120.0),
              child: Text(
                  'Detail Index ' + widget.selectedIndex.toString(),
                  style : TextStyle(
                    fontSize : 30.0,
                    fontWeight: FontWeight.bold,
                  )
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20.0, right: 120.0),
              child: Text(
                  resultAPI,
                  style : TextStyle(
                    fontSize : 30.0,
                    fontWeight: FontWeight.bold,
                  )
              ),
            ),
            SizedBox(height: 40.0),
            // Column(
            //   mainAxisAlignment: MainAxisAlignment.spaceAround,
            //   children: _icons.asMap().entries.map((MapEntry map) => _buildIcon(map.key)
            //   ).toList(),
            // ),
            SizedBox(height: 20.0),
            ElevatedButton(
                child: Text(
                    "Back to Home",
                    style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                    )
                ),
                style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: BorderSide(color: Colors.blue, width: 1000)
                        )
                    )
                ),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    //TODO: ADD route to detail page
                    builder: (_) => HomeScreen(),
                  ),
                ),
            )
            //ResultCarousel(),
          ],
        ),
      ),
    );
  }
}