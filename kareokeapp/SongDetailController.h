//
//  SongDetailController.h
//  kareokeapp
//
//  Created by Bukalapak on 6/16/16.
//  Copyright © 2016 Bukalapak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Song.h"
#import <AVFoundation/AVFoundation.h>

static NSString * const ID_SEGUE_EDIT_SONG = @"idSegueEditSong";

@interface SongDetailController : UIViewController <AVAudioPlayerDelegate>

@property (strong, nonatomic) Song *song;

@property (weak, nonatomic) IBOutlet UILabel *mLabelSongTitle;

@property (weak, nonatomic) IBOutlet UILabel *mLabelDateCreated;

@property (weak, nonatomic) IBOutlet UILabel *mLabelTimer;

@property (weak, nonatomic) IBOutlet UIButton *mButtonPlay;

@property (weak, nonatomic) IBOutlet UITextView *mTVlyrics;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mTVlyricsHeightConstraint;


@property (weak, nonatomic) IBOutlet UIScrollView *mSVscrollView;

- (IBAction)onPlayClicked:(id)sender;

@end
