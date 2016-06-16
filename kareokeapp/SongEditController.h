//
//  SongEditController.h
//  kareokeapp
//
//  Created by Bukalapak on 6/16/16.
//  Copyright © 2016 Bukalapak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Song.h"
#import "TextFieldValidator.h"

@interface SongEditController : UIViewController{
    
    NSDate *dateSelected;
    NSDateFormatter *dateFormatter;
    
    BOOL isEdit;
    
    Song *song;
}

@property (weak, nonatomic) IBOutlet UIScrollView *mSVscrollView;

@property (weak, nonatomic) IBOutlet TextFieldValidator *mTFsongTitle;

@property (weak, nonatomic) IBOutlet UITextField *mTFdate;

@property (weak, nonatomic) IBOutlet UIButton *mButtonRecord;

@property (weak, nonatomic) IBOutlet UITextView *mTVlyric;

@property int songId;


- (IBAction)onDateBeginEdit:(id)sender;

- (IBAction)onDateChangeEdit:(id)sender;

- (IBAction)onRecordClicked:(id)sender;

- (IBAction)onSaveClicked:(id)sender;


@end
