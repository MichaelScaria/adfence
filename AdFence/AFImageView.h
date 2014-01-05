//
//  AFImageView.h
//  AdFence
//
//  Created by Michael Scaria on 1/5/14.
//  Copyright (c) 2014 MichaelScaria. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AFImageView : UIImageView<UIGestureRecognizerDelegate> {
    CGPoint initialPoint;
}

@end
