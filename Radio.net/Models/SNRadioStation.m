//
//  SNRadioStation.m
//  Radio.net
//
//  Created by Noda Shimpei on 2013/05/12.
//  Copyright (c) 2013年 Noda Shimpei. All rights reserved.
//

#import "SNRadioStation.h"

@interface  SNRadioStation () {
    NSString *_name;
    NSString *_descript;
    NSURL *_URL;
}

@end

@implementation SNRadioStation

@synthesize name = _name, descript = _descript, URL = _URL;

- (id)initWithName:(NSString *)name Descript:(NSString *)descript URL:(NSURL *)URL
{
    self = [super init];
    if (self) {
        _name = name;
        _descript = descript;
        _URL = URL;
    }
    return self;
}

@end
