//
//  SongCell.h
//  kareokeapp
//
//  Created by Bukalapak on 6/16/16.
//  Copyright © 2016 Bukalapak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SongMeta.h"

@interface SongMetaCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *mLabelSongTitle;
@property (weak, nonatomic) IBOutlet UILabel *mLabelDateCreated;


-(void)configureForSongMeta:(SongMeta *)songMeta;

@end
