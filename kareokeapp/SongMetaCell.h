//
//  SongCell.h
//  kareokeapp
//
//  Created by Bukalapak on 6/16/16.
//  Copyright © 2016 Bukalapak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Song.h"

@interface SongMetaCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *mLabelSongTitle;
@property (weak, nonatomic) IBOutlet UILabel *mLabelDateCreated;


-(void)configureForSong:(Song *)song;

@end
