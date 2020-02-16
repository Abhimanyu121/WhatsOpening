package trellislabs.flu

import android.Manifest
import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import android.os.Bundle
import androidx.core.app.ActivityCompat
import io.flutter.app.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity() {
  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    GeneratedPluginRegistrant.registerWith(this)
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
      // Create the NotificationChannel
      val name = "Foam Maps"
      val descriptionText = "Foam Map Location active"
      val importance = NotificationManager.IMPORTANCE_DEFAULT
      val mChannel = NotificationChannel("FOAM", name, importance)
      mChannel.description = descriptionText
      val notificationManager = getSystemService(NOTIFICATION_SERVICE) as NotificationManager
      notificationManager.createNotificationChannel(mChannel)
    }
    val permissionAccessCoarseLocationApproved = ActivityCompat
            .checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION) ==
            PackageManager.PERMISSION_GRANTED
    if (permissionAccessCoarseLocationApproved) {
      startService()
    } else {
      // Make a request for foreground-only location access.
      ActivityCompat.requestPermissions(this,
              arrayOf(Manifest.permission.ACCESS_FINE_LOCATION),
              12
      )
      startService()
    }

  }
  private fun startService(){
    Intent(this, FoamService::class.java).also { intent ->
      startService(intent)
    }

  }
}
