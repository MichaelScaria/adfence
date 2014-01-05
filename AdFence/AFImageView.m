//
//  AFImageView.m
//  AdFence
//
//  Created by Michael Scaria on 1/5/14.
//  Copyright (c) 2014 MichaelScaria. All rights reserved.
//

#import "AFImageView.h"

@implementation AFImageView

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    UIPanGestureRecognizer *swipeGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragging:)];
    swipeGesture.delegate = self;
    [self addGestureRecognizer:swipeGesture];
}

- (void)dragging:(UIPanGestureRecognizer *)recognizer {
    CGPoint newPoint = [recognizer locationInView:self];
    
    if(recognizer.state == UIGestureRecognizerStateBegan) {
        NSLog(@"Received a pan gesture");
        initialPoint = newPoint;
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled) {
    }
    else {
        int delta = newPoint.y - initialPoint.y;
        if (delta > 0 && self.frame.origin.y + delta > 320) {
            [UIView animateWithDuration:.3 animations:^{
                self.frame = CGRectMake(0, 530, self.frame.size.width, self.frame.size.height);
            }completion:^(BOOL isCompleted){
                
            }];
        }
        
    }
    initialPoint = newPoint;
}

@end
