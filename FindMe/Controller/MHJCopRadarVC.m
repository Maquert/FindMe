//
//  MHJCopRadarVC.m
//  FindMe
//
//  Created by Miguel Hernández Jaso on 28/01/14.
//  Copyright (c) 2014 mhj. All rights reserved.
//

@import CoreLocation;

#import "MHJCopRadarVC.h"

#import "MHJBeaconCell.h"


@interface MHJCopRadarVC ()

// CoreLocation
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLBeaconRegion *beaconRegion;

@property (strong, nonatomic) NSMutableArray *beaconsArray;

@end

@implementation MHJCopRadarVC

static NSString * const beaconRegionIdentifier = @"com.aenia.DemoRegion";


#pragma mark - LifeCycle

-(void) viewDidLoad
{
    [super viewDidLoad];
    self.beaconsArray = [[NSMutableArray alloc] init];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

#pragma mark - Beacons

-(void) registerBeaconRegionWithUUID:(NSUUID *)proximityUUID
                       andIdentifier:(NSString *) identifier
{
    CLBeaconRegion *beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:proximityUUID identifier:identifier];
    
    beaconRegion.notifyEntryStateOnDisplay = NO;
    [beaconRegion setNotifyOnEntry:YES]; // Default
    [beaconRegion setNotifyOnExit:YES];
    
    [self.locationManager startMonitoringForRegion:beaconRegion];
    self.beaconRegion = beaconRegion;
}


-(void) startSearching
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    if ([CLLocationManager isRangingAvailable]) {
        [self registerBeaconRegionWithUUID:[[NSUUID alloc] initWithUUIDString:iBeaconsUUID] andIdentifier:beaconRegionIdentifier];
    }
    
}

-(void) stopSearching
{
    if ([CLLocationManager isRangingAvailable])
    {
        [self.locationManager stopMonitoringForRegion:self.beaconRegion];
    }
    
    self.beaconRegion = nil;
    self.locationManager = nil;
    [self.beaconsArray removeAllObjects];
    [self.tableView reloadData];
}




#pragma mark - Events

-(IBAction)startStopSearching:(id)sender
{
    if (!self.locationManager) {
        [self startSearching];
        self.startStopButton.title = @"Shut Down";
    } else {
        [self stopSearching];
        self.startStopButton.title = @"Power up";
    }
}




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [self.beaconsArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BeaconCell";
    MHJBeaconCell *beaconCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    CLBeacon *beacon = self.beaconsArray[indexPath.row];
    beaconCell = [self configureCell:beaconCell withBeacon:beacon];
    
    return beaconCell;
}


-(MHJBeaconCell *) configureCell:(MHJBeaconCell *) beaconCell
                      withBeacon:(CLBeacon *) beacon
{
    beaconCell.nameLabel.text = @"iPhone";
    beaconCell.proximityLabel.text = [self proximityText:beacon.proximity];
    beaconCell.accuaracyLabel.text = [self accuaracyText:beacon.accuracy withRssi:beacon.rssi];
    
    return beaconCell;
}

-(NSString *) proximityText:(CLProximity) proximity
{
    NSString *proximityText = @"";
    switch (proximity) {
        case 1:
            proximityText = @"Got it!";
            break;
        case 2:
            proximityText = @"Hot... Almost. C'mon!";
            break;
        case 3:
            proximityText = @"Cold... very cold...";
            break;
        default:
            proximityText = @"Unknown location";
            break;
    }

    return proximityText;
}

-(NSString *) accuaracyText:(CLLocationAccuracy) accuaracy
                   withRssi:(NSInteger) strength
{
    NSString *accuaracyText = [NSString stringWithFormat:@"Accuracy: %0.2f", accuaracy];
    NSString *rssiText = [NSString stringWithFormat:@" Signal Strength:%ld", (long)strength];
    
    return [NSString stringWithFormat:@"%@ %@", accuaracyText, rssiText];
}





#pragma mark - LocationManagerDelegate Regions

- (void)locationManager:(CLLocationManager *)manager
      didDetermineState:(CLRegionState)state
              forRegion:(CLRegion *)region{
    
    if (state == CLRegionStateInside) {
        NSLog(@"Inside region %@", region.identifier);
        [self.locationManager startRangingBeaconsInRegion:(CLBeaconRegion *)region];
    } else {
        NSLog(@"Outside region %@", region.identifier);
        [self.locationManager stopRangingBeaconsInRegion:(CLBeaconRegion *)region];
    }
}

#pragma mark - LocationManagerDelegate Beacons

-(void) locationManager:(CLLocationManager *)manager
        didRangeBeacons:(NSArray *)beacons
               inRegion:(CLBeaconRegion *)region
{
    [self.beaconsArray removeAllObjects];
    if ([beacons count] > 0) {
        [self.beaconsArray addObjectsFromArray:beacons];
    }
    
    [self.tableView reloadData];
}


-(void) locationManager:(CLLocationManager *)manager
         didEnterRegion:(CLRegion *)region
{
    NSLog(@"Entering region %@", region.identifier);
}

-(void)locationManager:(CLLocationManager *)manager
         didExitRegion:(CLRegion *)region
{
    NSLog(@"Now away from region %@", region.identifier);
}


- (void)locationManager:(CLLocationManager *)manager
rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region
              withError:(NSError *)error {
    NSLog(@"Beacon Ranging Failed");
}




@end
