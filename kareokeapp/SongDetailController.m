//
//  SongDetailController.m
//  kareokeapp
//
//  Created by Bukalapak on 6/16/16.
//  Copyright © 2016 Bukalapak. All rights reserved.
//

#import "SongDetailController.h"
#import "SongEditController.h"

@interface SongDetailController (){
    
    
    BOOL isPlaying;
    
    AVAudioPlayer *audioPlayer;
    NSURL *audioUrl;
    
    NSDate *startTime;
    NSTimer *timer;
}

@end

@implementation SongDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isPlaying = NO;
    
    NSArray *pathComponents = [NSArray arrayWithObjects:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject], [NSString stringWithFormat:@"%@.m4a", self.song.iid], nil];
    audioUrl= [NSURL fileURLWithPathComponents:pathComponents];
    [audioPlayer setDelegate:self];
}

- (void) viewDidAppear:(BOOL)animated;{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    self.mLabelSongTitle.text = self.song.title;
    self.mLabelDateCreated.text = [NSString stringWithFormat:@"Created on: %@", [dateFormatter stringFromDate:self.song.date_created]];
    self.mTVlyrics.text = self.song.lyric;
    self.mLabelTimer.text = [self intervalToString:[self.song.time_duration doubleValue]];
    
    if([self.song.time_duration doubleValue] == 0.0){
        [self.mButtonPlay setEnabled:NO];
    }else{
        [self.mButtonPlay setEnabled:YES];
    }
    
    CGSize sizeThatShouldFitTheContent = [self.mTVlyrics sizeThatFits:self.mTVlyrics.frame.size];
        self.mTVlyricsHeightConstraint.constant = sizeThatShouldFitTheContent.height;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    [self.mButtonPlay setImage:[UIImage imageNamed:@"ic_play.png"]forState:UIControlStateNormal];
    [audioPlayer stop];
    isPlaying = NO;
    
    if([segue.identifier isEqualToString:ID_SEGUE_EDIT_SONG]){
        SongEditController *songEdit = [segue destinationViewController];
        songEdit.song = self.song;
        songEdit.isEdit = YES;
    }

    
}


- (IBAction)onPlayClicked:(id)sender {
    NSLog(@"Play Clicked");
    if(isPlaying){
        [self.mButtonPlay setImage:[UIImage imageNamed:@"ic_play.png"]forState:UIControlStateNormal];
        [audioPlayer stop];
        isPlaying = NO;
        [timer invalidate];
    }
    else{
        self.mLabelTimer.text = @"00:00:00";
        
        isPlaying = YES;
        [self.mButtonPlay setImage:[UIImage imageNamed:@"ic_stop.png"]forState:UIControlStateNormal];
        audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioUrl error:nil];
        audioPlayer.delegate = self;
        [audioPlayer play];
        
        startTime = [NSDate date];
        timer = [NSTimer scheduledTimerWithTimeInterval:1 target: self
                                               selector: @selector(updateTimeDisplay) userInfo: nil repeats: YES];
    }
}

- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag;{
    NSLog(@"Audio finished Playing");
    [self.mButtonPlay setImage:[UIImage imageNamed:@"ic_play.png"]forState:UIControlStateNormal];
    isPlaying = NO;
    [timer invalidate];
}

- (void) viewWillDisappear:(BOOL)animated;{
    [audioPlayer stop];
}

- (void) updateTimeDisplay{
    
    NSDate *now = [NSDate date];
    
    NSTimeInterval interval = [now timeIntervalSinceDate:startTime];
    
    self.mLabelTimer.text = [self intervalToString:interval];
    now = nil;
}

- (NSString *) intervalToString:(NSTimeInterval)interval;{
    NSInteger ti = (NSInteger)interval;
    NSInteger seconds = ti % 60;
    NSInteger minutes = (ti / 60) % 60;
    NSInteger hours = (ti / 3600);
    
    return [NSString stringWithFormat:@"%02ld:%02ld:%02ld", (long)hours, (long)minutes, (long)seconds];
}

@end
