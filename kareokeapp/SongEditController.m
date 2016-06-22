//
//  SongEditController.m
//  kareokeapp
//
//  Created by Bukalapak on 6/16/16.
//  Copyright © 2016 Bukalapak. All rights reserved.
//

#import "SongEditController.h"
#import "kareokeapp-Swift.h"
#import "IQUIView+Hierarchy.h"


@interface SongEditController () {
    
    NSDate *dateSelected;
    NSDateFormatter *dateFormatter;
    
    CGFloat defaultTVHeight;
    
    BOOL isRecording;
    BOOL isPlaying;
    
    NSTimer *timer;
    NSDate *startTime;
    NSTimeInterval elapsedTime;
    
    AVAudioRecorder *audioRecorder;
    AVAudioPlayer *audioPlayer;
    
    NSFileManager *fileManager;
    NSURL *tempUrl;
    NSURL *existingUrl;
    
    
    
}

- (BOOL)isFormValid;

- (void) setupAV;

- (void) updateTimeDisplay;

- (NSString *) getUUID;
@end

@implementation SongEditController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mTVlyric.delegate = self;
    self.mTFdate.delegate = self;
    
    [self.mTFsongTitle becomeFirstResponder];
    self.mTFdate.inputAccessoryView = [UIView new];
    
    isRecording = NO;
    isPlaying = NO;
    
    dateSelected = [NSDate date];
    dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    
    fileManager = [NSFileManager defaultManager];
    NSArray *tempPathComp = [NSArray arrayWithObjects:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject], @"temp.m4a", nil];
    tempUrl = [NSURL fileURLWithPathComponents:tempPathComp];
    
    self.mTFdate.text = [dateFormatter stringFromDate:dateSelected];
    
    if(self.isEdit){
        [self setTitle:@"Edit Song"];
        self.mTFsongTitle.text = self.song.title;
        self.mTFdate.text = [dateFormatter stringFromDate:self.song.date_created];
        self.mTVlyric.text = self.song.lyric;
        dateSelected = self.song.date_created;
        elapsedTime = [self.song.time_duration doubleValue];
        
        self.mLabelTimer.text = [self intervalToString:elapsedTime];
        
        tempPathComp = [NSArray arrayWithObjects:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject], [NSString stringWithFormat:@"%@.m4a", self.song.iid], nil];
        existingUrl= [NSURL fileURLWithPathComponents:tempPathComp];
        
        if([self.song.time_duration doubleValue] == 0){
            [self.mButtonPlay setEnabled:NO];
        }
    }else{
        [self setTitle:@"New Song"];
        [self.mButtonPlay setEnabled:NO];
    }
    
    //To make the border look very close to a UITextField
    [self.mTVlyric.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    [self.mTVlyric.layer setBorderWidth:2.0];
    
    //The rounded corner part, where you specify your view's corner radius:
    self.mTVlyric.layer.cornerRadius = 5;
    self.mTVlyric.clipsToBounds = YES;
    
}

- (void)setupAV;{
    
    //setup audio file
    NSURL *outputFileUrl;
    if(!self.isEdit){
        outputFileUrl = tempUrl;
    } else{
        outputFileUrl = existingUrl;
    }
    
    
    //setup audio session
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    //define recorder setting
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
    
    //Initiate and prepare the recorder
    audioRecorder = [[AVAudioRecorder alloc] initWithURL:outputFileUrl settings:recordSetting error:NULL];
    audioRecorder.delegate = self;
    audioRecorder.meteringEnabled = YES;
    [audioRecorder prepareToRecord];
    
}

- (void)viewDidAppear:(BOOL)animated;{
    [self.mTFsongTitle addRegx:@".+" withMsg:@"Song title required"];
    
    CGSize sizeThatShouldFitTheContent = [self.mTVlyric sizeThatFits:self.mTVlyric.frame.size];
    defaultTVHeight = sizeThatShouldFitTheContent.height * 4;
    self.mTVlyricHeightConstraint.constant = defaultTVHeight;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void) dateEdit{
    NSLog(@"Date edit");
    DatePickerDialog *datePicker = [DatePickerDialog new];
    [datePicker show:@"Pick A Date" doneButtonTitle:@"Done" cancelButtonTitle:@"Cancel" defaultDate: dateSelected datePickerMode:UIDatePickerModeDate callback:^(NSDate *date){
        
        dateSelected = date;
        self.mTFdate.text = [dateFormatter stringFromDate:dateSelected];
    }];
}

- (BOOL)isFormValid;{
    return [self.mTFsongTitle validate];
}

- (IBAction)onRecordClicked:(id)sender {
    NSLog(@"Record Clicked");
    if(isRecording){
        [self.mButtonRecord setImage:[UIImage imageNamed:@"ic_record.png"]forState:UIControlStateNormal];
        [self.mButtonPlay setEnabled:YES];
        isRecording = NO;
        
        [audioRecorder stop];
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setActive:NO error:nil];
        
        NSDate *now = [NSDate date];
        elapsedTime = [now timeIntervalSinceDate:startTime];
        
        [timer invalidate];
        timer = nil;
    }
    else{
        
        if(!audioRecorder){
            [self setupAV];
        }
        
        [self.mButtonRecord setImage:[UIImage imageNamed:@"ic_stop.png"]forState:UIControlStateNormal];
        [self.mButtonPlay setEnabled:NO];
        isRecording = YES;
        
        [audioRecorder record];
        
        self.mLabelTimer.text = @"00:00:00";
        startTime = [NSDate date];
        timer = [NSTimer scheduledTimerWithTimeInterval:1 target: self
                                               selector: @selector(updateTimeDisplay) userInfo: nil repeats: YES];
    }
}

