package com.pranjal.model_renderer;

import androidx.annotation.NonNull;

import com.pranjal.model_renderer.data.Constants;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;


/** ModelRendererPlugin */
public class ModelRendererPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;
  FlutterPluginBinding flutterPluginBinding;
  ActivityPluginBinding activityPluginBinding;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
//    channel = new MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "model_renderer");
//    channel.setMethodCallHandler(this);
    channel = new MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), Constants.channel_id);
    channel.setMethodCallHandler(this);
    this.flutterPluginBinding = flutterPluginBinding;
    flutterPluginBinding.getPlatformViewRegistry().registerViewFactory(Constants.previewViewType,new ModelRenderingFactory(flutterPluginBinding.getBinaryMessenger(),flutterPluginBinding,this));

  }


  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "model_renderer");
    channel.setMethodCallHandler(new ModelRendererPlugin());
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    } else {
      result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }

  @Override
  public void onAttachedToActivity(ActivityPluginBinding binding) {
    this.activityPluginBinding = binding;
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {

  }

  @Override
  public void onReattachedToActivityForConfigChanges(ActivityPluginBinding binding) {

  }

  @Override
  public void onDetachedFromActivity() {

  }
}
