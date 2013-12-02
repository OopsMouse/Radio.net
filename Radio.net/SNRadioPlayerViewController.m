//
//  SNRadioPlayerViewController.m
//  Radio.net
//
//  Created by Noda Shimpei on 2013/05/12.
//  Copyright (c) 2013年 Noda Shimpei. All rights reserved.
//

#import "SNRadioPlayerViewController.h"
#import "SNRadioStation.h"
#import "SNRadioPlayer.h"

#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface SNRadioPlayerViewController () <SNRadioPlayerDelegate> {
    SNRadioStation *_station;
}

@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UISlider *volumeSlider;

@end

@implementation SNRadioPlayerViewController


- (void)setRadioStation:(SNRadioStation *)station {
    _station = station;
    [[SNRadioPlayer sharedPlayer] setDelegate:self];
    [[SNRadioPlayer sharedPlayer] setStation:_station];
    [[SNRadioPlayer sharedPlayer] play];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // setup
    [[[self coverImageView] layer] setBorderColor:[[UIColor whiteColor] CGColor]];
    [[[self coverImageView] layer] setBorderWidth:10.0f];
}

- (void)dealloc {
    [[SNRadioPlayer sharedPlayer] setDelegate:nil];
}

#pragma mark - SNRadioPlayerDelegate methods

- (void)radioStation:(SNRadioStation *)station didDistributeMetadataKey:(id)key Value:(id)value {
}

@end
