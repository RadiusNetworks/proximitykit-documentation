# Getting started with Proximity Kit

This guide should get your app working with the Proximity Kit service.

## Download and Install

If you have not downloaded the Proximity Kit framework and added it to your
project you should [go do that first](/android-download).

**Note**: Users of the Proximity Kit client library agree to abide by the
license terms as specified for [iOS](../ios/license) and
[Android](license).

## Creating a Proximity Kit Manager

Proximity Kit provides a wrapper around the open source [Android Beacon
Library](https://github.com/AltBeacon/android-beacon-library).  This allows for
automatic registering of beacons, but should give your app all the power and
control it needs to use location data.

Currently the Proximity Kit for Android library manages a singleton instance of
a `ProximityKitManager` for you. However, this will not always be the case. We
_strongly_ suggest you spend the time to setup your own singleton instance now.
This will greatly help ease future upgrade. Note to get proper background and
on boot beacon detection the singleton reference must be stored in a manner
that keeps it around for the full application lifetime.

For simplicity in this guide, we will manage our singleton in a [custom `Application` subclass](https://github.com/RadiusNetworks/proximitykit-reference-android/blob/master/AndroidProximityKitReference/src/main/java/com/radiusnetworks/androidproximitykitreference/AndroidProximityKitReferenceApplication.java).
If your project does not already have one create a new class in your source
directory which `extends Application`.

**Note**: See the open source [Android Proximity Kit Reference
app](https://github.com/RadiusNetworks/proximitykit-reference-android) for a
full sample app.

In the editor of your choice, create a new class in your default package. For
this guide, our main application module will be called
`AndroidProximityKitReference`. So we'll name this new class:
`AndroidProximityKitReferenceApplication`. Be sure to set the parent class to
`Application`.

```java
public class AndroidProximityKitReferenceApplication extends Application {
}
```

To initialize the Proximity Kit manager you will need the configuration
settings for your kit. These can be downloaded from the Proximity Kit server as
a `.properties` file. These settings can be loaded directly from the file,
statically compiled into your source, or load via another mechanism of your
choice..

For newer Android applications, we suggest simply adding the file as an
_asset_ (e.g. placed in [`PROJECT_ROOT/app/src/assets`](https://github.com/RadiusNetworks/proximitykit-reference-android/tree/master/AndroidProximityKitReferenceApplication/src/main/assets)).
This is a standard Android location. It allows us to load the file by name with
minimal code. We'll put this in a helper place in our custom `Application`
class:

```java
private KitConfig loadConfig() {
    Properties properties = new Properties();
    try {
        properties.load(getAssets().open("ProximityKit.properties"));
    } catch (IOException e) {
        throw new IllegalStateException("Unable to load properties file!", e);
    }
    return new KitConfig(properties);
}
```

Older apps which upgrade are likely treating the `.properties` file as a
resource (e.g. `PROJECT_ROOT/app/src/resources`). If you do not wish to
migrate to `/assets` or simply prefer using Java resources, replace the above
method with the following:

```java
private KitConfig loadConfig() {
    Properties properties = new Properties();
    InputStream in = getClassLoader().getResourceAsStream("ProximityKit.properties");
    if (in == null) {
        throw new IllegalStateException("Unable to find ProximityKit.properties files");
    }
    try {
        properties.load(in);
    } catch (IOException e) {
        throw new IllegalStateException("Unable to load properties file!", e);
    }
    return new KitConfig(properties);
}
```

We want to ensure that we setup our Proximity Kit manager only after the
application is ready for us to work with. For this reason, we'll implement an
`onCreate` method instead of placing things in the constructor. Since
`Application` already implements `onCreate` we mark it with `@Override` and
call `super` to ensure the core functionality is preserved.

To ensure we have a singleton instance we'll use the standard single-lock
pattern. We are not using a double-lock pattern as we are not lazy loading the
instance so there is no need to try to avoid the synchronization penalty at
runtime. This means we create both a lock and the manager instance as
`private static` fields:

```java
public class AndroidProximityKitReferenceApplication extends Application {

    /**
     * Singleton storage for an instance of the manager
     */
    private static ProximityKitManager pkManager = null;

    /**
     * Object to use as a thread-safe lock
     */
    private static final Object pkManagerLock = new Object();

    @Override
    public void onCreate() {
        super.onCreate();

        synchronized (pkManagerLock) {
            if (pkManager == null) {
                pkManager = ProximityKitManager.getInstance(this, loadConfig());
            }
        }

        /*
         * Now that everything is configured start the Proximity Kit Manager.
         * This syncs with the Proximity Kit cloud servers and ensures necessary
         * adapters are initialized.
         */
        pkManager.start();
    }

    private KitConfig loadConfig() {
        Properties properties = new Properties();
        try {
            properties.load(getAssets().open("ProximityKit.properties"));
        } catch (IOException e) {
            throw new IllegalStateException("Unable to load properties file!", e);
        }
        return new KitConfig(properties);
    }

}
```

## Working with Beacons

If you compile and run your application at this point it should work. There
should be log messages about talking to the Proximity Kit cloud. As well as
registering any beacons you have configured. Let's add some functionality to
actually do something when we see those beacons.

We'll use our custom application instance as the notification target. We're
doing this to keep the example simple. Additionally, it ensures that we'll
continue to keep receiving notifications as long as the app is running.

One of the types of notifications we can receive is region enter and exit
events. We'll need to update our custom application class to implement the
`ProximityKitMonitorNotifier` interface to receive them:

```java
import com.radiusnetworks.proximity.ProximityKitBeaconRegion;
import com.radiusnetworks.proximity.ProximityKitMonitorNotifier;

public class AndroidProximityKitReferenceApplication
        extends     Application
        implements  ProximityKitMonitorNotifier {

    public static final String TAG = "AndroidProximityKitReferenceApplication";

    @Override
    /**
     * Called when at least one beacon in a
     * <code>ProximityKitBeaconRegion</code> is visible.
     *
     * @param region    an <code>ProximityKitBeaconRegion</code> which defines
     *                  the criteria of beacons being monitored
     */
    public void didEnterRegion(ProximityKitBeaconRegion region) {
        Log.d(TAG, "ENTER beacon region: " + region);
    }

    @Override
    /**
     * Called when no more beacons in a <code>ProximityKitBeaconRegion</code>
     *  are visible.
     *
     * @param region    an <code>ProximityKitBeaconRegion</code> that defines
     *                  the criteria of beacons being monitored
     */
    public void didExitRegion(ProximityKitBeaconRegion region) {
        Log.d(TAG, "EXIT beacon regoin: " + region);
    }

    @Override
    /**
     * Called when a the state of a <code>Region</code> changes.
     *
     * @param state     set to <code>ProximityKitMonitorNotifier.INSIDE</code>
     *                  when at least one beacon in a
     *                  <code>ProximityKitBeaconRegion</code> is now visible;
     *                  set to <code>ProximityKitMonitorNotifier.OUTSIDE</code>
     *                  when no more beacons in the
     *                  <code>ProximityKitBeaconRegion</code> are visible
     * @param region    an <code>ProximityKitBeaconRegion</code> that defines
     *                  the criteria of beacons being monitored
     */
    public void didDetermineStateForRegion(int state, ProximityKitBeaconRegion region) {
        Log.d(TAG, "didDeterineStateForRegion called with region: " + region);

        switch (state) {
            case ProximityKitMonitorNotifier.INSIDE:
                Log.d(TAG, "ENTER beacon region: " + region);
                break;
            case ProximityKitMonitorNotifier.OUTSIDE:
                Log.d(TAG, "EXIT beacon region: " + region);
                break;
            default:
                Log.d(TAG, "Received unknown state: " + state);
                break;
        }
    }
}
```

Now that we've implemented the interface, we still need to tell our manager
instance that it needs to send us the notifications. Modify the `onCreate`
definition to do this:

```java
@Override
public void onCreate() {
    super.onCreate();

    synchronized (pkManagerLock) {
        if (pkManager == null) {
            pkManager = ProximityKitManager.getInstance(this, loadConfig());
        }
    }

    // Set any/all desired notification callbacks
    pkManager.setProximityKitMonitorNotifier(this);

    /*
     * Now that everything is configured start the Proximity Kit Manager.
     * This syncs with the Proximity Kit cloud servers and ensures necessary
     * adapters are initialized.
     */
    pkManager.start();
}
```

It's important to set this, and any other notifiers, before calling `start()`
on the Proximity Kit manager. This is to avoid any potential race conditions
where notifications may be sent before the target notifier has been set.

## Detecting Beacons

At this time it is not possible to use the Android Emulator to detect beacons.
If you have an Android device with BLE or Bluetooth 4.0 you may use it to run
your application and successfully detect. Most mid-range and above Android
devices that started manufacturing in Mid-2012 or later have Bluetooth LE.

## Accessing Region Attributes

One of the wonderful features of Proximity Kit is the ability to associate
custom attribute metadata with your beacons and regions. Accessing this
metadata is easy to do in the callbacks. Let's update our example to look for a
custom welcome message when we enter a beacon's region:

```java
@Override
/**
 * Called when at least one beacon in a
 * <code>ProximityKitBeaconRegion</code> is visible.
 *
 * @param region    an <code>ProximityKitBeaconRegion</code> which defines
 *                  the criteria of beacons being monitored
 */
public void didEnterRegion(ProximityKitBeaconRegion region) {
    String welcomeMessage = region.getAttributes().get("welcomeMessage");
    if (welcomeMessage == null) {
      welcomeMessage = "Hello from the getting started guide!"
    }

    Log.d(TAG, "ENTER beacon region: " + region + " " + welcomeMessage);
}
```

## Working with Geofences

The Android Proximity Kit library uses [Google Play
services](https://developer.android.com/google/play-services/index.html) to
detect geofences. In order to include geofence support in your app, you'll need
to add support for Google Play services. If you are not using geofences then
you can simply ignore this section; the Proximity Kit library has geofence
support disabled by default.

### Using Google Play Services

The steps involved in configuring Google Play services vary depending on the
version of Google Play services you plan on using, as well as, your choice of
development environment. We strongly urge you to consult [Setting Up Google
Play Services](https://developer.android.com/google/play-services/setup.html)
on how to appropriately configure your specific application.

The choice of using geofences is left up your app. This is because only you,
the app developer, can make an appropriate decision for how to handle the
situation where an older device does not support geofences or it does not yet
have Google Play services installed. For the most recent suggestions by Google
on how to check for Google Play support please refer to the [Android
documentation on checking for Google Play services support](https://developer.android.com/google/play-services/setup.html#ensure).

> Because each app uses Google Play services differently, it's up to you [the
> app developer] decide the appropriate place in your app to check verify the
> Google Play services version. For example, if Google Play services is
> required for your app at all times, you might want to do it when your app
> first launches. On the other hand, if Google Play services is an optional
> part of your app, you can check the version only once the user navigates to
> that portion of your app.
>
> To verify the Google Play services version, call
> `isGooglePlayServicesAvailable()`. If the result code is `SUCCESS`, then the
> Google Play services APK is up-to-date and you can continue to make a
> connection. If, however, the result code is `SERVICE_MISSING`,
> `SERVICE_VERSION_UPDATE_REQUIRED`, or `SERVICE_DISABLED`, then the user needs
> to install an update. So, call `GooglePlayServicesUtil.getErrorDialog()` and
> pass it the result error code. This returns a `Dialog` you should show, which
> provides an appropriate message about the error and provides an action that
> takes the user to Google Play Store to install the update.

For the purposes of this getting started sample, we'll opt to send a simple
notification if there is a problem using Google Play services. Since it's
possible that we need to perform this check in several places we'll put it
in a helper method:

```java
public boolean servicesConnected() {
    // Check that Google Play services is available
    int resultCode = GooglePlayServicesUtil.isGooglePlayServicesAvailable(this);

    bool isAvailable = (ConnectionResult.SUCCESS == resultCode)

    if (isAvailable) {
        Log.d(TAG, "Google Play services available");
    else {
        Log.w(TAG, GooglePlayServicesUtil.getErrorString(resultCode));
        GooglePlayServicesUtil.showErrorNotification(resultCode, this);
    }

    return isAvailable;;
}
```

### Enabling Geofences

With our logic for checking the availability of Google Play services in place,
we can consider enabling geofences in Proximity Kit. We must be sure to only
enable geofences in the Proximity Kit API, after the  app has verified that
Google Play services is available. Since we'd also like to have geofences
working from the start we'll put all of this in the `onCreate` method before we
start the Proximity Kit manager:

```java
@Override
public void onCreate() {
    super.onCreate();

    synchronized (pkManagerLock) {
        if (pkManager == null) {
            pkManager = ProximityKitManager.getInstance(this, loadConfig());
        }
    }

    /*
     * It is our job (the app) to ensure that Google Play services is
     * available. If it is not then attempting to enable geofences in Proximity
     * Kit will fail, throwing a GooglePlayServicesException.
     */
    if (servicesConnected()) {
        // As a safety mechanism, `enableGeofences()` throws a checked
        // exception in case we didn't properly handle Google Play support.
        try {
            pkManager.enableGeofences();
        } catch (GooglePlayServicesException e) {
            Log.e(TAG, e.getMessage());
        }
    }

    // Set any/all desired notification callbacks
    pkManager.setProximityKitMonitorNotifier(this);

    /*
     * Now that everything is configured start the Proximity Kit Manager.
     * This syncs with the Proximity Kit cloud servers and ensures necessary
     * adapters are initialized.
     */
    pkManager.start();
}
```

### Geofence Events

Similar to working with beacons, the app needs to register the callback obeject
which will get notified on geofence events. As before, we'll use our custom
application instance as the notification target.

Implement the `ProximityKitGeofenceNotifier` interface:

```java
import com.radiusnetworks.proximity.ProximityKitGeofenceNotifier;
import com.radiusnetworks.proximity.ProximityKitGeofenceRegion;

public class AndroidProximityKitReferenceApplication
        extends     Application
        implements  ProximityKitMonitorNotifier,
                    ProximityKitGeofenceNotifier {

    @Override
    /**
     * Called when a <code>Geofence</code> is visible.
     *
     * @param geofence  a <code>ProximityKitGeofenceRegion</code> that defines
     *                  the criteria of Geofence to look for
     */
    public void didEnterGeofence(ProximityKitGeofenceRegion region) {
        String welcomeMessage = region.getAttributes().get("welcomeMessage");
        if (welcomeMessage == null) {
          welcomeMessage = "Hello from the getting started guide!"
        }

        Log.d(TAG, "ENTER geofence region: " + region + " " + welcomeMessage);
    }

    @Override
    /**
     * Called when a previously visible <code>Geofence</code> disappears.
     *
     * @param geofence  a <code>ProximityKitGeofenceRegion</code> that defines
     *                  the criteria of Geofence to look for
     */
    public void didExitGeofence(ProximityKitGeofenceRegion region) {
        Log.d(TAG, "EXIT geofence region: " + region);
    }

    @Override
    /**
     * Called when the device is cross a <code>Geofence</code> boundary.
     *
     * Called with a state value of
     * <code>ProximityKitGeofenceNotifier.INSIDE</code> when the device is
     * completely within a <code>Geofence</code>.
     *
     * Called with a state value of
     * <code>ProximityKitGeofenceNotifier.OUTSIDE</code> when the device is no
     * longer in a <code>Geofence</code>.
     *
     * @param state     either <code>ProximityKitGeofenceNotifier.INSIDE</code>
     *                  or <code>ProximityKitGeofenceNotifier.OUTSIDE</code>
     *                  @param geofence the
     *                  <code>ProximityKitGeofenceRegion</code> region this is
     *                  event is associated
     */
    public void didDetermineStateForGeofence(int state, ProximityKitGeofenceRegion region) {
        Log.d(TAG, "didDeterineStateForGeofence called with region: " + region);

        switch (state) {
            case ProximityKitGeofenceNotifier.INSIDE:
                Log.d(TAG, "ENTER beacon region: " + region);
                break;
            case ProximityKitGeofenceNotifier.OUTSIDE:
                Log.d(TAG, "EXIT beacon region: " + region);
                break;
            default:
                Log.d(TAG, "Received unknown state: " + state);
                break;
        }
    }
}
```

Now that we've implemented the interface, we need to update our `onCreate`
method to tell the Proximity Kit manager to send us the notifications:

```java
@Override
public void onCreate() {
    super.onCreate();

    synchronized (pkManagerLock) {
        if (pkManager == null) {
            pkManager = ProximityKitManager.getInstance(this, loadConfig());
        }
    }

    /*
     * It is our job (the app) to ensure that Google Play services is
     * available. If it is not then attempting to enable geofences in Proximity
     * Kit will fail, throwing a GooglePlayServicesException.
     */
    if (servicesConnected()) {
        // As a safety mechanism, `enableGeofences()` throws a checked
        // exception in case we didn't properly handle Google Play support.
        try {
            pkManager.enableGeofences();

            // No point setting the notifier if we aren't using geofences
            pkManager.setProximityKitGeofenceNotifier(this);
        } catch (GooglePlayServicesException e) {
            Log.e(TAG, e.getMessage());
        }
    }

    // Set any/all desired notification callbacks
    pkManager.setProximityKitMonitorNotifier(this);

    /*
     * Now that everything is configured start the Proximity Kit Manager.
     * This syncs with the Proximity Kit cloud servers and ensures necessary
     * adapters are initialized.
     */
    pkManager.start();
}
```

