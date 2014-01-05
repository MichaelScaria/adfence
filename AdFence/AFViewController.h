//
//  AFViewController.h
//  AdFence
//
//  Created by Michael Scaria on 1/4/14.
//  Copyright (c) 2014 MichaelScaria. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TGAccessoryManager.h"


@interface AFViewController : UIViewController <TGAccessoryDelegate> {
    NSMutableArray *values;
}

@end
