import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:model_renderer/data/Constants.dart';

@protected
class MRendererMethodChannel {
  static final MethodChannel channel = const MethodChannel(Constants.channel_id);
}
