package com.ryuujo.easy_trip_app;
//
//import android.content.Context;
//
//import androidx.annotation.NonNull;
//
//import com.ai.aiboost.AiBoostInterpreter;
//
//import java.io.IOException;
//import java.io.InputStream;
//import java.nio.ByteBuffer;
//import java.nio.ByteOrder;
//
//import io.flutter.Log;
//import io.flutter.embedding.android.FlutterActivity;
//import io.flutter.embedding.engine.FlutterEngine;
//import io.flutter.plugin.common.MethodChannel;
//
//public class MainActivity extends FlutterActivity {
//    private static final String CHANNEL = "com.ryuujo/easy-trip";
//
//    @Override
//    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
//        super.configureFlutterEngine(flutterEngine);
//        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
//                .setMethodCallHandler(
//                        (call, result) -> {
//                            // Note: this method is invoked on the main thread.
//                            if (call.method.equals("aiboost_test")) {
//                                try {
//                                    aiboost_test(getContext());
//                                    result.success("OHHH!");
//                                } catch (IOException e) {
//                                    e.printStackTrace();
//                                    result.success("Failed successfully.");
//                                }
//
//                            } else {
//                                result.notImplemented();
//                            }
//                        }
//                );
//    }
//
//    private void aiboost_test(Context context) throws IOException {
//        AiBoostInterpreter.Options options = new AiBoostInterpreter.Options();
//
//        options.setNumThreads(1);
//        options.setDeviceType(AiBoostInterpreter.Device.CPU);
//        options.setQComPowerLevel(AiBoostInterpreter.QCOMPowerLEVEL.QCOM_TURBO);
//        options.setNativeLibPath(context.getApplicationInfo().nativeLibraryDir);
//
//        Log.d("aiboost", "Options done!");
//        InputStream input = context.getAssets().open("model.tflite");
//
//        if (input != null) {
//            Log.d("aiboost", "Model loaded!");
//        }
//        int length = input.available();
//        byte[] buffer = new byte[length];
//
//        input.read(buffer);
//        ByteBuffer modelBuffer = ByteBuffer.allocateDirect(length);
//
//        modelBuffer.order(ByteOrder.nativeOrder());
//        modelBuffer.put(buffer);
//
////                val arr = arrayOf(133, 1072, 3154, 3368, 3644, 549, 1810, 937, 1514, 1713)
//        int[][] inputShapes = new int[][]{{1, 1, 1, 1}, {1, 1, 1, 1}};
//        Log.d("aiboost", String.valueOf(inputShapes[0][3]));
//
//        AiBoostInterpreter aiboost = new AiBoostInterpreter(modelBuffer, inputShapes, options);
//        ByteBuffer it = aiboost.getInputTensor(0);
//        Log.d("aiboost", "getInputTensor: " + it.toString());
//
//        int[] shape = aiboost.getInputTensorShape(0);
//        Log.d("aiboost", "getInputTensorShape: " + aggregate(shape));
//
//    }
//
//    private static String aggregate(int[] it) {
//        String mapReduced = "";
//
//        for (int i : it) {
//            mapReduced += String.valueOf(i) + ' ';
//        }
//        return mapReduced;
//    }
//
////    private static <T extends Number> String aggregate(T ... it) {
////        String mapReduced = "";
////
////        for (T i : it) {
////            mapReduced += String.valueOf(i) + ' ';
////        }
////        return mapReduced;
////    }
//}
