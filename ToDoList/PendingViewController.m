//
//  PendingViewController.m
//  ToDoList
//
//  Created by Luis alberto Torres on 16/03/15.
//  Copyright (c) 2015 Luis Torres. All rights reserved.
//

#import "PendingViewController.h"
#import "AppDelegate.h"
#import <CoreData/CoreData.h>
#import "DetailsViewController.h"

@interface PendingViewController ()

@end

@implementation PendingViewController

@synthesize toDoTable;
@synthesize fetchedResultsController;
@synthesize searchBar;
@synthesize isFiltered;
@synthesize filteredList;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.toDoTable.allowsMultipleSelectionDuringEditing = NO;
    [self.toDoTable setDelegate:self];
    [self.toDoTable setDataSource:self];
    [self.searchBar setDelegate:self];
    [self requestDBInfo];
}

/*
 * Reloads table data
 */
-(void)viewWillAppear:(BOOL)animated{
    [self requestDBInfo];
    [self.toDoTable reloadData];
}

/*
 * Rquest data to sqlLite data base using core data
 *
 */
-(void)requestDBInfo{
    NSError *error = nil;
    if (![[self fetchedResultsController] performFetch:&error]) {
        NSLog(@"Error %@, %@", error, [error userInfo]);
        abort();
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (fetchedResultsController != nil) {
        return fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ToDo" inManagedObjectContext:[(AppDelegate *)[[UIApplication sharedApplication] delegate]managedObjectContext]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"status == %d", 0];
    
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setFetchBatchSize:20];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[(AppDelegate *)[[UIApplication sharedApplication] delegate]managedObjectContext] sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    return fetchedResultsController;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DetailsViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"details"];
   // [self.navigationController pushViewController:vc animated:YES];
    vc.managedObject = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    if(!self.isFiltered){
        vc.managedObject = [self.fetchedResultsController objectAtIndexPath:indexPath];
    }else{
        vc.managedObject = [self.filteredList objectAtIndex:indexPath.row];
    }
    [self presentViewController:vc animated:YES completion:nil];

}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewCellEditingStyleDelete;
}

// This will tell your UITableView how many rows you wish to have in each section.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSFetchedResultsController *ff = [self fetchedResultsController];
    
    if(self.isFiltered){
        return filteredList.count;
    }else{
        return [ff.fetchedObjects count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifer = @"customCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifer];
    }
    
    NSManagedObject *managedObject;
    
    if(isFiltered){
        managedObject = [filteredList objectAtIndex:indexPath.row];
    }else{
        managedObject = [fetchedResultsController objectAtIndexPath:indexPath];
    }

    //NSManagedObject *managedObject = [fetchedResultsController objectAtIndexPath:indexPath];
    NSString* title = [[NSString alloc] initWithString:[[managedObject valueForKey:@"title"] description]];
    NSString* description = [[NSString alloc] initWithString:[[managedObject valueForKey:@"tDescription"] description]];
    NSString* date = [[NSString alloc] initWithString:[[managedObject valueForKey:@"date"] description]];
    
    UILabel *titleLbl = (UILabel *)[cell viewWithTag:40];
    [titleLbl setText: title];
    
    UILabel *descLbl = (UILabel *)[cell viewWithTag:50];
    [descLbl setText:description];
    
    UILabel *dateLbl = (UILabel *)[cell viewWithTag:60];
    [dateLbl setText:date];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [self.toDoTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}


-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *newTitle = @"Eliminar";
    return newTitle;
    
}

/*
 * Implements a basic ´search´ logic for the table view
 *
 */
-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text
{
    if(text.length == 0)
    {
        isFiltered = FALSE;
    }
    else
    {
        isFiltered = true;
        filteredList = [[NSMutableArray alloc] init];
        
        for (NSManagedObject* object in [self.fetchedResultsController fetchedObjects] )
        {
            NSRange nameRange = [[[NSString alloc] initWithString:[[object valueForKey:@"title"] description]] rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange descriptionRange = [[[NSString alloc] initWithString:[[object valueForKey:@"tDescription"] description]] rangeOfString:text options:NSCaseInsensitiveSearch];
            if(nameRange.location != NSNotFound || descriptionRange.location != NSNotFound)
            {
                [filteredList addObject:object];
            }
        }
    }
    
    [self.toDoTable reloadData];
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)theSearchBar {
    [self.searchBar resignFirstResponder];
}

@end
