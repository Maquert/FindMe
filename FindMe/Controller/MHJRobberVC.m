//
//  MHJRobberVC.m
//  FindMe
//
//  This class turns an valid iOS device into a searcheable iBeacon for our FindMe app
//
//  Created by Miguel Hernández Jaso on 28/01/14.
//  Copyright (c) 2014 mhj. All rights reserved.
//

@import CoreLocation;
@import CoreBluetooth;

#import "MHJRobberVC.h"


@interface MHJRobberVC () <CBPeripheralManagerDelegate>

@property (strong, nonatomic) CBPeripheralManager *peripheralManager;

@end



@implementation MHJRobberVC

static NSString *const beaconRegionIdentifier = @"com.aenia.DemoRegion";

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [self createBeacon];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [self.peripheralManager stopAdvertising];
}


-(void) createBeacon
{
    NSUUID *proximityUUID = [[NSUUID alloc] initWithUUIDString:iBeaconsUUID];
    
    CLBeaconRegion *beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:proximityUUID identifier:beaconRegionIdentifier];
    
    NSDictionary *beaconPeripheralData = [beaconRegion peripheralDataWithMeasuredPower:nil];
    
    self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil options:nil];
    [self.peripheralManager startAdvertising:beaconPeripheralData];
}



#pragma mark - Peripheral Delegate

-(void) peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    NSLog(@"Peripheral Manager Did Update");
}

@end
