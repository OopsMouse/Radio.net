//
//  SNRadioCategory.m
//  Radio.net
//
//  Created by Noda Shimpei on 2013/05/12.
//  Copyright (c) 2013年 Noda Shimpei. All rights reserved.
//

#import "SNRadioCategory.h"

@interface SNRadioCategory () {
    NSString *_name;
    NSString *_cid;
}

@end

@implementation SNRadioCategory

@synthesize name = _name;
@synthesize cid  = _cid;

- (id)initWithCid:(NSString *)cid Name:(NSString *)name {
    self = [super init];
    if (self) {
        _cid = cid;
        _name = name;
    }
    return self;
}

@end
