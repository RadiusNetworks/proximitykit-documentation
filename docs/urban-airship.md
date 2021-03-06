# Urban Airship Integration

Proximity Kit offers first class integration with the Urban Airship SDK. Proximity Kit leverages our meta data attributes to allow the integration settings to be configured remotely.

This integration combines Proximity Regions with Urban Airship's Tags and Events.

Note: This functionality is currently iOS only. Android support coming soon, if you want to be updated when it is available [let us know](mailto:support@radiusnetworks.com).

# Enable Integration in your App

To enable integration in the SDK, you will need to add the reference code provided in our `RPKAirshipAdapter` class, and start that up. This class will listen to NSNotifications broadcast by the `RPKManager`. Note that the `RPKAirshipAdapter` must have a strong reference so it is not garbage collected.

```objc
@property (nonatomic, strong) RPKAirshipAdapter *pkAdapter;
...

self.pkAdapter = [[RPKAirshipAdapter alloc] init];
[pkAdapter start];
```

The source for this reference is avaliable [here](ios/urban-airship/).

Now the Proximity Kit/Urban Airship Adapter will listen for the meta data attributes and handle the rest of the integration on the actual device. Now all you need to do is set tags or events.

# Tags

Urban Airship uses tags as a way to group different devices. Proximity Kit will add and remove tags as they enter and exit a region--for both Beacon Regions and Geofence Regions. In this way you can use the tag as an indication that the device is within a given region.

To add and remove tags in Urban Airship, you will need to add a `ua_tags` meta data attribute to your region.

This can be done by:

- Edit the Region
- Click on the "Add Meta Data Attribute"
- Set the key to `ua_tags`
- Set the value to a comma-separated list of tags

Now any devices that encounter that region will add those tags upon entering, and remove them when they exit.

# Persistent Tags

Persistent Tags work the same way as Tags, but are not removed when the device exits the region.

To add persistent tags in Urban Airship, you will need to add a `ua_persistent_tags` meta data attribute to your region.

This can be done by:

- Edit the Region
- Click on the "Add Meta Data Attribute"
- Set the key to `ua_persistent_tags`
- Set the value to a comma-separated list of tags

Now any devices that encounter that region will add those tags upon entering, leaving them associated with the device indefinitely.

# Events

Urban Airship uses [Custom Events](http://docs.urbanairship.com/topic-guides/custom-events.html) to let you track user activities and conversions. Proximity Kit will create events and publish them to the Urban Airship SDK as devices enter regions. This will let you use their proximity as an indication of the success of the push messaging campaigns.

To create an event in Urban Airship, you will need to add a `ua_event` meta data attribute to your region.

This can be done by:

- Edit the Region
- Click on the "Add Meta Data Attribute"
- Set the key to `ua_event`
- Set the value to the event name you want to appear in Urban Airship dashboard

Once you do this any devices that encounter that region will add that event when they enter the region.
