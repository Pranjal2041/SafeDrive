import 'package:flutter/services.dart';
import 'package:model_renderer/data/CarParts.dart';
import 'package:model_renderer/data/Constants.dart';
import 'package:model_renderer/data/ModelViewType.dart';

class ModelRenderingController {

  ModelRenderingController() {
    this._channel = MethodChannel('${Constants.channel_id}_0');
  }

  MethodChannel _channel;


  Future<void> initialize() async {
    print("Initializing renderer here");
    _channel.invokeMethod("initializeModel", {
      "showModel": true
    });
  }
  
  changeViewType(ModelViewType viewType) async{
    _channel.invokeMethod("toggleView",{
      "viewType": ModelViewTypeClass.getStringFromViewType(viewType)
    });
  }

  setColorData(Map data){

    _channel.invokeMethod("updateData",{
      "data": CarPartsClass.convertPartsMapToStringMap(data)
    });
  }

}
