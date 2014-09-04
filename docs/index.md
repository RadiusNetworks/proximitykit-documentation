<p>Designed to help developers build location aware apps. By providing a rich SDK built on top of the latest Geofence and iBeacon technology, Proximity Kit gives you the events you need to keep your app relevant and useful to your users.</p>

<hr>

<h2>The Lifecycle of a Proximity Kit</h2>

<div class="tiles clearfix">
  <div class="tile">
    <img class="tile-image" src="/img/pk-configure.png">
    <h3>1. Configure Geofences and iBeacons in the Web Portal</h3>
    <p>Configure and manage your Geofences and iBeacons in our simple web portal. This is where you setup your kit, normally one kit per app, and set the region attributes.</p>
  </div>
  <div class="tile">
    <img class="tile-image" src="/img/pk-cloud.png">
    <h3> 2. Mobile SDK Syncs with Mobile Device </h3>
    <p> When the app starts up the Proximity Kit Manager, it will sync with our backend. As that happens the SDK will register each region to monitor. Your region data and configuration is cached and can be updated in the background.</p>
  </div>
  <div class="tile">
    <img class="tile-image" src="/img/pk-monitor.png">
    <h3> 3. Device Monitors for Proximity Events </h3>
    <p> When your app is in the background, we'll monitor for proximity events, even after the user restarts their phone. When your app is in the foreground, Proximity Kit will provide detailed information about the iBeacons or GPS coordinates around it.</p>
  </div>
</div>

<p>Upon entering or leaving an iBeacon or Geofence region, Proximity Kit notifies your app of the proximity event along with region identifiers and associated metadata. While in an iBeacon region, Proximity Kit provides additional ranging services for continuous proximity updates relative to the phone's distance from the iBeacon.</p>

<hr>

<h1>iBeacon Hardware</h1>

<p>One of the best resources we have for general iBeacon information is our <a href="/blog">blog</a>. There you can find information about <a href="http://developer.radiusnetworks.com/2013/11/04/how-to-make-an-ibeacon-with-the-ti-cc2540.html">building</a> <a href="http://developer.radiusnetworks.com/2013/10/09/how-to-make-an-ibeacon-out-of-a-raspberry-pi.html">iBeacons</a>, common misconceptions about <a href="http://developer.radiusnetworks.com/2014/01/10/ibeacon-misconceptions.html">how they work</a>, as well tools to <a href="http://www.radiusnetworks.com/macbeacon-app.html">simulate</a> and <a href="http://www.radiusnetworks.com/scanbeacon-app.html">detect</a> iBeacons.</p>

<hr>

<h1>Android Resources</h1>

<p>The Proximity Kit Android Library is the same as the Android Pro Library. It is built upon our open source <a href="/ibeacon/android/">Android iBeacon Library</a>, and all the documentation that applies to those libraries is relevant to working with Proximity Kit.</p>

<h3>Download the SDK</h3>

<p><a class="btn" href="http://proximitykit.com/android-download">Android SDK Download and Install</a></p>

<p>Users of the Proximity Kit client library agree to abide by the license terms as
 specified for <a href="proximity-kit-android-license.txt">Android</a>.</p>

<h3>Additional Resources</h3>

<p><a class="btn" href="/ibeacon/android/samples.html">Sample Code</a>
<a class="btn" href="/ibeacon/android/pro/documentation.html">Documentation</a></p>

<hr>

<h1>iOS Resources</h1>

<p>The iOS Proximity Kit SDK is built upon Apple's CoreLocation, extending the functionality and web management.</p>

<h3>Download the SDK</h3>

<p><a class="btn" href="http://proximitykit.com/download">iOS SDK Download and Install</a></p>

<p>Users of the Proximity Kit client library agree to abide by the license terms as
 specified for <a href="proximity-kit-ios-license.txt">iOS</a>.</p>

<h3>Additional Resources</h3>

<p><a class="btn" href="gettingstarted">Getting Started</a>
<a class="btn" href="webbeacon">10 Minute Tutorial</a>
<a class="btn" href="ios/docs">SDK Reference</a></p>

<p><a class="btn" href="https://github.com/RadiusNetworks/proximity-kit-ios-example">iOS Reference App</a>
<a class="btn" href="ios/tracking_beacons.html">Tracking Beacons Example</a></p>

<hr>

<h1>Still want help?</h1>

<h3>If you have any other questions feel free to drop us a <a href="mailto:support@radiusnetworks.com">note</a>.</h3>

