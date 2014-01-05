//
//  AFModel.h
//  AdFence
//
//  Created by Michael Scaria on 1/4/14.
//  Copyright (c) 2014 MichaelScaria. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocketIO.h"

@interface AFModel : NSObject <SocketIODelegate> {
    SocketIO *socketIO;
    
}

+ (AFModel *)sharedInstance;
@end
