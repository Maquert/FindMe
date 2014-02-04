//
//  MHJMainVC.m
//  FindMe
//
//  Created by Miguel Hernández Jaso on 28/01/14.
//  Copyright (c) 2014 mhj. All rights reserved.
//

#import "MHJMainVC.h"

@interface MHJMainVC ()

@end

@implementation MHJMainVC


static NSString *const CopSegue = @"CopSegue";
static NSString *const RobberSegue = @"RobberSegue";


#pragma mark - Navigation

-(void) prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender
{
    if ([segue.identifier isEqualToString:CopSegue]) {
        
    }
    if ([segue.identifier isEqualToString:RobberSegue]) {
        
    }
}

@end
