//
//  AFViewController.m
//  AdFence
//
//  Created by Michael Scaria on 1/4/14.
//  Copyright (c) 2014 MichaelScaria. All rights reserved.
//

#import <FYX/FYX.h>
#import <FYX/FYXSightingManager.h>
#import <FYX/FYXTransmitter.h>
#import <FYX/FYXVisit.h>

#import "AFViewController.h"

#import "AFModel.h"

@interface AFViewController ()

@end

@implementation AFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	values = [[NSMutableArray alloc] initWithCapacity:1000];
    mood = @"Calm";
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
    [FYX startService:self];
    self.sightingManager = [FYXSightingManager new];
    self.sightingManager.delegate = self;
    [self.sightingManager scan];
    
    feedClient = [[FeedsClient alloc] init];
    [feedClient setFeed_key:@"737999a1ef4a4cd0d87aefc5ead14b01"];
}

- (void)displayTransmitterAd:(NSString *)name {
    if ([name isEqualToString:@"Starbucks"] && [mood isEqualToString:@"Calm"]) {
        mood = @"Excited";
        [feedClient listWithParameters:nil success:^(id object) {
            
            NSArray *response = [object objectForKey:@"feeds"];
            feedList = (NSDictionary *)response[0]; //get the first feed
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
            if (feedList) {
                for (NSDictionary *dict in feedList[@"streams"]) {
                    if ([dict[@"name"] isEqualToString:@"starbucks"]) {
                        imageView.image = [UIImage imageNamed:@"starbucks.png"];
                        UIImage *image =[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:dict[@"value"]]]];
                        imageView.image = image;
                    }
                }
            }
            else
                imageView.image = [UIImage imageNamed:@"starbucks.png"];
            [self.view addSubview:imageView];
            [UIView animateWithDuration:.25 animations:^{
                imageView.frame = self.view.bounds;
            }completion:^(BOOL isCompleted){
                //TODO: Make delay longer around 30
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                    UITapGestureRecognizer *recogizer= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped)];
                    recogizer.delegate = self;
                    imageView.userInteractionEnabled = YES;
                    [imageView addGestureRecognizer:recogizer];
                });
                
            }];
            
        } failure:^(NSError *error, NSDictionary *message) {
            NSLog(@"Error: %@",[error description]);
            NSLog(@"Message: %@",message);
        }];
        
        
    }
    else if ([name isEqualToString:@"Starbucks"] && [mood isEqualToString:@"Excited"]) {
        mood = @"Excited";
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
        if (feedList) {
            for (NSDictionary *dict in feedList[@"streams"]) {
                if ([dict[@"name"] isEqualToString:@"caesars"]) {
                    NSLog(@"%@", dict[@"value"]);
                    imageView.image = [UIImage imageNamed:@"caesars.png"];
                    UIImage *image =[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:dict[@"value"]]]];
                    imageView.image = image;
                }
            }
        }
        else
            imageView.image = [UIImage imageNamed:@"caesars.png"];
        [self.view addSubview:imageView];
        [UIView animateWithDuration:.25 animations:^{
            imageView.frame = self.view.bounds;
        }completion:^(BOOL isCompleted){
        }];
    }
}

- (void)tapped {
    [FYX startService:self];
}
#pragma mark TGAccessoryDelegate

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



#pragma mark FYXServiceDelegate


- (void)serviceStarted
{
    // this will be invoked if the service has successfully started
    // bluetooth scanning will be started at this point.
    NSLog(@"FYX Service Successfully Started");
}


- (void)startServiceFailed:(NSError *)error
{
    // this will be called if the service has failed to start
    NSLog(@"FYX Error:%@", error);
}

- (void)sessionEnded
{
    NSLog(@"FYX End");
    // this will be invoked if the session has successfully ended and the user is deauthorized
}

- (void)sessionEndFailed:(NSError *)error
{
    NSLog(@"FYX Failed");
    // this will be called if the session has failed to end
}

#pragma mark FYXSightingDelegate

- (void)didReceiveSighting:(FYXTransmitter *)transmitter time:(NSDate *)time RSSI:(NSNumber *)RSSI
{
    // this will be invoked when an authorized transmitter is sighted
    NSLog(@"I received a FYX sighting!!! %@ - %@", transmitter.name, RSSI);
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"FYX" message:@"sighting" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//    [alert show];
    [self displayTransmitterAd:transmitter.name];
    [FYX stopService];
}

@end
