import 'dart:io';

import 'package:flutter/material.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:eye_iris_app/screens/detail_screen.dart';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController controller;

  Future<void> initializeCamera() async {
    var cameras = await availableCameras();
    //cameras[0] samadengan camera belakang
    controller = CameraController(cameras[1], ResolutionPreset.medium);
    await controller.initialize();
  }

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

  Future<bool> saveFile() async {
    Directory directory;
    try{
      if(Platform.isAndroid){
        if(await _requestPermission(Permission.storage)){
          directory = await getExternalStorageDirectory();
          String newPath = "";
          List<String> folders = directory.path.split("/");

          for (int x = 1; x < folders.length; x++){
            String folder = folders[x];
            if(folder != "Android"){
              newPath += "/" + folder;
            }else{
              break;
            }
          }
          newPath = newPath + "/EyeIris";
          directory = Directory(newPath);
        }else{
          return false;
        }
      } else {
        if(await _requestPermission(Permission.photos)){
          directory = await getTemporaryDirectory();
        }else{
          return false;
        }
      }

      if(!await directory.exists()){
        await directory.create(recursive: true);
      }

      if(await directory.exists()){
        try{
          controller.takePicture(directory.path + '/${DateTime.now()}.jpg');
        }catch(e){
          print(e);
          return false;
        }

        if(Platform.isIOS){
          await ImageGallerySaver.saveFile(directory.path, isReturnPathOfIOS: true);
        }

        return true;
        //return File(filePath);
        // print(directory.path);
        // //File saveFile = File(directory.path + "/$fileName");
        // try {
        //   saveFile = await saveFile.rename(directory.path);
        // } on FileSystemException catch(e){
        //   final newFile = await saveFile.copy(directory.path);
        //   await saveFile.delete();
        //   saveFile = newFile;
        // }

        //return true;
      }
      return false;
    }catch(e){
      print(e);
      return false;
    }
  }

  @override
  void dispose(){
    //Untuk remove controller saat ditutup
    controller.dispose();
    super.dispose();
  }

  Future<File?> takePicture() async {
    Directory root = await getTemporaryDirectory();
    String directoryPath = '${root.path}/Photo';
    await Directory(directoryPath).create(recursive: true);
    String filePath = '$directoryPath/${DateTime.now()}.jpg';

    try{
      controller.takePicture(filePath);
    }catch(e){
      return null;
    }

    return File(filePath);
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder(
        future: initializeCamera(),
        builder: (_, snapshot) =>
          (snapshot.connectionState == ConnectionState.done)
              ? Stack(
                children: [
                  Column(
                    children : [
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.width / controller.value.aspectRatio,
                        child : CameraPreview(controller),
                      ),
                      Container(
                        width: 70,
                        height: 70,
                        margin: EdgeInsets.only(top: 50),
                        child: RaisedButton(
                          onPressed: () async {
                            if(!controller.value.isTakingPicture){
                              //File? result = await takePicture();
                              await saveFile();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  //TODO: ADD route to detail page
                                  //TODO: Change selected index to non-static
                                  builder: (_) => DetailScreen(selectedIndex: 1),
                                ),
                              );
                            }
                          },
                          shape: CircleBorder(),
                          color: Colors.blue
                        ),
                      ),
                    ],
                  ),
                  Container(
                      alignment: Alignment.center,
                      child : SizedBox(
                        width: MediaQuery.of(context).size.width/3,
                        height: MediaQuery.of(context).size.width / controller.value.aspectRatio/3,
                        child: Image.asset(
                          'assets/images/eye-icon.png',
                          fit: BoxFit.fill,
                        ),
                      )
                  )
                ],
              )
              : Center(
                child: SizedBox(
                  height: 20,
                  width : 20,
                  child : CircularProgressIndicator(),
                ),
              ),
      ),
    );
  }
}