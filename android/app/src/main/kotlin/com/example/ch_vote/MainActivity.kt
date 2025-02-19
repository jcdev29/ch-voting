package com.example.ch_vote  

import android.content.Context
import android.os.Handler
import android.os.Looper
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodCall
import java.lang.Exception

// Import the HeroFun API classes 
import com.mx.finger.HeroFunApiFactory
import com.mx.finger.HeroFunApi

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.ch_vote/fingerprint"
    private lateinit var heroFunApi: HeroFunApi
    private val mainHandler = Handler(Looper.getMainLooper())
    
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "initFingerprintSensor" -> {
                    initFingerprintSensor(result)
                }
                "openDevice" -> {
                    openDevice(result)
                }
                "closeDevice" -> {
                    closeDevice(result)
                }
                "isDeviceOpened" -> {
                    isDeviceOpened(result)
                }
                "getImage" -> {
                    val acceptScore = call.argument<Int>("acceptScore") ?: 0
                    val timeout = call.argument<Long>("timeout") ?: 0L
                    getImage(acceptScore, timeout, result)
                }
                // Add more methods for different fingerprint operations
                else -> {
                    result.notImplemented()
                }
            }
        }
    }
    
    private fun initFingerprintSensor(result: MethodChannel.Result) {
        try {
            // Initialize the API with USB mode for FCM360
            heroFunApi = HeroFunApiFactory.get(context, HeroFunApiFactory.MODE_USB_360)
            result.success(true)
        } catch (e: Exception) {
            Log.e("FingerprintChannel", "Error initializing sensor", e)
            result.error("INIT_ERROR", "Failed to initialize fingerprint sensor: ${e.message}", null)
        }
    }
    
    private fun openDevice(result: MethodChannel.Result) {
        // Since openDevice() is a blocking operation, run it on a background thread
        Thread {
            try {
                val openResult = heroFunApi.openDevice()
                mainHandler.post {
                    if (openResult >= 0) {
                        result.success(openResult)
                    } else {
                        result.error("OPEN_ERROR", "Failed to open device. Error code: $openResult", null)
                    }
                }
            } catch (e: Exception) {
                mainHandler.post {
                    result.error("OPEN_ERROR", "Exception when opening device: ${e.message}", null)
                }
            }
        }.start()
    }
    
    private fun closeDevice(result: MethodChannel.Result) {
        Thread {
            try {
                val closeResult = heroFunApi.closeDevice()
                mainHandler.post {
                    if (closeResult == 0) {
                        result.success(true)
                    } else {
                        result.error("CLOSE_ERROR", "Failed to close device. Error code: $closeResult", null)
                    }
                }
            } catch (e: Exception) {
                mainHandler.post {
                    result.error("CLOSE_ERROR", "Exception when closing device: ${e.message}", null)
                }
            }
        }.start()
    }
    
    private fun isDeviceOpened(result: MethodChannel.Result) {
        try {
            val isOpened = heroFunApi.isDeviceOpened()
            result.success(isOpened)
        } catch (e: Exception) {
            result.error("CHECK_ERROR", "Failed to check device state: ${e.message}", null)
        }
    }
    
    private fun getImage(acceptScore: Int, timeout: Long, result: MethodChannel.Result) {
        Thread {
            try {
                val imageResult = heroFunApi.getImage(acceptScore, timeout)
                mainHandler.post {
                    if (imageResult.isSuccess()) {
                        val mxImage = imageResult.getData()
                        // Convert MxImage to format that can be sent to Flutter
                        // For example, convert raw byte array to base64 string
                        val rawImageData = mxImage.getRawData()
                        result.success(rawImageData)
                    } else {
                        result.error("IMAGE_ERROR", "Failed to get image. Error code: ${imageResult.getErrCode()}", null)
                    }
                }
            } catch (e: Exception) {
                mainHandler.post {
                    result.error("IMAGE_ERROR", "Exception when getting image: ${e.message}", null)
                }
            }
        }.start()
    }
    
    // Add more methods 
}