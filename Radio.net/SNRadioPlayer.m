//
//  SNRadioPlayer.m
//  Radio.net
//
//  Created by Noda Shimpei on 2013/05/19.
//  Copyright (c) 2013年 Noda Shimpei. All rights reserved.
//

#import "SNRadioPlayer.h"
#import "SNRadioStation.h"

#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <Reachability/Reachability.h>

@interface SNRadioPlayer () {
    AVPlayer *_radioPlayer;
    SNRadioStation *_station;
    Reachability *_reachability;
}

@end

@implementation SNRadioPlayer

@synthesize station = _station;

static SNRadioPlayer *_sharedPlayer = nil;

static NSString * const AVMetaDataKey = @"timedMetadata";
static NSString * const AVStatusKey = @"status";

static NSString * const AVMetaDataKeyTitle = @"title";

+ (id)sharedPlayer {
    static dispatch_once_t  onceToken;
    dispatch_once(&onceToken, ^{
        _sharedPlayer = [[SNRadioPlayer alloc] init];
    });
    return _sharedPlayer;
}

- (id)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationWithNetwork:) name:@"kNetworkReachabilityChangedNotification" object:nil];
        _reachability = [Reachability reachabilityForInternetConnection];
        [_reachability startNotifier];
    }
    return self;
}

- (id)initWithStation:(SNRadioStation *)station;
{
    self = [super init];
    if (self) {
        [self setStation:station];
    }
    return self;
}

+ (id)playerWithStation:(SNRadioStation *)station {
    return [[SNRadioPlayer alloc] initWithStation:station];
}

- (void)setStation:(SNRadioStation *)station {
    _station = station;
    AVPlayerItem* playerItem = [AVPlayerItem playerItemWithURL:[station URL]];
    [playerItem addObserver:self forKeyPath:AVMetaDataKey options:NSKeyValueObservingOptionNew context:nil];
    [playerItem addObserver:self forKeyPath:AVStatusKey options:NSKeyValueObservingOptionNew context:nil];
    [playerItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];
    [playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    [playerItem addObserver:self forKeyPath:@"tracks" options:NSKeyValueObservingOptionNew context:nil];
    _radioPlayer = [AVPlayer playerWithPlayerItem:playerItem];
}

-(void)play {
    [_radioPlayer play];
}

-(void)pause {
    [_radioPlayer pause];
}

- (void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object
                        change:(NSDictionary*)change context:(void*)context {
    
    AVPlayerItem* playerItem = object;
    if ([keyPath isEqualToString:AVMetaDataKey]) {
        for (AVMetadataItem* metadata in playerItem.timedMetadata)
            if ([[self delegate] respondsToSelector:@selector(radioStation:didDistributeMetadataKey:Value:)])
                [[self delegate] radioStation:_station didDistributeMetadataKey:[metadata key] Value:[metadata value]];
    } else if ([keyPath isEqualToString:AVStatusKey]) {
        NSLog(@"status: %d", [playerItem status]);
    } else if ([keyPath isEqualToString:@"playbackBufferEmpty"]) {
        [_radioPlayer pause];
//        dispatch_queue_t queue = dispatch_queue_create("com.noda-sin.radio.net.avplayer.play", 0);
//        dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
//        dispatch_source_set_event_handler(timer, ^{
//            NSLog(@"play action");
//            [_radioPlayer pause];
//            [_radioPlayer play];
//            if (!playerItem.playbackBufferEmpty) {
//                dispatch_source_cancel(timer);
//                dispatch_release(timer);
//                dispatch_release(queue);
//            }
//        });
//        
//        dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC);
//        uint64_t interval = NSEC_PER_SEC / 5;
//        dispatch_source_set_timer(timer, start, interval, 0);
//        dispatch_resume(timer);
//        dispatch_main();
//        
        NSLog(@"empty buffer %d", playerItem.playbackBufferEmpty);
        [_radioPlayer play];
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        NSLog(@"%@", [playerItem loadedTimeRanges]);
    } else if ([keyPath isEqualToString:@"tracks"]) {
        NSLog(@"tracks: %@", [playerItem tracks]);
    }
}

- (void)notificationWithNetwork:(id)notification {
    NetworkStatus remoteHostStatus = [_reachability currentReachabilityStatus];
    if(remoteHostStatus == NotReachable) { NSLog(@"not reachable");}
    else if (remoteHostStatus == ReachableViaWiFi) { NSLog(@"wifi"); }
    else if (remoteHostStatus == ReachableViaWWAN) { NSLog(@"carrier"); }
}


@end
