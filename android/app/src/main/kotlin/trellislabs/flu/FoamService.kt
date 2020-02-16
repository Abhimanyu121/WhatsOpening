package trellislabs.flu


import android.annotation.TargetApi
import android.app.IntentService
import android.app.Notification
import android.app.PendingIntent
import android.content.Intent
import android.location.Location
import android.util.Log
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import androidx.core.app.TaskStackBuilder
import com.android.volley.Request
import com.android.volley.Response
import com.android.volley.toolbox.JsonArrayRequest
import com.android.volley.toolbox.Volley
import com.google.android.gms.location.FusedLocationProviderClient
import com.google.android.gms.location.LocationServices
import org.json.JSONObject

class FoamService : IntentService("WithdrawSerivice"){
    @TargetApi(26)
    override fun onCreate(){
        super.onCreate()
        val pendingIntent: PendingIntent =
                Intent(this, FoamService::class.java).let { notificationIntent ->
                    PendingIntent.getActivity(this, 0, notificationIntent, 0)
                }

        val notification: Notification = Notification.Builder(this, "FOAM")
                .setContentTitle("FOAM Location Services")
                .setContentText("Location services active ")
                .setSmallIcon(R.drawable.ic_near_me_black_24dp)
                .setContentIntent(pendingIntent)
                .setTicker("FOAM")
                .build()

        startForeground(6969, notification)
    }
    override fun onHandleIntent(intent: Intent?) {
        var latitude:Double? = null
        var longitude:Double? = null
        var nelong:Double? = null
        var nelat:Double? = null
        var swlong:Double? = null
        var swlat:Double? = null
        var id =0
        val queue = Volley.newRequestQueue(this)
        val hashMap:HashMap<String ,Boolean> = HashMap<String ,Boolean>()
        try {
            val resultIntent = Intent(this, MainActivity::class.java)
            val resultPendingIntent: PendingIntent? = TaskStackBuilder.create(this).run {
                // Add the intent, which inflates the back stack
                addNextIntentWithParentStack(resultIntent)
                // Get the PendingIntent containing the entire back stack
                getPendingIntent(0, PendingIntent.FLAG_UPDATE_CURRENT)
            }

           while(true){
               val fusedLocationClient: FusedLocationProviderClient = LocationServices.getFusedLocationProviderClient(this)
               fusedLocationClient.lastLocation
                       .addOnSuccessListener { location : Location? ->
                           val _longitude:Double =location!!.longitude
                           val _latitude:Double = location.latitude
                           if(latitude ==null && longitude == null){
                               latitude = _latitude
                               longitude = _longitude
                               nelong = longitude!!+1
                               nelat =latitude!!+1
                               swlong  = longitude!!-1
                               swlat = latitude!!-1
                               val  url = "https://rink-cd-api.foam.space/poi/map?swLng="+swlong.toString()+"&swLat="+swlat.toString()+"&neLng="+nelong.toString()+"&neLat="+nelat.toString();
                               val jsonArray = JsonArrayRequest(Request.Method.GET, url, null,
                                       Response.Listener { response ->
                                           var i = 0
                                           while(i<response.length()){
                                               hashMap[response.getJSONObject(i)["geohash"].toString()] = true
                                                i++
                                           }
                                           Log.e("POI response", response.toString())
                                           if(response.length()>1){

                                               val builder = NotificationCompat.Builder(this, "FOAM")
                                                       .setSmallIcon(R.drawable.ic_near_me_black_24dp)
                                                       .setContentTitle("POI Nearby")
                                                       .setContentText("There are ${response.length()} places near you")
                                                       .setPriority(NotificationCompat.PRIORITY_DEFAULT)
                                                       .setContentIntent(resultPendingIntent)
                                               with(NotificationManagerCompat.from(this)) {
                                                   // notificationId is a unique int for each notification that you must define
                                                   notify(id, builder.build())
                                                   id++
                                               }
                                                Log.e("up2", response.toString())
                                           }
                                           else if(response.length() ==1){
                                               var builder = NotificationCompat.Builder(this, "FOAM")
                                                       .setSmallIcon(R.drawable.ic_near_me_black_24dp)
                                                       .setContentTitle("POI Nearby")
                                                       .setContentText("You are near ${response.getJSONObject(0)["name"]}")
                                                       .setPriority(NotificationCompat.PRIORITY_DEFAULT)
                                                       .setContentIntent(resultPendingIntent)
                                               with(NotificationManagerCompat.from(this)) {
                                                   // notificationId is a unique int for each notification that you must define
                                                   notify(id, builder.build())
                                                   id++
                                               }
                                               Log.e("up1", response.toString())
                                           }


                                       },
                                       Response.ErrorListener { error ->
                                           // TODO: Handle error
                                       })
                               queue.add(jsonArray)

                           }
                           else{
                               latitude = _latitude
                               longitude = _longitude
                               nelong = longitude!!+1
                               nelat =latitude!!+1
                               swlong  = longitude!!-1
                               swlat = latitude!!-1
                               var  url = "https://rink-cd-api.foam.space/poi/map?swLng="+swlong.toString()+"&swLat="+swlat.toString()+"&neLng="+nelong.toString()+"&neLat="+nelat.toString();
                               val jsonArray = JsonArrayRequest(Request.Method.GET, url, null,
                                       Response.Listener { response ->
                                           if(response.length()==1){
                                               if(hashMap[response.getJSONObject(0)["geohash"]]!=true||hashMap[response.getJSONObject(0)["geohash"]]==null){
                                                   val builder = NotificationCompat.Builder(this, "FOAM")
                                                           .setSmallIcon(R.drawable.ic_near_me_black_24dp)
                                                           .setContentTitle("POI Nearby")
                                                           .setContentText("There are ${response.length()} places near you")
                                                           .setPriority(NotificationCompat.PRIORITY_DEFAULT)

                                                   with(NotificationManagerCompat.from(this)) {
                                                       // notificationId is a unique int for each notification that you must define
                                                       notify(id, builder.build())
                                                       id++
                                                   }
                                               }

                                                Log.e("down1", response.toString())
                                           }
                                           else if(response.length()>1){
                                               var count = 0
                                               var i = 0
                                               while(i<response.length()){
                                                   Log.e("resp length", response.length().toString())
                                                   Log.e("state",hashMap[response.getJSONObject(i)["geohash"]].toString() )
                                                    if(hashMap[response.getJSONObject(i)["geohash"]]!=true||hashMap[response.getJSONObject(i)["geohash"]]==null){
                                                        count++
                                                        hashMap[response.getJSONObject(i)["geohash"].toString()]= true
                                                    }
                                                   i++
                                               }
                                               if (count>0){
                                                   Log.e("inside count",count.toString())
                                                   val builder = NotificationCompat.Builder(this, "FOAM")
                                                           .setSmallIcon(R.drawable.ic_near_me_black_24dp)
                                                           .setContentTitle("POI Nearby")
                                                           .setContentText("You are near $count new POI")
                                                           .setPriority(NotificationCompat.PRIORITY_DEFAULT)
                                                   with(NotificationManagerCompat.from(this)) {
                                                       // notificationId is a unique int for each notification that you must define
                                                       notify(id, builder.build())
                                                       id ++
                                                   }
                                               }

                                           }
                                            Log.e("down2", response.toString())

                                       },
                                       Response.ErrorListener { error ->
                                           Log.e("error", error.message)

                                       })
                               queue.add(jsonArray)

                           }

                       }
               Thread.sleep(60000)
           }

        } catch (e: InterruptedException) {
            Log.e("intr error", e.message)
            Thread.currentThread().interrupt()
        }

    }



}