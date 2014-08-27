## Tracking Beacons Example Code

The following example code shows a variable and methods you would add to your
AppDelegate class to keep track of whether you have seen specific iBeacons
before, and how long ago it was. Simply replace the NSLog statements below
with custom logic of what you wish to do when a beacon is newly seen, or if a
certain amount of time has passed since one was seen.

```objective-c
NSMutableDictionary *beaconLastSeen;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    ...
    beaconLastSeen = [[NSMutableDictionary alloc] init];
}

- (void)proximityKit:(PKManager *)manager
     didRangeBeacons:(NSArray *)beacons
            inRegion:(PKRegion *)region
{
    for (PKIBeacon *beacon in beacons) {
        NSString *beaconKey = [NSString stringWithFormat:@"%@_%ld_%ld",
                                  [beacon.uuid UUIDString],
                                  (long) beacon.major,
                                  (long) beacon.minor];
        NSLog(@"Ranged UUID: %@ Major:%ld Minor:%ld RSSI:%ld",
                  [beacon.uuid UUIDString],
                  (long)beacon.major,
                  (long)beacon.minor,
                  (long)beacon.rssi);
        if ([beaconLastSeen objectForKey:beaconKey] == Nil) {
            NSLog(@"This beacon has never been seen before");
        }
        else {
            NSLog(@"This beacon was last seen at %@", [beaconLastSeen objectForKey:beaconKey]);
        }
        [beaconLastSeen setObject:[NSDate date] forKey:beaconKey];
    }
}
```
