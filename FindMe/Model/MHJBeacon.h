//
//  MHJBeacon.h
//  FindMe
//
//  Created by Miguel Hernández Jaso on 28/01/14.
//  Copyright (c) 2014 mhj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MHJBeacon : NSObject

// We actually manage a class called CLBeacon, returned from a delegate which operates with CLBeaconRegion

// Beacon essentials
@property (strong, nonatomic) NSString *UUID;
@property (strong, nonatomic) NSNumber *major; // int 16
@property (strong, nonatomic) NSNumber *minor;

// Other details
@property (strong, nonatomic) NSNumber *proximity;
@property (strong, nonatomic) NSNumber *accuracy;
@property (strong, nonatomic) NSNumber *rssi;

@end
