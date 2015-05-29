# Urban Airship Integration

Proximity Kit offers first class integration with the Urban Airship SDK. Proximity Kit levereges our meta data attributes to allow the integration settings to be configured remotely.

This integration combines Proximity Regions with Urban Airship's Tags and Events.

Note: This functionality is currently iOS only. Android coming soon, if you want to be updated when it is avaliable [let us know](mailto:support@radiusnetworks.com).

# Enable Integration in your App

To enable integration in the SDK, you will need to set the Urban Airship manager on the proximity kit manager. This is a simple one-liner:

```objc
[self.pkManager setAirship: [UAirship shared]];
```

That's it. Now the Proximity Kit SDK will look for the meta data attributes and handle the rest of the integration on the actual device. Now all you need to do is set tags or events.

# Tags

Urban Airship uses tags as a way to group different devices. Proximity Kit will add and remove tags as they enter and exit a region--for both Beacon Regions and Geofence Regions. In this way you can use the tag as an indication that the device is within a given region.

To add and remove tags in Urban Airship, you will need to add a `ua_tags` meta data attribute to you region.

This can be done by:

- Edit the Region
- Click on the "Add Meta Data Attribute"
- Set the key to `ua_tags`
- Set the value to a comma seperated list of tags

Now any devices that encounter that region will add those tags upon entering, and remove them when they exit.

# Events

Urban Airship uses [Custom Events](http://docs.urbanairship.com/topic-guides/custom-events.html) to let you track user activities and conversions. Proximity Kit will create events and publish them to the Urban Airship SDK as devices enter regions. This will let you use their proximity as an indication of the success of the push messaging campaigns.

To create an event in Urban Airship, you will need to add a `ua_event` meta data attribute to you region.

This can be done by:

- Edit the Region
- Click on the "Add Meta Data Attribute"
- Set the key to `ua_event`
- Set the value to the event name you want to appear in Urban Airship dashboard

Once you do this any devices that encounter that region will add that event when they enter the region.
