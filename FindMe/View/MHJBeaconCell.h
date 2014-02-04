//
//  MHJBeaconCell.h
//  FindMe
//
//  Created by Miguel Hernández Jaso on 28/01/14.
//  Copyright (c) 2014 mhj. All rights reserved.
//

@import UIKit;

@interface MHJBeaconCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *majorLabel;
@property (weak, nonatomic) IBOutlet UILabel *minorLabel;
@property (weak, nonatomic) IBOutlet UILabel *accuaracyLabel;
@property (weak, nonatomic) IBOutlet UILabel *proximityLabel;

@end
