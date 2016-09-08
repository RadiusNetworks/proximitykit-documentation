# Getting started with Proximity Kit

This guide should get your app working with Geofencing and the Proximity Kit service.

## Download and Install

If you have not downloaded the Proximity Kit framework and added it to your project you should [go do that first](download).

Note: Users of the Proximity Kit client library agree to abide by the license terms as
 specified for [iOS](license) and [Android](../android/license).

## Add Location Usage String to Info.plist

Starting in iOS 8, all apps need to include the "location usage string" in their `Info.plist`

You will need to add the following key:

- `NSLocationAlwaysUsageDescription`

This is needed so that Proximity Kit can continue to monitor for beacons and geofences in the background.

The value of this key will be displayed to the user under Settings in the "App explanation". You will want to populate this string a short explanation why the user would want to allow sharing of their current location and proximity to beacons.

An example explanation for a resturant app might be: "This app will use your location information to notify you about and access services avaliable in the resturant"

## Link to Shared Libraries

Proximity Kit uses CoreLocation, CoreBluetooth and SQLite internally. So we need to link to them in your project.

- Select the App's target in Xcode
- Choose "Build Phases"
- Under the "Link Binary With Libraries" section click the '+' to add another library
- Choose the following and click "Add"
  - `CoreLocation`
  - `CoreBluetooth`
  - `libsqlite3.dylib`

## Creating a Location Manager

Proximity Kit adds a wrapper around the standard Core Location Manager. This allows for automatic registering of geofences and beacons, but should give your app all the power and control it needs to use location data.

First, we need to create an instance of the `RPKManager`. Each app should have only one instance of this object. For simple applications we recommend this to be a property on your Application Delegate. However, this works just fine on any class as long as the object is around for the lifetime of the application. For simplicity's sake this document will describe setting up the `AppDelegate` class to work with the `RPKManager` instance.

In `AppDelegate.h` add the protocol for `RPKManagerDelegate` and a property to store an instance of the manager:

```objc

#import <UIKit/UIKit.h>
#import <ProximityKit/ProximityKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, RPKManagerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) RPKManager *proximityKitManager;

@end
```

In `AppDelegate.m` allocate the manager and assign the delegate:

```objc

- (BOOL)application:(UIApplication *)application
        didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // create and start to sync the manager with the Proximity Kit backend
    self.proximityKitManager = [RPKManager managerWithDelegate:self];
    [self.proximityKitManager start];

    return YES;
}
```

There is more to the `RPKManager` API, take a look in `RPKManager.h` in the Proximity Kit framework for the full listing.

## Create the delegate methods

Within your AppDelegate class you can define either the enter or exit region methods, which will be called when the app enters or exits a fence.

```objc
#pragma mark -
#pragma mark ProximityKit delegate methods

- (void)proximityKit:(RPKManager *)manager didEnter:(RPKRegion *)region {
    NSLog(@"entered %@", region);
}
- (void)proximityKit:(RPKManager *)manager didExit:(RPKRegion *)region {
    NSLog(@"exited %@", region);
}
```

There are a number of other delegate methods, take a look in `RPKManagerDelegate.h` in the Proximity Kit framework for the full listing.

## Simulating Geofences

In the iPhone simulator you can change the location in the menu "Debug -> Location -> Custom Location...".

From there you will have a form where you can enter GPS coordinates of your location.

Note: If the location is set to coordinates within your fence when the simulator is launched you may have to set it out side of the fance and back inside again.

## Simulating beacons

While you can't yet simulate an beacon in the iPhone Simulator, you can use [MacBeacon](http://www.radiusnetworks.com/macbeacon-app.html). It makes testing iBeacon functionality easy, particularly since your Mac can broadcast as an iBeacon while running your app directly from Xcode. This is a great way to explore how the beacon behaves while in the Xcode debugger.



