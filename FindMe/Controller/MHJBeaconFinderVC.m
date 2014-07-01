//
//  MHJBeaconFinderVC.m
//  FindMe
//
//  Demo and template class
//  Not funcional
//
//  Created by Miguel Hernández Jaso on 28/01/14.
//  Copyright (c) 2014 mhj. All rights reserved.
//

#import "MHJBeaconFinderVC.h"

@interface MHJBeaconFinderVC ()

@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation MHJBeaconFinderVC

static NSString *const beaconRegionIdentifier = @"com.aenia.DemoRegion";


/*
* This class is not intended for production, but as a template for common methods using iBeacons.
* For a practical use, check 'Cop' and 'Robber' controllers instead
*/

#pragma mark - LifeCycle

-(void) viewDidLoad
{
    [self registerBeaconRegionWithUUID:[[NSUUID alloc] initWithUUIDString:iBeaconsUUID]
                         andIdentifier:beaconRegionIdentifier];
}



#pragma mark - Beacons Regions

-(void) registerBeaconRegionWithUUID:(NSUUID *) proximityUUID
                       andIdentifier:(NSString *) identifier
{
    CLBeaconRegion *beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:proximityUUID identifier:identifier];
    
    beaconRegion.notifyEntryStateOnDisplay = YES;
    [beaconRegion setNotifyOnEntry:YES]; // Default
    [beaconRegion setNotifyOnExit:NO];
    
    [self.locationManager startMonitoringForRegion:beaconRegion];
}




#pragma mark - CLLocationManagerDelegate Delegate

// Inside a region
-(void) locationManager:(CLLocationManager *)manager
        didRangeBeacons:(NSArray *)beacons
               inRegion:(CLBeaconRegion *)region
{
    if ([beacons count] > 0) {
        CLBeacon *nearestBeacon = [beacons firstObject];
        
        if (nearestBeacon.proximity == CLProximityNear) {
            NSLog(@"Beacon %@ located pretty close to you.\nMajor: %ld\nMinor: %ld", nearestBeacon.proximityUUID, (long)nearestBeacon.major.integerValue, (long)nearestBeacon.minor.integerValue);
        }
        else if (nearestBeacon.proximity == CLProximityFar) {
            NSLog(@"Beacon %@ located nearby.\nMajor: %ld\nMinor: %ld", nearestBeacon.proximityUUID, (long)nearestBeacon.major.integerValue, (long)nearestBeacon.minor.integerValue);
        }
    }
    
    if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateBackground)
    {
        NSLog(@"Still receiving events from iBeacons!");
    }
}



// Region Search
-(void) locationManager:(CLLocationManager *)manager
      didDetermineState:(CLRegionState)state
              forRegion:(CLRegion *)region
{
    if (state == CLRegionStateInside)
    {
        NSLog(@"Entered region ID:%@ - %@", region.identifier, region);
        
        if ([CLLocationManager isRangingAvailable]) {
            [self.locationManager startRangingBeaconsInRegion:(CLBeaconRegion *)region];
        }
    }
    else if (state == CLRegionStateOutside)
    {
        NSLog(@"Exited region ID:%@", region.identifier);
        if ([CLLocationManager isRangingAvailable]) {
            [self.locationManager stopRangingBeaconsInRegion:(CLBeaconRegion *)region];
        }
    }
    else
    {
        NSLog(@"Unkown state for region ID:%@- %@", region.identifier, region);
        // Indetermined
    }
}

-(void) locationManager:(CLLocationManager *)manager
         didEnterRegion:(CLRegion *)region
{
    NSLog(@"Entering region %@", region.identifier);
}

-(void)locationManager:(CLLocationManager *)manager
         didExitRegion:(CLRegion *)region
{
    NSLog(@"Away from region %@", region.identifier);
}




#pragma mark - Properties

-(CLLocationManager *)locationManager
{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
    }
    return _locationManager;
}





@end
