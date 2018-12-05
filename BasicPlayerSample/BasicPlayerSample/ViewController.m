/*
 * ADOBE SYSTEMS INCORPORATED
 * Copyright 2015 Adobe Systems Incorporated
 * All Rights Reserved.
 
 * NOTICE:  Adobe permits you to use, modify, and distribute this file in accordance with the
 * terms of the Adobe license agreement accompanying it.  If you have received this file from a
 * source other than Adobe, then your use, modification, or distribution of it requires the prior
 * written permission of Adobe.
 */

#import <MediaPlayer/MediaPlayer.h>
#import "ViewController.h"
#import "VideoPlayer.h"
#import "VideoAnalyticsProvider.h"
#import "ADBMobile.h"
NSString *const CONTENT_URL = @"http://devimages.apple.com.edgekey.net/streaming/examples/bipbop_4x3/bipbop_4x3_variant.m3u8";
NSString *const CONTENT_URL2 = @"http://s7d2.scene7.com/is/content/mcmobile/new-building-AVS.m3u8";

@interface ViewController ()

@property(strong, nonatomic) IBOutlet UILabel *pubLabel;
@property(strong, nonatomic) VideoPlayer *videoPlayer;
@property(strong, nonatomic) VideoAnalyticsProvider *videoAnalyticsProvider;

@property(strong, nonatomic) VideoPlayer *videoPlayer2;
@property(strong, nonatomic) VideoAnalyticsProvider *videoAnalyticsProvider2;

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [ADBMobile setDebugLogging:YES];
    
    _pubLabel.hidden = YES;

    if (!self.videoPlayer)
    {
        self.videoPlayer = [[VideoPlayer alloc] init];
        (void)[self.videoPlayer initWithContentURL:[NSURL URLWithString:CONTENT_URL]];

        [[self.videoPlayer getView] setFrame:CGRectMake(0, 0, 320, 280)];
        [self.view addSubview:[self.videoPlayer getView]];
        
        
        self.pubLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 200.0, 200.0)];
        self.pubLabel.text = @"AD";
        self.pubLabel.hidden = YES;
        [self.pubLabel setTextColor:[UIColor whiteColor]];
        [self.pubLabel setFont:[UIFont fontWithDescriptor:[UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleSubheadline]
                                                     size:64.0f]];
        
        [self.view addSubview:self.pubLabel];
        [self.view bringSubviewToFront:self.pubLabel];
        
        //2
        self.videoPlayer2 = [[VideoPlayer alloc] init];
        (void)[self.videoPlayer2 initWithContentURL2:[NSURL URLWithString:CONTENT_URL2]];
        
        [[self.videoPlayer2 getView] setFrame:CGRectMake(0, 280, 320, 280)];
        [self.view addSubview:[self.videoPlayer2 getView]];
        
        [self _installNotificationHandlers];
    }
    
    // Create the VideoAnalyticsProvider instance and attach it to the VideoPlayer instance.
    if (!self.videoAnalyticsProvider) {
        // Setup video-tracking.
        self.videoAnalyticsProvider = [[VideoAnalyticsProvider alloc] initWithPlayer:self.videoPlayer];
        self.videoAnalyticsProvider2 = [[VideoAnalyticsProvider alloc] initWithPlayer:self.videoPlayer2];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    // End the life-cycle of the VideoAnalytics provider. (or full screen)
    [super viewWillDisappear:animated];
}


- (void)_installNotificationHandlers {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onAdStart:)
                                                 name:PLAYER_EVENT_AD_START
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onAdComplete:)
                                                 name:PLAYER_EVENT_AD_COMPLETE
                                               object:nil];
}

- (void)onAdStart:(NSNotification *)notification {
    _pubLabel.hidden = NO;
}

- (void)onAdComplete:(NSNotification *)notification {
    _pubLabel.hidden = YES;
}

@end
