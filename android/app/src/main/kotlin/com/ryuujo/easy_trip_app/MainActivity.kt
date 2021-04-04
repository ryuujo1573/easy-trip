package com.ryuujo.easy_trip_app
//
//import android.content.Context
//import androidx.annotation.NonNull
//import com.ai.aiboost.AiBoostInterpreter
//import io.flutter.embedding.android.FlutterActivity
//import io.flutter.Log
//import io.flutter.embedding.engine.FlutterEngine
//import io.flutter.plugin.common.MethodCall
//import io.flutter.plugin.common.MethodChannel
//import io.flutter.plugins.GeneratedPluginRegistrant
//import java.nio.ByteBuffer
//import java.nio.ByteOrder
//import java.sql.Wrapper
//
//class MainActivity : FlutterActivity() {
//    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
//        GeneratedPluginRegistrant.registerWith(flutterEngine)
//        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "com.ryuujo/easy-trip").setMethodCallHandler { call, result ->
//            run {
//                if (call.method.contentEquals("android_test")) {
//
//                    result.success("1014469764!")
//                    Log.i("test", "ms")
//                } else if (call.method.contentEquals("aiboost_test")) {
////                    try {
//                    Wrapper.aiBoostTest(context).let {
//                        result.success(it)
//                    }
////                    } catch (e: Exception) {
////                        Log.e("aiBoostTest", e.message ?: e.localizedMessage ?: "Unknown Error")
////                    }
//                } else {
//                    result.notImplemented()
//                }
//            }
//        }
//
//    }
//
//    class Wrapper {
//        companion object {
//            fun aiBoostTest(context: Context): String {
//                var options = AiBoostInterpreter.Options()
//
//                options.setNumThreads(1)
//                options.setDeviceType(AiBoostInterpreter.Device.CPU)
//                options.setQComPowerLevel(AiBoostInterpreter.QCOMPowerLEVEL.QCOM_TURBO)
//                options.setNativeLibPath(context.applicationInfo.nativeLibraryDir)
//
//                Log.d("aiboost", "Options done!")
//                var input = context.assets.open("model.tflite")
//
//                input?.let { Log.d("aiboost", "Model loaded!") }
//                var length = input.available()
//                var buffer = ByteArray(length)
//
//                input.read(buffer)
//                var modelBuffer = ByteBuffer.allocateDirect(length)
//
//                modelBuffer.order(ByteOrder.nativeOrder())
//                modelBuffer.put(buffer)
//
////                val arr = arrayOf(133, 1072, 3154, 3368, 3644, 549, 1810, 937, 1514, 1713)
//                var inputShapes = arrayOf(arrayOf(1, 1, 1, 1), arrayOf(1, 1, 1, 1))
//
//                var aiboost = AiBoostInterpreter(modelBuffer, inputShapes, options)
//                aiboost.getInputTensor(0).let {
//                    Log.d("aiboost", "getInputTensor: " + it.toString())
//                }
//                aiboost.getInputTensorShape(0).let {
//                    return it.map { i -> i.toString() }.reduce { acc, i -> "$acc $i "}
//                }
//
//            }
//        }
//    }
//}
