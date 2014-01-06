//
//  AFViewController.h
//  AdFence
//
//  Created by Michael Scaria on 1/4/14.
//  Copyright (c) 2014 MichaelScaria. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FYX/FYXSightingManager.h>

#import "TGAccessoryManager.h"
#import "FeedsClient.h"

@interface AFViewController : UIViewController <TGAccessoryDelegate, FYXServiceDelegate, FYXSightingDelegate, UIGestureRecognizerDelegate> {
    NSMutableArray *values;
    NSString *mood;
    FeedsClient *feedClient;
    NSDictionary *feedList;
    BOOL stay;
}

@property (nonatomic) FYXSightingManager *sightingManager;
@end
