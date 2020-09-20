package com.pranjal.model_renderer;

import android.content.Context;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

public class ModelRenderingFactory extends PlatformViewFactory {

    private final BinaryMessenger messenger;
    FlutterPlugin.FlutterPluginBinding flutterPluginBinding;
    ModelRendererPlugin plugin;

    public ModelRenderingFactory(BinaryMessenger messenger, FlutterPlugin.FlutterPluginBinding flutterPluginBinding,ModelRendererPlugin plugin) {
        super(StandardMessageCodec.INSTANCE);
        this.plugin = plugin;
        this.flutterPluginBinding = flutterPluginBinding;
        this.messenger = messenger;
    }

    @Override
    public PlatformView create(Context context, int id, Object o) {
        return new ModelRenderingView(context,messenger, id,flutterPluginBinding,plugin);
    }

}
