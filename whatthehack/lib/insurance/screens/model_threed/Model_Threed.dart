import 'package:flutter/material.dart';
import 'package:model_renderer/ModelRenderingController.dart';
import 'package:model_renderer/data/CarParts.dart';
import 'package:model_renderer/model_renderer.dart';
import 'package:whatthehack/insurance/data/network.dart';

class ModelThreed extends StatefulWidget {
  @override
  _ModelThreedState createState() => _ModelThreedState();
}

class _ModelThreedState extends State<ModelThreed> {
  ModelRenderingController _controller;

  @override
  void initState() {
    _controller = ModelRenderingController();
    // _controller.changeViewType(ModelViewType.Mesh);
    Future.delayed(const Duration(milliseconds: 1500), () {
    setData();
    });
    super.initState();
  }

  setData() async{
    var temp = await fetchDamages();
    print(temp);
    _controller.setColorData({CarParts.Right_View_Mirror:(temp.right_hit*100).round(),CarParts.Left_View_Mirror:(temp.left_hit*100).round(),
      CarParts.Front:(temp.front_hit*100).round(),CarParts.Back:(temp.rear_hit*100).round()});
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Expanded(
        child: Stack(
          children: [
            ModelPreview(
              controller: _controller,
            ),
            // InkWell(
            //   onTap: (){
            //     //_controller.changeViewType(ModelViewType.Mesh);
            //     setData();
            //   },
            //   child: Container(
            //     height: 100,
            //     width: 100,
            //     color: Colors.blue,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
