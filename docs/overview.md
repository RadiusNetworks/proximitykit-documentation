# Proximity Kit Documentation

Designed to help developers build location aware apps. By providing a rich SDK built on top of the latest Geofence and Beacon technology, Proximity Kit gives you the events you need to keep your app relevant and useful to your users.


## The Lifecycle of a Proximity Kit

<div class="tiles clearfix">
  <div class="tile">
    <img class="tile-image" src="pk-configure.png">
    <h3>1. Configure Geofences and Beacons in the Web Portal</h3>
    <p>Configure and manage your Geofences and Beacons in our simple web portal. This is where you setup your kit, normally one kit per app, and set the region attributes.</p>
  </div>
  <div class="tile">
    <img class="tile-image" src="pk-cloud.png">
    <h3> 2. Mobile SDK Syncs with Mobile Device </h3>
    <p> When the app starts up the Proximity Kit Manager, it will sync with our backend. As that happens the SDK will register each region to monitor. Your region data and configuration is cached and can be updated in the background.</p>
  </div>
  <div class="tile">
    <img class="tile-image" src="pk-monitor.png">
    <h3> 3. Device Monitors for Proximity Events </h3>
    <p> When your app is in the background, we'll monitor for proximity events, even after the user restarts their phone. When your app is in the foreground, Proximity Kit will provide detailed information about the Beacons or GPS coordinates around it.</p>
  </div>
</div>

Upon entering or leaving an Beacon or Geofence region, Proximity Kit notifies your app of the proximity event along with region identifiers and associated metadata. While in an Beacon region, Proximity Kit provides additional ranging services for continuous proximity updates relative to the phone's distance from the Beacon.

---

## Beacon Hardware

While Proximity Kit will work with beacons that implment iBeacon™ Technology or that follow the [AltBeacon Standard](http://altbeacon.org/). This is subject to mobile device operating system and hardware support.

We do build our own beacons and believe they are the best beacon hardware out there. That is avaliable in the [Radius Networks Store](http://store.radiusnetworks.com/).

There are also software alternatives to broadcasting as a beacon, a few of our apps include [Locate for iOS](http://store.radiusnetworks.com/collections/all/products/locate-ibeacon-app), [QuickBeacon](http://store.radiusnetworks.com/collections/software/products/quickbeacon) and [MacBeacon](http://store.radiusnetworks.com/collections/all/products/macbeacon).


<a class="btn" href="http://store.radiusnetworks.com/">Buy Beacons</a>

---

## Android Resources

The Android Proximity Kit SDK is currently built upon our open source
[Android Beacon Library](https://github.com/AltBeacon/android-beacon-library).
Which is designed to work with the [AltBeacon Standard](http://altbeacon.org/).

### Download the SDK

<a class="btn" href="https://proximitykit.radiusnetworks.com/android-download">Android SDK Download and Install</a>

Users of the Proximity Kit client library agree to abide by the license terms as specified for <a href="android/license">Android</a>.

## Additional Resources

<a class="btn" href="android/getting-started">Getting Started</a>
<a class="btn" href="http://developer.radiusnetworks.com/proximitykit/android/docs/0.2.0/">SDK Reference</a>
<a class="btn" href="https://github.com/RadiusNetworks/proximitykit-reference-android">Android Studio Reference App</a>

<a class="btn" href="https://altbeacon.github.io/android-beacon-library/javadoc/index.html">Android Beacon Library Documentation</a>

---

## iOS Resources

The iOS Proximity Kit SDK is built upon Apple's CoreLocation, extending the functionality and web management.

### Download the SDK

<a class="btn" href="https://proximitykit.radiusnetworks.com/download">iOS SDK Download and Install</a>

Users of the Proximity Kit client library agree to abide by the license terms as specified for [iOS](ios/license).

### Additional Resources

<a class="btn" href="ios/getting-started">Getting Started</a> <a class="btn" href="ios/webbeacon">10 Minute Tutorial</a> <a class="btn" href="http://developer.radiusnetworks.com/proximitykit/ios/docs/">SDK Reference</a>

<a class="btn" href="https://github.com/RadiusNetworks/proximity-kit-ios-example">iOS Reference App</a> <a class="btn" href="ios/tracking-beacons">Tracking Beacons Example</a>

---

## Still need a hand?

If you have any other questions feel free to drop us a [note](mailto:support@radiusnetworks.com).

