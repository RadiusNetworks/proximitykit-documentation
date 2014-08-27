# Getting started with Proximity Kit

This guide should get your app working with the Proximity Kit service.

## Download and Install

If you have not downloaded the Proximity Kit framework and added it to your
project you should [go do that first](<%= android_download_path %>).

**Note**: Users of the Proximity Kit client library agree to abide by the
license terms as specified for [iOS](/docs/ios/license) and
[Android](/docs/android/license).

## Creating a Proximity Kit Manager

Proximity Kit provides a wrapper around the [Android iBeacon
Library](http://developer.radiusnetworks.com/ibeacon/android/). This allows for
automatic registering of iBeacons, but should give your app all the power and
control it needs to use location data.

First, we need to create an instance of the
[`ProximityKitManager`](http://developer.radiusnetworks.com/ibeacon/android/pro/javadocs/com/radiusnetworks/proximity/ProximityKitManager.html).
Each app should have only one instance of this object. For simple applications
we recommend this to be a static field on your main `Activity`. However, this
works just fine on any class as long as the object is around for the lifetime
of the application. For simplicity's sake this document will describe setting
up the `MainActivity` class, generated when creating a new Android project, to
work with the `ProximityKitManager` instance.

In `MainActivity.java` add the interface for
[`ProximityKitNotifier`](http://developer.radiusnetworks.com/ibeacon/android/pro/javadocs/com/radiusnetworks/proximity/ProximityKitNotifier.html)
and a `static` field to store an instance of the manager:

```java
import com.radiusnetworks.proximity.ProximityKitManager;
import com.radiusnetworks.proximity.ProximityKitNotifier;

public class MainActivity
        extends ActionBarActivity
        implements ProximityKitNotifier {

    private static ProximityKitManager pkManager;

    // Reset of the activity
}
```

Locate the `onCreate` declaration in `MainActivity.java`. Allocate the manager
with the application context singleton and assign the activity as the target
notifier:

```java
@Override
protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_main);

    /*******************
     Setup Proximity Kit
     */
    // Use the singleton application context to retrieve the same manager
    // instance across activity lifecycles.
    pkManager = ProximityKitManager.getInstanceForApplication(
        getApplicationContext()
    );

    // There can be only one notifier. This is generally the main activity
    // for the application.
    pkManager.setNotifier(this);

    pkManager.getIBeaconManager().setDebug(true);

    // Ensure the manager is started.
    // This syncs with the Proximity Kit cloud and ensure necessary
    // adapters are initialized.
    pkManager.start();
}
```

## Create the interface methods

Within your `MainActivity` class you need to declare all of the available
`ProximityKitNotifier` interface methods, which will be called when various
important events occur:

```java
private static final String TAG = "MyProximityKitApp";

@Override
public void iBeaconDataUpdate(IBeacon iBeacon,
                              IBeaconData iBeaconData,
                              DataProviderException e) {
    Log.d(TAG, "updated " + iBeacon + "[" + iBeaconData + "]", e);
}

@Override
public void didEnterRegion(Region region) {
    Log.d(TAG, "entered " + region);
}

@Override
public void didExitRegion(Region region) {
    Log.d(TAG, "exited " + region);
}

@Override
public void didDetermineStateForRegion(int i, Region region) {
    Log.d(TAG, "state " + i + "(" + region + ")");
}

@Override
public void didSync() {
    Log.d(TAG, "successful sync");
}

@Override
public void didFailSync(Exception e) {
    Log.d(TAG, "failed sync", e);
}
```

For more details on each of these methods, take a look at:

- [`IBeaconDataNotifier`](http://developer.radiusnetworks.com/ibeacon/android/pro/javadocs/com/radiusnetworks/ibeacon/IBeaconDataNotifier.html)
- [`MonitorNotifier`](http://developer.radiusnetworks.com/ibeacon/android/pro/javadocs/com/radiusnetworks/ibeacon/MonitorNotifier.html)
- [`ProximityKitSyncNotifier`](http://developer.radiusnetworks.com/ibeacon/android/pro/javadocs/com/radiusnetworks/proximity/ProximityKitSyncNotifier.html)

## Detecting iBeacons

At this time it is not possible to use the Android Emulator to detect iBeacons.
If you have an Android device with BLE or Bluetooth 4.0 you use it to run your
application and successfully detect iBeacon. Most mid-range and above Android
devices that started manufacturing in Mid-2012 or later have Bluetooth LE.

If you own a Bluetooth 4.0 enabled Macintosh computer or laptop you can use
[MacBeacon](http://www.radiusnetworks.com/macbeacon-app.html) to turn it into
your own iBeacon. It makes testing iBeacon functionality easy, particularly
since your Mac can broadcast as an iBeacon while running your app directly from
Android Studio. This is a great way to explore how the beacon behaves while in
the debugger.

## Simulating iBeacons

With Android it is possible to simulate the detection of iBeacons. This is
especially useful for when you are testing in an Emulator or on a device
without BluetoothLE capability.

Setting up an iBeacon simulator is simple. Create a class which implements the
[`BeaconSimulator`](http://developer.radiusnetworks.com/ibeacon/android/pro/javadocs/com/radiusnetworks/ibeacon/simulator/BeaconSimulator.html)
interface. Let's create a simulator which acts like the
[RadBeacon](http://www.radiusnetworks.com/ibeacon/radbeacon/) hardware as a
nested class in `MainActivity.java`:

```java
private class RadBeaconSimulator implements BeaconSimulator {
    private List<IBeacon> beacons;

    public RadBeaconSimulator() {
        beacons = Arrays.asList(
            new IBeacon("2F234454-CF6D-4A0F-ADF2-F4911BA9FFA6", 1, 1)
        );
    }

    @Override
    public List<IBeacon> getBeacons() {
        return beacons;
    }
}
```

Now we just need to tell the Proximity Kit manager about our desire to simulate
iBeacons. Locate the `onCreate` declaration and register a new
`RadBeaconSimulator`:

```java
@Override
protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_main);

    /*******************
     Setup Proximity Kit
     */
    // Use the singleton application context to retrieve the same manager
    // instance across activity lifecycles.
    pkManager = ProximityKitManager.getInstanceForApplication(
        getApplicationContext()
    );

    // There can be only one notifier. This is generally the main activity
    // for the application.
    pkManager.setNotifier(this);

    pkManager.getIBeaconManager().setDebug(true);

    // Ensure the manager is started.
    // This syncs with the Proximity Kit cloud and ensure necessary
    // adapters are initialized.
    pkManager.start();

    /*****************
     Simulate iBeacons
     */
    pkManager.getIBeaconManager()
            .setBeaconSimulator(new RadBeaconSimulator());
}
```

Once the activity is created, any `IBeacon`s returned by the simulator's
`getBeacons` method will become visible to the application. Any changes to the
list of iBeacons returned be reflected immediately in the app. This allows
iBeacons to appear and disappear dynamically to the application. In the event
that there are live iBeacons within your radius and you are running a device
that has the ability to sense them, the simulated iBeacons will appear right
alongside the real ones.

Please note that any simulated iBeacons will be ignored by when the app is in
production mode.

## Simulating Geofences

Coming Soon!!
