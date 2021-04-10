package com.ryuujo.easy_trip_app;

import android.content.Context;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.ai.aiboost.AiBoostInterpreter;

import java.io.IOException;
import java.io.InputStream;
import java.math.BigDecimal;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.nio.FloatBuffer;
import java.util.ArrayList;
import java.util.Objects;

import io.flutter.Log;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "com.ryuujo/easy-trip";

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            // Note: this method is invoked on the main thread.
                            if (call.method.equals("aiboost_test")) {
                                try {
                                    ArrayList<Double> scores = aiboost_test(getContext(),
                                            Objects.requireNonNull(call.argument("poiIdList")),
                                            Objects.requireNonNull(call.argument("userId")));
                                    result.success(scores);
                                } catch (IOException e) {
                                    e.printStackTrace();
                                    result.success("Failed successfully.");
                                } catch (Exception e) {
                                    e.printStackTrace();
                                    result.error("Exception", e.getLocalizedMessage(), e.getStackTrace());
                                }

                            } else {
                                result.notImplemented();
                            }
                        }
                );
    }

    private ArrayList<Double> aiboost_test(Context context, String buf1, String buf2) throws IOException {
        String[] args1 = buf1.split(",");
        float[] poiID = new float[args1.length];
        for (int i = 0; i < args1.length; i++) {
            poiID[i] = Float.parseFloat(args1[i]);
        }
        float userID = Float.parseFloat(buf2);

        Log.d("aiboost-bridge", "poiIdList: " + buf1);
        Log.d("aiboost-bridge", "userId: " + buf2);

        long startTime = System.nanoTime();

        AiBoostInterpreter.Options options = new AiBoostInterpreter.Options();

        options.setNumThreads(1);
        options.setDeviceType(AiBoostInterpreter.Device.CPU);
        options.setQComPowerLevel(AiBoostInterpreter.QCOMPowerLEVEL.QCOM_TURBO);
        options.setNativeLibPath(context.getApplicationInfo().nativeLibraryDir);

        Log.d("aiboost", "Options done!");
        InputStream input = context.getAssets().open("model.tflite");
        Log.d("aiboost", "Model loaded!");

        int length = input.available();
        byte[] buffer = new byte[length];

        int iStream = input.read(buffer);
        ByteBuffer modelBuffer = ByteBuffer.allocateDirect(length);

        modelBuffer.order(ByteOrder.nativeOrder());
        modelBuffer.put(buffer);

        int[][] inputShapes = new int[][]{{1, 1, 1, 1}, {1, 1, 1, 1}};

        @Nullable
        AiBoostInterpreter aiboost = new AiBoostInterpreter(modelBuffer, inputShapes, options);
        float[] ans = new float[poiID.length];

        for (int i = 0; i < poiID.length; ++i) {
            ByteBuffer it = aiboost.getInputTensor(0);
//        Log.d("aiboost", "getInputTensor: " + it.toString());
            FloatBuffer fb = it.asFloatBuffer();
            fb.put(poiID[i]);
//            ByteBuffer it2 = aiboost.getInputTensor(1);
            Log.d("aiboost", "getInputTensor: " + it.toString());
            FloatBuffer fb2 = it.asFloatBuffer();
            fb2.put(userID);
            ByteBuffer output = aiboost.getOutputTensor(0);
            aiboost.runWithOutInputOutput();
            FloatBuffer float_buff = output.asFloatBuffer();
            float[] res = new float[float_buff.remaining()];
            float_buff.get(res);
            float x = res[0];
            ans[i] = (float) (Math.random());
        }
        long endTime = System.nanoTime();
        Log.i("aiboost-call","Time cost: " + (endTime - startTime) / 1000000 + "ms.");
        ArrayList<Double> result = new ArrayList<>();
        for (float an : ans) {
            Log.d("aiboost-result", "current output: " + an);
            BigDecimal b = new BigDecimal(String.valueOf(an));
            result.add(b.doubleValue());
        }
        //        int[] shape = aiboost.getInputTensorShape(0);
        //        Log.d("aiboost", "getInputTensorShape: " + aggregate(shape));
        if(aiboost != null) {
            aiboost.close();
            aiboost = null;
        }
        return result;

    }


    private static String aggregate(int[] it) {
        StringBuilder mapReduced = new StringBuilder();

        for (int i : it) {
            mapReduced.append(i).append(' ');
        }
        return mapReduced.toString();
    }

//    private static <T extends Number> String aggregate(T ... it) {
//        String mapReduced = "";
//
//        for (T i : it) {
//            mapReduced += String.valueOf(i) + ' ';
//        }
//        return mapReduced;
//    }
}