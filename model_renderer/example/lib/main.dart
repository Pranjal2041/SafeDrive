import 'package:flutter/material.dart';
import 'package:model_renderer/model_renderer.dart';
import 'package:model_renderer/ModelRenderingController.dart';
import 'package:model_renderer/data/CarParts.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ModelRenderingController modelPreviewController;
  var a;

  @override
  void initState() {
    initializeModelPreview();
    a = 0;
    super.initState();
  }

  initializeModelPreview() async {
    modelPreviewController = ModelRenderingController();


    if (mounted) {
      setState(() {});
    }
  }
  setData(){
    modelPreviewController.setColorData({CarParts.Right_View_Mirror:10,CarParts.Left_View_Mirror:12,CarParts.Front:11,CarParts.Back:24});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Plugin example app[ $a'),
        ),
        body: Stack(
          children: <Widget>[
            modelPreviewController == null
                ? Text("HI")
                : ModelPreview(
                    controller: modelPreviewController,
                  ),
            InkWell(
              onTap: (){
                //modelPreviewController.changeViewType(ModelViewType.Mesh);
                setData();
              },
              child: Container(
                height: 100,
                width: 100,
                color: Colors.blue,
              ),
            ),
          ],
        ),
        //child: Text('Running on: $_platformVersion\n'),     ),
      ),
    );
  }
}
