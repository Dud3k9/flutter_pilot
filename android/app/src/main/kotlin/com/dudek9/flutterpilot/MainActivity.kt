package com.dudek9.flutterpilot

import android.util.Log
import androidx.annotation.NonNull
import com.google.firebase.FirebaseApp
import com.google.firebase.ktx.Firebase
import com.google.firebase.ktx.app
import com.google.firebase.storage.ktx.storage
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant


class MainActivity : FlutterActivity() {

    private val CHANNEL = "flutter.native/helper";
    val storage = Firebase.storage(Firebase.app,"gs://monitoring-6b337.appspot.com/")

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getFiles") {
                var folder:String= call.argument<String>("folder").toString();
                val greetings: List<String> = getFiles(folder)
                result.success(greetings)
            }
        }

    }

    fun getFiles(folder:String): List<String> {

        var list = storage.reference.child("/"+folder).listAll()
        while (!list.isSuccessful){}
        var files=ArrayList<String>()

        list.result!!.items.forEach({files.add(it.name)})
        println(files.size)
        return files.toList()
    }
}