- (IBAction)onPlayClicked:(id)sender {
    NSLog(@"Play Clicked");
    [self.mButtonRecord setEnabled:NO];
    if(isPlaying){
        [self.mButtonPlay setImage:[UIImage imageNamed:@"ic_play.png"]forState:UIControlStateNormal];
        [audioPlayer stop];
        isPlaying = NO;
        [self.mButtonRecord setEnabled:YES];
        [timer invalidate];
    }
    else{
        self.mLabelTimer.text = @"00:00:00";
        
        isPlaying = YES;
        [self.mButtonPlay setImage:[UIImage imageNamed:@"ic_stop.png"]forState:UIControlStateNormal];
        if(self.isEdit){
            audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:existingUrl error:nil];
        }else{
            audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:tempUrl error:nil];
        }
        
        [audioPlayer setDelegate:self];
        [audioPlayer play];
        
        startTime = [NSDate date];
        timer = [NSTimer scheduledTimerWithTimeInterval:1 target: self
                                               selector: @selector(updateTimeDisplay) userInfo: nil repeats: YES];
    }
}
- (IBAction)onSaveClicked:(id)sender {
    if([self isFormValid] && !isPlaying && !isRecording){
        //TODO: Save data
        if(!self.isEdit){
            
            [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
                Song *newSong = [Song MR_createEntityInContext:localContext];
                
                newSong.iid = [self getUUID];
                newSong.title = self.mTFsongTitle.text;
                newSong.date_created = dateSelected;
                newSong.lyric = self.mTVlyric.text;
                newSong.time_duration = [NSNumber numberWithDouble:elapsedTime];
                
                
                if( elapsedTime > 0.0){
                    NSLog(@"Audio copied");
                    NSArray *pathComponents = [NSArray arrayWithObjects:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject], [NSString stringWithFormat:@"%@.m4a", newSong.iid], nil];
                    NSURL *outputFileUrl= [NSURL fileURLWithPathComponents:pathComponents];
                    
                    [fileManager copyItemAtURL:tempUrl toURL:outputFileUrl error:nil];
                }
                
            } completion:^(BOOL contextDidSave, NSError *error) {
                if(contextDidSave){
                    NSLog(@"New song saved");
                    [self.navigationController popViewControllerAnimated:YES];
                } else{
                    NSLog(@"Error saving context: %@", error.description);
                }
            }];
        }else{
            
            self.song.title = self.mTFsongTitle.text;
            self.song.date_created = dateSelected;
            self.song.lyric = self.mTVlyric.text;
            self.song.time_duration = [NSNumber numberWithDouble:elapsedTime];
            
            [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
                
                Song *localSong = [self.song MR_inContext:localContext];
                
                localSong.title = [NSString stringWithString: self.mTFsongTitle.text];
                localSong.date_created = dateSelected;
                localSong.lyric = self.mTVlyric.text;
                localSong.time_duration = [NSNumber numberWithDouble:elapsedTime];
                
            } completion:^(BOOL contextDidSave, NSError *error) {
                if(contextDidSave || error == nil){
                    NSLog(@"Edited song saved");
                    [self.navigationController popViewControllerAnimated:YES];
                } else{
                    NSLog(@"Error saving context: %@", error.debugDescription);
                }
            }];
        }
    }
}

- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField;{
    if([textField isEqual:_mTFdate] ){
        if( textField.isAskingCanBecomeFirstResponder == NO){
            [self dateEdit];
        }
        return NO;
    }
    
    return YES;
}

- (void) textViewDidChange:(UITextView *)textView;{
    
    CGSize sizeThatShouldFitTheContent = [textView sizeThatFits:textView.frame.size];
    if(sizeThatShouldFitTheContent.height > defaultTVHeight ){
        self.mTVlyricHeightConstraint.constant = sizeThatShouldFitTheContent.height;
    }
    else if(textView.frame.size.height > sizeThatShouldFitTheContent.height){
        self.mTVlyricHeightConstraint.constant = defaultTVHeight;
    }
    
    
}


- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag;{
    NSLog(@"Audio finished Playing");
    [self.mButtonRecord setEnabled:YES];
    [self.mButtonPlay setImage:[UIImage imageNamed:@"ic_play.png"]forState:UIControlStateNormal];
    isPlaying = NO;
    [timer invalidate];
}

- (void) updateTimeDisplay{
    
    NSDate *now = [NSDate date];
    
    NSTimeInterval interval = [now timeIntervalSinceDate:startTime];
    
    self.mLabelTimer.text = [self intervalToString:interval];
    now = nil;
}

- (NSString *)getUUID
{
    CFUUIDRef newUniqueId = CFUUIDCreate(kCFAllocatorDefault);
    NSString * uuidString = (__bridge_transfer NSString*)CFUUIDCreateString(kCFAllocatorDefault, newUniqueId);
    CFRelease(newUniqueId);
    
    return uuidString;
}

-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        [audioPlayer stop];
        [audioRecorder stop];
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setActive:NO error:nil];
        [timer invalidate];
    }
    [super viewWillDisappear:animated];
}

- (NSString *) intervalToString:(NSTimeInterval)interval;{
    NSInteger ti = (NSInteger)interval;
    NSInteger seconds = ti % 60;
    NSInteger minutes = (ti / 60) % 60;
    NSInteger hours = (ti / 3600);
    
    return [NSString stringWithFormat:@"%02ld:%02ld:%02ld", (long)hours, (long)minutes, (long)seconds];
}

@end
