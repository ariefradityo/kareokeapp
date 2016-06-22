//
//  TFDateDelegate.m
//  kareokeapp
//
//  Created by Bukalapak on 6/22/16.
//  Copyright © 2016 Bukalapak. All rights reserved.
//

#import "TFDateDelegate.h"

@implementation TFDateDelegate


- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField;{
    NSLog(@"Begin Date Edit");
    [controller dateEdit];
    return YES;
}

- (instancetype) initWithController:(SongEditController *)ctrl;{
    self = [super init];
    controller = ctrl;
    return self;
}

@end
