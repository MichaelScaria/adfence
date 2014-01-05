//
//  AFModel.m
//  AdFence
//
//  Created by Michael Scaria on 1/4/14.
//  Copyright (c) 2014 MichaelScaria. All rights reserved.
//

#import "AFModel.h"

#import "JSONKit.h"
#import "SocketIOPacket.h"

#define kHost @"yeezus.herokuapp.com"
#define kRootURL @"http://yeezus.herokuapp.com/"

@implementation AFModel
+ (AFModel *)sharedInstance
{
    static AFModel *sharedInstance = nil;
    static dispatch_once_t pred;
    
    dispatch_once(&pred, ^{
        sharedInstance = [[AFModel alloc] init];
    });
    
    return sharedInstance;
}

- (id)init {
    self = [super init];
    if (self) {
        socketIO = [[SocketIO alloc] initWithDelegate:self];
        [socketIO connectToHost:kHost onPort:nil withParams:nil];
    }
    return self;
}

# pragma mark socket.IO delegate methods

- (void)socketIODidConnect:(SocketIO *)socket
{
    NSLog(@"socket.io connected.");
//    if (_completion) _completion();
}

- (void) socketIO:(SocketIO *)socket didReceiveEvent:(SocketIOPacket *)packet
{
    NSLog(@"didReceiveEvent()");
    NSLog(@"didReceiveMessage() >>> data: %@", packet.data);
    SocketIOCallback cb = ^(id argsData) {
        NSDictionary *response = argsData;
        // do something with response
        NSLog(@"ack arrived: %@", response);
        
        // test forced disconnect
        //[socketIO disconnectForced];
    };
    //[socket sendEvent:@"api" toPath:@"masterApi" withMethod:@"getAll" withData:@{@"schema": @"User"} andAcknowledge:cb];
}

- (void) socketIO:(SocketIO *)socket onError:(NSError *)error
{
    NSLog(@"onError() %@", error);
}


- (void) socketIODidDisconnect:(SocketIO *)socket disconnectedWithError:(NSError *)error
{
    NSLog(@"socket.io disconnected. did error occur? %@", error);
}
@end

