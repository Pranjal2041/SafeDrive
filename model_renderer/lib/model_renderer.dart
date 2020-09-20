import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:model_renderer/MRendererMethodChannel.dart';

import 'ModelRenderingController.dart';
import 'data/Constants.dart';

class ModelRenderer {
  static final MethodChannel _channel = MRendererMethodChannel.channel;

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}

class ModelPreview extends StatefulWidget {
  const ModelPreview({
    Key key,
    this.controller,
  }) : super(key: key);

  final ModelRenderingController controller;

  @override
  _ModelPreviewState createState() => _ModelPreviewState();
}

class _ModelPreviewState extends State<ModelPreview> {
  @override
  Widget build(BuildContext context) {
    return AndroidView(
      viewType: Constants.previewViewType,
      onPlatformViewCreated: _onPlatformViewCreated,
    );
  }

  void _onPlatformViewCreated(int id) {
    if (widget.controller == null) {
      return;
    }
    widget.controller.initialize();
  }
}

