//
//  SongEditController.m
//  kareokeapp
//
//  Created by Bukalapak on 6/16/16.
//  Copyright © 2016 Bukalapak. All rights reserved.
//

#import "SongEditController.h"
#import "kareokeapp-Swift.h"

@interface SongEditController ()

- (BOOL)isFormValid;

@end

@implementation SongEditController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dateSelected = [[NSDate alloc] init];
    dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    
    self.mTFdate.text = [dateFormatter stringFromDate:dateSelected];
    
    
    if(isEdit){
        [self setTitle:@"Edit Song"];
    }else{
        [self setTitle:@"New Song"];
    }
}

- (void)viewDidAppear:(BOOL)animated;{
    [self.mTFsongTitle addRegx:@".+" withMsg:@"Song title required"];
    
    [self.mSVscrollView setScrollEnabled:YES];
    [self.mSVscrollView setContentSize:CGSizeMake(0, 600)];
    
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

- (IBAction)onDateBeginEdit:(id)sender {
    
    [self.mTFsongTitle resignFirstResponder];
    
    DatePickerDialog *datePicker = [[DatePickerDialog alloc] init];
    [datePicker show:@"Pick A Date" doneButtonTitle:@"Done" cancelButtonTitle:@"Cancel" defaultDate: dateSelected datePickerMode:UIDatePickerModeDate callback:^(NSDate *date){
        
        dateSelected = date;
        self.mTFdate.text = [dateFormatter stringFromDate:dateSelected];
    }];

    
}

- (BOOL)isFormValid;{
    return [self.mTFsongTitle validate];
}

- (IBAction)onDateChangeEdit:(id)sender {
    [self onDateBeginEdit:sender];
}

- (IBAction)onRecordClicked:(id)sender {
    NSLog(@"Record Clicked");
}
- (IBAction)onSaveClicked:(id)sender {
    if([self isFormValid]){
        //TODO: Save data
    }
}
@end
