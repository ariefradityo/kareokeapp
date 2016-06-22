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
#import "SongEditController.h"

@interface MainTableController (){
    
    int sortType;
}

@end

@implementation MainTableController


- (void)viewDidLoad {
    [super viewDidLoad];
    sortType = 0;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSFetchedResultsController *) fetchedResultsController{
    if(_fetchedResultsController == nil){
        NSFetchRequest *fetchRequest = [Song MR_requestAllSortedBy:@"title" ascending:YES];
        [fetchRequest setFetchBatchSize:10];
        NSFetchedResultsController *fetched = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[NSManagedObjectContext MR_defaultContext] sectionNameKeyPath:nil cacheName:nil];
        _fetchedResultsController = fetched;
        _fetchedResultsController.delegate = self;
    }
    
    
    return _fetchedResultsController;
}

-(NSFetchedResultsController *) fetchedResultsControllerWithSort{
        NSFetchRequest *fetchRequest;
        switch (sortType) {
            case 0:
                fetchRequest = [Song MR_requestAllSortedBy:@"title" ascending:YES];
                break;
            case 1:
                fetchRequest = [Song MR_requestAllSortedBy:@"title" ascending:NO];
                break;
            case 2:
                fetchRequest = [Song MR_requestAllSortedBy:@"date_created" ascending:NO];
                break;
            case 3:
                fetchRequest = [Song MR_requestAllSortedBy:@"date_created" ascending:YES];
                break;
            default:
                return nil;
                break;
        }
        [fetchRequest setFetchBatchSize:10];
        NSFetchedResultsController *fetched = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[NSManagedObjectContext MR_defaultContext] sectionNameKeyPath:nil cacheName:nil];
        _fetchedResultsController = fetched;
    _fetchedResultsController.delegate = self;
    
        return fetched;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.fetchedResultsController.fetchedObjects count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SongMetaCell *cell = [tableView dequeueReusableCellWithIdentifier:@"idCellSong" forIndexPath:indexPath];
    [cell configureForSong:[self.fetchedResultsController objectAtIndexPath:indexPath]];
    
    return cell;
}


- (void) viewDidAppear:(BOOL)animated;{
    [self.fetchedResultsController performFetch:nil];
    [self.tableView reloadData];
    
}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
            Song *localSong = [[self.fetchedResultsController objectAtIndexPath:indexPath] MR_inContext:localContext];
            [localSong MR_deleteEntityInContext:localContext];
            
            NSArray *pathComponents = [NSArray arrayWithObjects:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject], [NSString stringWithFormat:@"%@.m4a", localSong.iid], nil];
            NSURL *audioUrl= [NSURL fileURLWithPathComponents:pathComponents];
            
            NSFileManager *manager = [NSFileManager defaultManager];
            
            [manager removeItemAtURL:audioUrl error:nil];
            
        } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
            if(contextDidSave){
                NSLog(@"Delete success");
            }else{
                NSLog(@"Delete failed: %@", error.debugDescription);
            }
        }];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}


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

- (void) controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath;{
    if(type == NSFetchedResultsChangeDelete){
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}


#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    if([[segue identifier] isEqualToString:ID_SEGUE_SONG_DETAIL]){
        NSLog(@"Song Detail");
        SongDetailController *songDetail = [segue destinationViewController];
        songDetail.song = [self.fetchedResultsController objectAtIndexPath:[self.tableView indexPathForSelectedRow]];
    }else if([[segue identifier] isEqualToString:ID_SEGUE_ADD_SONG]){
        NSLog(@"Add Song");
        SongEditController *songEdit = [segue destinationViewController];
        songEdit.isEdit = NO;
    }
}

- (IBAction)onSortClicked:(id)sender {
    
    UIAlertController *sortAlertCtrl = [UIAlertController alertControllerWithTitle:@"Sort by" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *titleAsc = [UIAlertAction actionWithTitle:@"Title A-Z" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self setSortType:0];
        [self.fetchedResultsController performFetch:nil];
        [self.tableView reloadData];
    }];
    
    UIAlertAction *titleDesc = [UIAlertAction actionWithTitle:@"Title Z-A" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self setSortType:1];
        [self.fetchedResultsController performFetch:nil];
        [self.tableView reloadData];
        
    }];
    
    UIAlertAction *timeLatest = [UIAlertAction actionWithTitle:@"Latest" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self setSortType:2];
        [self.fetchedResultsController performFetch:nil];
        [self.tableView reloadData];
        
    }];
    
    UIAlertAction *timeOldest = [UIAlertAction actionWithTitle:@"Oldest" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self setSortType:3];
        [self.fetchedResultsController performFetch:nil];
        [self.tableView reloadData];
        
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [sortAlertCtrl dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [sortAlertCtrl addAction:titleAsc];
    [sortAlertCtrl addAction:titleDesc];
    [sortAlertCtrl addAction:timeLatest];
    [sortAlertCtrl addAction:timeOldest];
    [sortAlertCtrl addAction:cancel];
    
    [self presentViewController:sortAlertCtrl animated:YES completion:nil];
}

- (void) setSortType:(int)type{
    sortType = type;
    [self fetchedResultsControllerWithSort];
}

@end
