//
//  SongEditController.h
//  kareokeapp
//
//  Created by Bukalapak on 6/16/16.
//  Copyright © 2016 Bukalapak. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import "TextFieldValidator.h"
#import "Song.h"

@interface SongEditController : UIViewController <UITextViewDelegate, AVAudioRecorderDelegate, AVAudioPlayerDelegate, UITextFieldDelegate>{

}

@property (weak, nonatomic) IBOutlet UIScrollView *mSVscrollView;

@property (weak, nonatomic) IBOutlet TextFieldValidator *mTFsongTitle;

@property (weak, nonatomic) IBOutlet UILabel *mLabelTimer;

@property (weak, nonatomic) IBOutlet UITextField *mTFdate;

@property (weak, nonatomic) IBOutlet UIButton *mButtonRecord;

@property (weak, nonatomic) IBOutlet UIButton *mButtonPlay;

@property (weak, nonatomic) IBOutlet UITextView *mTVlyric;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mTVlyricHeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mTVlyricBotMarginConst;


@property (strong, nonatomic) Song *song;

@property BOOL isEdit;


- (IBAction)onRecordClicked:(id)sender;

- (IBAction)onPlayClicked:(id)sender;

- (IBAction)onSaveClicked:(id)sender;

- (void)dateEdit;



@end
