//
//  MainTableController.h
//  kareokeapp
//
//  Created by Bukalapak on 6/16/16.
//  Copyright © 2016 Bukalapak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Song.h"

static NSString * const ID_CELL_SONG = @"idCellSong";
static NSString * const ID_SEGUE_SONG_DETAIL = @"idSegueSongDetail";
static NSString * const ID_SEGUE_ADD_SONG = @"idSegueAddSong";

@interface MainTableController : UITableViewController  <NSFetchedResultsControllerDelegate>{
    
    NSMutableArray<Song *> *songList;

}

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;


- (IBAction)onSortClicked:(id)sender;

@end
