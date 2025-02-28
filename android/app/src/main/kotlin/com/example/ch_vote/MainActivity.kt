package com.example.ch_vote

import android.content.Context
import android.os.Handler
import android.os.Looper
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.lang.Exception

// Updated import paths based on JAR analysis
import com.mx.finger.api.herofun.HeroFunApiFactory
import com.mx.finger.api.herofun.HeroFunApi
import com.mx.finger.common.MxImage
import com.mx.finger.common.Result

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.ch_vote/fingerprint"
    private lateinit var heroFunApi: HeroFunApi
    private val mainHandler = Handler(Looper.getMainLooper())
    
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "initFingerprintSensor" -> initFingerprintSensor(result)
                "openDevice" -> openDevice(result)
                "closeDevice" -> closeDevice(result)
                "isDeviceOpened" -> isDeviceOpened(result)
                "getImage" -> {
                    val acceptScore = call.argument<Int>("acceptScore") ?: 0
                    val timeout = call.argument<Long>("timeout") ?: 0L
                    getImage(acceptScore, timeout, result)
                }
                else -> result.notImplemented()
            }
        }
    }
    
    private fun initFingerprintSensor(result: MethodChannel.Result) {
        try {
            heroFunApi = HeroFunApiFactory.get(applicationContext, HeroFunApiFactory.MODE_USB_360)
            result.success(true)
        } catch (e: Exception) {
            Log.e("FingerprintChannel", "Error initializing sensor", e)
            result.error("INIT_ERROR", "Failed to initialize fingerprint sensor: ${e.message}", null)
        }
    }
    
    private fun openDevice(result: MethodChannel.Result) {
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
                
                // Log available methods in Result class
                Log.d("Debug", "Available methods: " + imageResult::class.java.methods.joinToString { it.name })
                
                // Try alternative method names
                val mxImage = imageResult.javaClass.getMethod("x03").invoke(imageResult) as? MxImage
                val errorCode = imageResult.javaClass.getMethod("x14").invoke(imageResult) as? Int
                
                mainHandler.post {
                    if (mxImage != null) {
                        val rawImageData = mxImage.javaClass.getMethod("getRawData").invoke(mxImage) as? ByteArray
                        result.success(rawImageData)
                    } else {
                        result.error("IMAGE_ERROR", "Failed to get image. Error code: $errorCode", null)
                    }
                }
            } catch (e: Exception) {
                mainHandler.post {
                    result.error("IMAGE_ERROR", "Exception when getting image: ${e.message}", null)
                }
            }
        }.start()
    }
}
