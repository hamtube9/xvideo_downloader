package ngaoschos.videodownloader

import android.content.ActivityNotFoundException
import android.content.Context
import android.content.Intent
import android.content.pm.PackageInfo
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Bundle
import android.util.Base64
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugins.GeneratedPluginRegistrant
import java.security.MessageDigest
import java.security.NoSuchAlgorithmException

class MainActivity: FlutterActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        GeneratedPluginRegistrant.registerWith(this.flutterEngine!!)
        printHashKey(this)
        methodInstagram()

    }

    fun methodInstagram() {
        MethodChannel(this.flutterEngine!!.dartExecutor, "ngaoschos.videodownloader/insta").setMethodCallHandler { call, result ->
            if (call.method == "launchInstagram") {
                launchInsta()
            }
            result.notImplemented()
        }
    }

   fun launchInsta(){
        val uri: Uri = Uri.parse("http://instagram.com/")
        val i = Intent(Intent.ACTION_VIEW, uri)
        i.setPackage("com.instagram.android")
        try {
            startActivity(i)
        } catch (e: ActivityNotFoundException) {
            startActivity(Intent(Intent.ACTION_VIEW,
                    Uri.parse("http://instagram.com/xxx")))
        }
    }

    fun printHashKey(pContext: Context) {
        try {
            val info: PackageInfo = pContext.getPackageManager().getPackageInfo(pContext.getPackageName(), PackageManager.GET_SIGNATURES)
            for (signature in info.signatures) {
                val md: MessageDigest = MessageDigest.getInstance("SHA")
                md.update(signature.toByteArray())
                val hashKey: String = String(Base64.encode(md.digest(), 0))
                Log.i("HASH_KEY_NGAOSCHOS", "printHashKey() Hash Key: $hashKey")
            }
        } catch (e: NoSuchAlgorithmException) {
            Log.e("HASH_KEY_NGAOSCHOS", "printHashKey()", e)
        } catch (e: Exception) {
            Log.e("HASH_KEY_NGAOSCHOS", "printHashKey()", e)
        }
    }
}
