//
//  SongDetailController.h
//  kareokeapp
//
//  Created by Bukalapak on 6/16/16.
//  Copyright © 2016 Bukalapak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Song.h"

@interface SongDetailController : UIViewController{
    
    Song *song;
}

@property int songId;


@end
