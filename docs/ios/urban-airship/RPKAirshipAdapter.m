#import "RPKAirshipAdapter.h"
#import "RPKManager.h"
@import AirshipKit;

@implementation RPKAirshipAdapter

# pragma mark Constructor and Destructor

- (id)init {
  if (self = [super init]) {
    self.airship = [UAirship shared];
  }
  return self;
}

- (void)dealloc {
  [self stop];
}

#pragma mark Start and Stop the observers

-(void) start {
  [self registerForPKNotifications];
}
-(void) stop {
  [self unregisterForPKNotifications];
}

#pragma mark Notifications


- (void)registerForPKNotifications {
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(didEnterRegion:)
                                               name:RPKManagerDidEnterRegionNotification
                                             object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(didExitRegion:)
                                               name:RPKManagerDidExitRegionNotification
                                             object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(didDetermineStateForRegion:)
                                               name:RPKManagerDidDetermineStateForRegionNotification
                                             object:nil];
}

- (void)unregisterForPKNotifications {
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:RPKManagerDidEnterRegionNotification
                                                object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:RPKManagerDidExitRegionNotification
                                                object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:RPKManagerDidDetermineStateForRegionNotification
                                                object:nil];
}

- (void)didEnterRegion:(NSNotification *)notification {
  RPKRegion *region = notification.userInfo[RPKManagerNotificationRegionKey];
  [self addTags:region];
}

- (void)didExitRegion:(NSNotification *)notification {
  RPKRegion *region = notification.userInfo[RPKManagerNotificationRegionKey];
  [self removeTags:region];
}

- (void)didDetermineStateForRegion:(NSNotification *)notification {
  RPKRegion *region = notification.userInfo[RPKManagerNotificationRegionKey];
  CLRegionState state = [notification.userInfo[RPKManagerNotificationRegionStateKey] integerValue];

  if (state == RPKRegionStateInside) {
    [self addTags:region];
    [self addPersistentTags:region];
    [self addEvent:region];
  } else if (state == RPKRegionStateOutside) {
    [self removeTags:region];
  } else if (state == RPKRegionStateUnknown) {
    [self removeTags:region];
  }
}

#pragma mark Publish Tags Airship

- (void)addTags:(RPKRegion *)region {
  NSArray *tags = [self getTags:region];
  if ([tags count] > 0) {
    [self.airship addTags:tags];
  }
}

- (void)removeTags:(RPKRegion *)region {
  NSArray *tags = [self getTags:region];
  if ([tags count] > 0) {
    [self.airship removeTags:tags];
  }
}

- (void)addPersistentTags:(RPKRegion *)region {
  NSArray *tags = [self getPersistentTags:region];
  if ([tags count] > 0) {
    [self.airship addTags:tags];
  }
}

- (void)addEvent:(RPKRegion *)region {
  NSString *event = [self getEvent:region];
  if (event) {
    [self.airship addEvent:event];
  }
}

#pragma mark UA Tag Metadata

- (NSArray *)getTags:(RPKRegion *)region {
  NSMutableArray *tags = [[NSMutableArray alloc] init];

  NSString *uaTagStr = region.attributes[@"ua_tags"];
  if (uaTagStr) {
    for (NSString *tag in [uaTagStr componentsSeparatedByString:@","]) {
      [tags addObject:[tag stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    }
  }
  return tags;
}

- (NSArray *)getPersistentTags:(RPKRegion *)region {
  NSMutableArray *tags = [[NSMutableArray alloc] init];

  NSString *uaTagStr = region.attributes[@"ua_persistent_tags"];
  if (uaTagStr) {
    for (NSString *tag in [uaTagStr componentsSeparatedByString:@","]) {
      [tags addObject:[tag stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    }
  }
  return tags;
}

- (NSString *)getEvent:(RPKRegion *)region {
  return region.attributes[@"ua_event"];
}

@end
