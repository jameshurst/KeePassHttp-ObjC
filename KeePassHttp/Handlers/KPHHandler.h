//
//  KPHHandler.h
//  KeePassHttp-ObjC
//
//  Created by James Hurst on 2014-09-22.
//  Copyright (c) 2014 James Hurst. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KPHRequest.h"
#import "KPHResponse.h"
#import "KPHAESConfig.h"
#import "KPHServer.h"
#import "KPHUtils.h"

@interface KPHHandler : NSObject

- (NSString *)delegateLabelForKey:(NSString *)key;
- (NSString *)delegateKeyForLabel:(NSString *)label;
- (NSArray *)delegateEntriesForURL:(NSString *)url;
- (NSArray *)delegateAllEntries;
- (void)delegateSetUsername:(NSString *)username andPassword:(NSString *)password forURL:(NSString *)url withUUID:(NSString *)uuid;
- (NSString *)delegateGeneratePassword;

- (BOOL)testRequestVerifier:(KPHRequest *)request withAES:(KPHAESConfig *)aes;
- (void)setResponseVerifier:(KPHResponse *)response;
- (BOOL)verifyRequest:(KPHRequest *)request;
- (BOOL)verifyRequest:(KPHRequest *)request withKey:(NSString *)key;

- (NSArray *)entriesForURL:(NSURL *)url;
- (NSArray *)copyEntries:(NSArray *)entries;

- (void)handle:(KPHRequest *)request response:(KPHResponse *)response server:(KPHServer *)server;

@end
