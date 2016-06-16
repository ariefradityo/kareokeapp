//
//  MainTableController.h
//  kareokeapp
//
//  Created by Bukalapak on 6/16/16.
//  Copyright © 2016 Bukalapak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SongMeta.h"

static const NSString *ID_CELL_SONG = @"idCellSong";
static const NSString *ID_SEGUE_SONG_DETAIL = @"idSegueSongDetail";

@interface MainTableController : UITableViewController{
    
    NSMutableArray<SongMeta *> *songList;
    __weak IBOutlet UIBarButtonItem *mButtonAddSong;

}

- (IBAction)addButtonClicked:(id)sender;


@end
