//
//  SNRadioCategory.h
//  Radio.net
//
//  Created by Noda Shimpei on 2013/05/12.
//  Copyright (c) 2013年 Noda Shimpei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SNRadioCategory : NSObject

- (id)initWithCid:(NSString *)cid Name:(NSString *)name;

@property (nonatomic, readonly) NSString *cid;
@property (nonatomic, readonly) NSString *name;

@end
