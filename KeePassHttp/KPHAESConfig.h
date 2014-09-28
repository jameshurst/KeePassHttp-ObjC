//
//  KPHAESConfig.h
//  KeePassHttp-ObjC
//
//  Created by James Hurst on 2014-09-22.
//  Copyright (c) 2014 James Hurst. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KPHAESConfig : NSObject

@property (nonatomic, strong) NSData *key;
@property (nonatomic, strong) NSData *IV;

+ (instancetype)aesWithKey:(NSString *)key base64key:(BOOL)base64key;
+ (instancetype)aesWithKey:(NSString *)key base64key:(BOOL)base64key IV:(NSString *)IV base64IV:(BOOL)base64IV;
- (void)generateIV;

@end