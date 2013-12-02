//
//  SNRadioPlayer.h
//  Radio.net
//
//  Created by Noda Shimpei on 2013/05/19.
//  Copyright (c) 2013年 Noda Shimpei. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SNRadioStation;

@protocol SNRadioPlayerDelegate <NSObject>

- (void)radioStation:(SNRadioStation *)station didDistributeMetadataKey:(id)key Value:(id)value;

@end

@interface SNRadioPlayer : NSObject

@property (nonatomic, strong) SNRadioStation *station;
@property (nonatomic, weak) id <SNRadioPlayerDelegate> delegate;


+ (SNRadioPlayer *)sharedPlayer;
- (id)initWithStation:(SNRadioStation *)station;
+ (id)playerWithStation:(SNRadioStation *)station;

/**
 * Starts playback. If the player is already playing, this method does nothing except wasting some cycles.
 */
-(void)play;

/**
 * Pauses the player. If the player is already paused, this method does nothing except generating some heat.
 */
-(void)pause;

@end
