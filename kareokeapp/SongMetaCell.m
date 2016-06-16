//
//  SongCell.m
//  kareokeapp
//
//  Created by Bukalapak on 6/16/16.
//  Copyright © 2016 Bukalapak. All rights reserved.
//

#import "SongMetaCell.h"

@implementation SongMetaCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) configureForSongMeta:(SongMeta *)songMeta;{
    self.mLabelSongTitle.text = songMeta.title;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd/MM/yyyy"];
    
    self.mLabelDateCreated.text = [formatter stringFromDate:songMeta.dateCreated];
}

@end
