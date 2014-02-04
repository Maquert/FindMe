//
//  MHJCopRadarVC.h
//  FindMe
//
//  Created by Miguel Hernández Jaso on 28/01/14.
//  Copyright (c) 2014 mhj. All rights reserved.
//

@import UIKit;

@interface MHJCopRadarVC : UITableViewController <CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *startStopButton;

// Actions
-(IBAction)startStopSearching:(id)sender;


@end
