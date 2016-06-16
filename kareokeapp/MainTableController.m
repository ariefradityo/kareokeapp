//
//  MainTableController.m
//  kareokeapp
//
//  Created by Bukalapak on 6/16/16.
//  Copyright © 2016 Bukalapak. All rights reserved.
//

#import "MainTableController.h"
#import "SongMetaCell.h"
#import "SongDetailController.h"

@interface MainTableController ()

- (SongMeta *)itemAtIndexPath:(NSIndexPath *)indexPath;

- (NSManagedObjectContext *) managedObjectContext;

@end

@implementation MainTableController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    songList = [NSMutableArray array];
    
    //TEMP DATA
    //[songList addObject:[[SongMeta alloc] init]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return songList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SongMetaCell *cell = [tableView dequeueReusableCellWithIdentifier:@"idCellSong" forIndexPath:indexPath];
    [cell configureForSongMeta:[self itemAtIndexPath:indexPath]];
    
    return cell;
}

- (SongMeta *)itemAtIndexPath:(NSIndexPath *)indexPath;{
    return songList[indexPath.row];
}

- (NSManagedObjectContext *) managedObjectContext;{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    
    if([delegate performSelector:@selector(managedObjectContext)]){
        context = [delegate managedObjectContext];
    }
    
    return context;
}

- (void) viewDidAppear:(BOOL)animated;{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Song"];
    
    songList = [[context executeFetchRequest:request error:nil] mutableCopy];
    
    [self.tableView reloadData];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    if([segue identifier] == ID_SEGUE_SONG_DETAIL){
        SongDetailController *songDetail = [segue destinationViewController];
        songDetail.songId = [self itemAtIndexPath:[self.tableView indexPathForSelectedRow]].iid;
    }
}

- (IBAction)addButtonClicked:(id)sender {
}
@end
