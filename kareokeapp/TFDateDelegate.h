//
//  TFDateDelegate.h
//  kareokeapp
//
//  Created by Bukalapak on 6/22/16.
//  Copyright © 2016 Bukalapak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SongEditController.h"

@interface TFDateDelegate : NSObject <UITextFieldDelegate>{
    SongEditController *controller;
}


- (instancetype) initWithController:(SongEditController *)ctrl;

@end
