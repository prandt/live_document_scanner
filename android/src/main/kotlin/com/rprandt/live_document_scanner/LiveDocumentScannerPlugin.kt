package com.rprandt.live_document_scanner

import android.app.Activity
import android.content.Intent
import android.content.IntentSender
import androidx.activity.result.IntentSenderRequest
import androidx.core.app.ActivityCompat.startIntentSenderForResult
import com.google.android.gms.tasks.Task
import com.google.mlkit.vision.documentscanner.GmsDocumentScannerOptions
import com.google.mlkit.vision.documentscanner.GmsDocumentScanning
import com.google.mlkit.vision.documentscanner.GmsDocumentScanningResult
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry

/** LiveDocumentScannerPlugin */
class LiveDocumentScannerPlugin: FlutterPlugin, MethodCallHandler,
  PluginRegistry.ActivityResultListener, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private lateinit var properties: LiveDocumentScannerProperties
  private lateinit var result: Result
  private var activity: Activity? = null
  private var binding: ActivityPluginBinding? = null

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "live_document_scanner")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(call: MethodCall, result: Result) = when (call.method) {
    "scanDocument" -> {
      properties = LiveDocumentScannerProperties.fromMap(call.arguments)
      this.result = result
      startDocumentScanner()
    }
    else -> result.notImplemented()
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  private fun startDocumentScanner() {
    val options = getOptions()
    val scanner = GmsDocumentScanning.getClient(options)
    val task: Task<IntentSender>? = activity?.let { scanner.getStartScanIntent(it) }
    task?.addOnSuccessListener { intentSender ->
      val intent = IntentSenderRequest.Builder(intentSender).build().intentSender
      try {
        startIntentSenderForResult(
          activity!!,
          intent,
          START_SCAN_CODE,
          null,
          0,
          0,
          0,
          null
        )
      } catch (e: Exception) {
        e.printStackTrace()
      }
    }?.addOnFailureListener { e ->
      // Handle the exception
    }
  }

  private fun getOptions() = GmsDocumentScannerOptions
    .Builder()
    .setGalleryImportAllowed(properties.galleryImportAllowed)
    .setPageLimit(properties.pageLimit)
    .setResultFormats(if (properties.type == LiveDocumentScannerType.PDF) GmsDocumentScannerOptions.RESULT_FORMAT_PDF else GmsDocumentScannerOptions.RESULT_FORMAT_JPEG)
    .setScannerMode(GmsDocumentScannerOptions.SCANNER_MODE_FULL)
    .build()

  override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
    if (resultCode != Activity.RESULT_OK || requestCode != START_SCAN_CODE) {
      result.error("SCAN_FAILED", "Failed to start scanning", null)
      return false
    }

    val resultScan = GmsDocumentScanningResult.fromActivityResultIntent(data)

    if (resultScan == null) {
      result.error("SCAN_FAILED", "No results", null)
      return false
    }

    when (properties.type) {
      LiveDocumentScannerType.PDF -> {
        result.success(
          mapOf(
            "pdf" to resultScan.pdf?.uri?.path,
            "pageCount" to resultScan.pdf?.pageCount,
            "type" to "pdf"
          )
        )
        return true
      }
      LiveDocumentScannerType.IMAGES -> {
        result.success(
          mapOf(
            "images" to resultScan.pages?.map { it.imageUri.path },
            "pageCount" to resultScan.pages?.size,
            "type" to "images"
          )
        )
        return true
      }
    }
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    this.binding = binding
    binding.addActivityResultListener(this)
    activity = binding.activity
  }

  override fun onDetachedFromActivityForConfigChanges() {
    binding?.removeActivityResultListener(this)
    binding = null
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    this.binding = binding
    binding.addActivityResultListener(this)
  }

  override fun onDetachedFromActivity() {
    binding?.removeActivityResultListener(this)
    binding = null
  }

  companion object {
    private const val START_SCAN_CODE = 100
  }
}
