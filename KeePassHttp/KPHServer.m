//
//  KPHServer.m
//  KeePassHttp-ObjC
//
//  Created by James Hurst on 2014-09-21.
//  Copyright (c) 2014 James Hurst. All rights reserved.
//

#import "KPHServer.h"
#import "KPHRequest.h"
#import "KPHResponse.h"

#import "GCDWebServer.h"
#import "GCDWebServerPrivate.h"
#import "GCDWebServerDataRequest.h"
#import "GCDWebServerDataResponse.h"

#import "KPHTestAssociateHandler.h"
#import "KPHAssociateHandler.h"
#import "KPHGetLoginsHandler.h"
#import "KPHGetLoginsCountHandler.h"
#import "KPHGetAllLoginsHandler.h"
#import "KPHSetLoginHandler.h"
#import "KPHGeneratePasswordHandler.h"

static const NSUInteger kKPHDefaultPort = 19455;

@interface KPHServer ()

@property (nonatomic, strong) NSDictionary *handlers;

@end

@implementation KPHServer
{
    GCDWebServer *_server;
}

#pragma mark - Initializaiton

- (instancetype)init
{
    if (self = [super init])
    {
        [GCDWebServer setLogLevel:kGCDWebServerLoggingLevel_Error];
        
        _handlers = @{
                      kKPHRequestTestAssociate: [KPHTestAssociateHandler new],
                      kKPHRequestAssociate: [KPHAssociateHandler new],
                      kKPHRequestGetLogins: [KPHGetLoginsHandler new],
                      kKPHRequestGetLoginsCount: [KPHGetLoginsCountHandler new],
                      kKPHRequestGetAllLogins: [KPHGetAllLoginsHandler new],
                      kKPHRequestSetLogin: [KPHSetLoginHandler new],
                      kKPHRequestGeneratePassword: [KPHGeneratePasswordHandler new],
                      };
        
        _server = [[GCDWebServer alloc] init];
        
        __weak typeof(self) weakSelf = self;
        [_server addDefaultHandlerForMethod:@"POST"
                               requestClass:[GCDWebServerDataRequest class]
                               processBlock:^GCDWebServerResponse *(GCDWebServerRequest *request) {
                                  
                                   NSString *clientHash = [weakSelf.delegate clientHashForServer:weakSelf];
                                   if (clientHash && [request isKindOfClass:[GCDWebServerDataRequest class]] && [request.contentType hasPrefix:@"application/json"])
                                   {
                                       GCDWebServerDataRequest *dataRequest = (GCDWebServerDataRequest *)request;
                                       
                                       NSError *error = nil;
                                       KPHRequest *kphRequest = [[KPHRequest alloc] initWithData:dataRequest.data error:&error];
                                       if (!error)
                                       {
                                           KPHResponse *kphResponse = [KPHResponse responseWithRequestType:kphRequest.RequestType hash:clientHash];
                                           
                                           KPHHandler *handler = (KPHHandler *)weakSelf.handlers[kphRequest.RequestType];
                                           if (handler)
                                               [handler handle:kphRequest response:kphResponse server:weakSelf];
                                           
                                           return [[GCDWebServerDataResponse alloc] initWithData:[[kphResponse toJSONString] dataUsingEncoding:NSUTF8StringEncoding] contentType:@"application/json"];
                                       }
                                   }
                                   
                                   GCDWebServerResponse *response = [GCDWebServerResponse new];
                                   response.statusCode = 400;
                                   return response;
                               }];
    }
    return self;
}

- (BOOL)isRunning
{
    return _server && _server.isRunning;
}

- (BOOL)start
{
    return [self startWithPort:kKPHDefaultPort];
}

- (BOOL)startWithPort:(NSUInteger)port
{
    if (self.isRunning)
        [_server stop];
    return [_server startWithPort:port bonjourName:nil];
}

- (BOOL)startSynchronously
{
    return [self startSynchronouslyWithPort:kKPHDefaultPort];
}

- (BOOL)startSynchronouslyWithPort:(NSUInteger)port
{
    if (self.isRunning)
        [_server stop];
    return [_server runWithPort:port bonjourName:nil];
}

- (void)stop
{
    if (self.isRunning)
        [_server stop];
}

@end
