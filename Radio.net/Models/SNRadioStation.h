//
//  SNRadioStation.h
//  Radio.net
//
//  Created by Noda Shimpei on 2013/05/12.
//  Copyright (c) 2013年 Noda Shimpei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SNRadioStation : NSObject

- (id)initWithName:(NSString *)name Descript:(NSString *)descript URL:(NSURL *)URL;

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSString *descript;
@property (nonatomic, readonly) NSURL *URL;


@end
