package com.example.matchmaker_db

import android.content.ClipboardManager
import android.content.Context
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.matchmaker.clipboard"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getSanitizedClipboard") {
                val clipboardText = getSanitizedClipboardText()
                result.success(clipboardText)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun getSanitizedClipboardText(): String? {
        return try {
            val clipboard = getSystemService(Context.CLIPBOARD_SERVICE) as ClipboardManager

            if (!clipboard.hasPrimaryClip()) {
                return null
            }

            val clipData = clipboard.primaryClip
            if (clipData == null || clipData.itemCount == 0) {
                return null
            }

            // 获取纯文本内容
            val item = clipData.getItemAt(0)
            val text = item.text?.toString()

            // 清理和标准化文本
            text?.trim()?.takeIf { it.isNotEmpty() }
        } catch (e: Exception) {
            e.printStackTrace()
            null
        }
    }
}
