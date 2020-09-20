package com.pranjal.model_renderer;

import android.content.Context;
import android.net.Uri;
import android.os.Handler;
import android.util.Log;
import android.view.View;
import android.widget.TextView;

import androidx.annotation.NonNull;

import com.pranjal.model_renderer.data.Constants;

import org.andresoviedo.android_3d_model_engine.camera.CameraController;
import org.andresoviedo.android_3d_model_engine.collision.CollisionController;
import org.andresoviedo.android_3d_model_engine.controller.TouchController;
import org.andresoviedo.android_3d_model_engine.services.SceneLoader;
import org.andresoviedo.android_3d_model_engine.view.ModelRenderer;
import org.andresoviedo.android_3d_model_engine.view.ModelSurfaceView;
import org.andresoviedo.util.android.ContentUtils;
import org.andresoviedo.util.event.EventListener;

import java.net.URI;
import java.util.EventObject;
import java.util.Map;
import java.util.Objects;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.platform.PlatformView;

public class ModelRenderingView implements PlatformView, MethodChannel.MethodCallHandler, EventListener {

    private final MethodChannel methodChannel;
    FlutterPlugin.FlutterPluginBinding flutterPluginBinding;
    ModelRendererPlugin plugin;
    Context context;


    ModelRenderingView(Context context, BinaryMessenger messenger, int id, FlutterPlugin.FlutterPluginBinding flutterPluginBinding, ModelRendererPlugin plugin) {

//        textView = new TextView(context);
        methodChannel = new MethodChannel(messenger, Constants.channel_id +"_"+0);
        this.context = context;
        this.plugin = plugin;
        this.flutterPluginBinding = flutterPluginBinding;
        methodChannel.setMethodCallHandler(this);

        Log.d(TAG, "ModelRenderingView: Ok so the problem lies heere");
    }


    void initializeModel(){
        onCreateFunction();
    }


    private static final int REQUEST_CODE_LOAD_TEXTURE = 1000;
    private static final int FULLSCREEN_DELAY = 10000;
    private int paramType;
    private URI paramUri;
    private boolean immersiveMode;
    private float[] backgroundColor = new float[]{1.0f, 0.0f, 0.0f, 1.0f};

    private ModelSurfaceView gLView;
    private TouchController touchController;
    private SceneLoader scene;
    private ModelViewerGUI gui;
    private CollisionController collisionController;
    private static final String TAG = "ModelRenderingView";


    private Handler handler;
    private CameraController cameraController;



    void onCreateFunction(){
        Log.i("ModelActivity", "Loading activity...");



        ContentUtils.provideAssets(plugin.activityPluginBinding.getActivity());
        this.paramUri = URI.create(Uri.parse("assets://" + plugin.activityPluginBinding.getActivity().getPackageName() + "/" + "3.obj").toString());
        Log.d(TAG,"param uri is: "+"assets://" + plugin.activityPluginBinding.getActivity().getPackageName() + "/" + "3.obj");
        this.immersiveMode = true;
        backgroundColor[0] = 0.49f;
        backgroundColor[1] = 0.48f;
        backgroundColor[2] = 0.50f;
        backgroundColor[3] = 1.0f;

        handler = new Handler(plugin.activityPluginBinding.getActivity().getMainLooper());

        // Create our 3D scenario
        Log.i("ModelActivity", "Loading Scene...");


        scene = new SceneLoader(plugin.activityPluginBinding.getActivity(), paramUri, -1, gLView,null);


        try {
            Log.i("ModelActivity", "Loading GLSurfaceView...");
            gLView = new ModelSurfaceView(plugin.activityPluginBinding.getActivity(), backgroundColor, this.scene);
            gLView.addListener(this);
//            setContentView(gLView);
            scene.setView(gLView);
        } catch (Exception e) {
            Log.e("ModelActivity", e.getMessage(), e);
        }

        try {
            Log.i("ModelActivity", "Loading TouchController...");
            touchController = new TouchController(plugin.activityPluginBinding.getActivity());
            touchController.addListener(this);
        } catch (Exception e) {
            Log.e("ModelActivity", e.getMessage(), e);
        }

//        try {
//            Log.i("ModelActivity", "Loading CollisionController...");
//            collisionController = new CollisionController(gLView, scene);
//            collisionController.addListener(scene);
//            touchController.addListener(collisionController);
//            touchController.addListener(scene);
//        } catch (Exception e) {
//            Log.e("ModelActivity", e.getMessage(), e);
//        }

        try {
            Log.i("ModelActivity", "Loading CameraController...");
            cameraController = new CameraController(scene.getCamera());
            gLView.getModelRenderer().addListener(cameraController);
            touchController.addListener(cameraController);
        } catch (Exception e) {
            Log.e("ModelActivity", e.getMessage(), e);
        }

        try {
            // TODO: finish UI implementation
            Log.i("ModelActivity", "Loading GUI...");
            gui = new ModelViewerGUI(gLView, scene);
            touchController.addListener(gui);
            gLView.addListener(gui);
            scene.addGUIObject(gui);
        } catch (Exception e) {
            Log.e("ModelActivity", e.getMessage(), e);
        }

        // Show the Up button in the action bar.
        //setupActionBar();

        //setupOnSystemVisibilityChangeListener();

        // load model
        scene.init();

        Log.i("ModelActivity", "Finished loading");

    }


    void updateColorData(Map<String, Integer> map){
        scene.setColorMapping(ColorMapper.mapFromRawData(map));
    }

    void toggleView(ModelViewType type){
        switch (type){
            case Normal:
                scene.changeWireframe(0);
                break;
            case Points:
                scene.changeWireframe(2);
                break;
            case Mesh:
                scene.changeWireframe(1);
                break;
            case X_RAY:
                scene.toggleBlending();
                break;
        }
    }

    @Override
    public void onMethodCall(MethodCall call, @NonNull MethodChannel.Result result) {
        switch ((String)(call.method)) {
            case "initializeModel":
//                initializeModel();
                break;
            case "updateData":
                updateColorData(call.argument("data"));
                break;
            case "toggleView":
                toggleView(Objects.requireNonNull(ModelViewTypeClass.getViewTypeFromString( Objects.requireNonNull(call.argument("viewType")))));
            default:
                result.notImplemented();
        }
    }


    @Override
    public View getView() {
        TextView a = new TextView(context);
        a.setText("Hello From Android");
        if(gLView==null)
            initializeModel();
        return gLView==null?a:gLView;
    }

    @Override
    public void dispose() {
    }

    @Override
    public boolean onEvent(EventObject event) {
        if (event instanceof ModelRenderer.ViewEvent) {
            ModelRenderer.ViewEvent viewEvent = (ModelRenderer.ViewEvent) event;
            if (viewEvent.getCode() == ModelRenderer.ViewEvent.Code.SURFACE_CHANGED) {
                touchController.setSize(viewEvent.getWidth(), viewEvent.getHeight());
                gLView.setTouchController(touchController);

                // process event in GUI
                if (gui != null) {
                    gui.setSize(viewEvent.getWidth(), viewEvent.getHeight());
                    gui.setVisible(true);
                }
            }
        }
        return true;
    }


}
