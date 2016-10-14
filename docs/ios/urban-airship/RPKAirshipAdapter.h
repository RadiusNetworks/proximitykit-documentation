// RPKAirshipAdapter
//
// Reference class for implmenting Urban Airship Integration with Proximity Kit
//
// This class can be added to an iOS all to integrate beacon presense using the
// exisitng Proximity Kit configuration with the Urban Airship SDK. This will
// subscribe to NSNotifications broadcast by ProximityKit.
//
// Usage:
//
//     RPKAirshipAdapter *pkAdapter = RPKAirshipAdapter;
//     [pkAdapter start];
//
@interface RPKAirshipAdapter : NSObject
@property UAirship* airship;

-(void) start;
-(void) stop;

@end
