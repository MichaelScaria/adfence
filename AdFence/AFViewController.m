//
//  AFViewController.m
//  AdFence
//
//  Created by Michael Scaria on 1/4/14.
//  Copyright (c) 2014 MichaelScaria. All rights reserved.
//

#import "AFViewController.h"

#import "AFModel.h"

@interface AFViewController ()

@end

@implementation AFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	values = [[NSMutableArray alloc] initWithCapacity:1000];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if([[TGAccessoryManager sharedTGAccessoryManager] accessory] != nil) {
        NSLog(@"Connected to MindWave");
        [[TGAccessoryManager sharedTGAccessoryManager] startStream];
    }
    else {
        ;
    }
    [AFModel sharedInstance];

}

#pragma mark -
#pragma mark TGAccessoryDelegate protocol methods

//  This method gets called by the TGAccessoryManager when a ThinkGear-enabled
//  accessory is connected.
- (void)accessoryDidConnect:(EAAccessory *)accessory {
    // toss up a UIAlertView when an accessory connects
    UIAlertView * a = [[UIAlertView alloc] initWithTitle:@"Accessory Connected"
                                                 message:[NSString stringWithFormat:@"A ThinkGear accessory called %@ was connected to this device.", [accessory name]]
                                                delegate:nil
                                       cancelButtonTitle:@"Okay"
                                       otherButtonTitles:nil];
    [a show];
    
    // start the data stream to the accessory
    [[TGAccessoryManager sharedTGAccessoryManager] startStream];
    
    // set up the current view
//    [self setLoadingScreenView];
}

//  This method gets called by the TGAccessoryManager when a ThinkGear-enabled
//  accessory is disconnected.
- (void)accessoryDidDisconnect {
    // toss up a UIAlertView when an accessory disconnects
    /*UIAlertView * a = [[UIAlertView alloc] initWithTitle:@"Accessory Disconnected"
     message:@"The ThinkGear accessory was disconnected from this device."
     delegate:nil
     cancelButtonTitle:@"Okay"
     otherButtonTitles:nil];
     [a show];
     [a release];
     */

}

//  This method gets called by the TGAccessoryManager when data is received from the
//  ThinkGear-enabled device.
- (void)dataReceived:(NSDictionary *)data {
    if (data[@"raw"]) {
        [values addObject:data[@"raw"]];
        if (values.count >= 1000) {
            [[AFModel sharedInstance] sendRawData:values];
            [values removeAllObjects];
        }
    }
    

}
@end
