//
//  PendingViewController.h
//  ToDoList
//
//  Created by Luis alberto Torres on 16/03/15.
//  Copyright (c) 2015 Luis Torres. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface PendingViewController : UIViewController<UITableViewDelegate, UITableViewDataSource,NSFetchedResultsControllerDelegate,UISearchBarDelegate>{
    NSFetchedResultsController *fetchedResultsController;
}

@property IBOutlet UITableView* toDoTable;
@property (nonatomic) NSFetchedResultsController *fetchedResultsController;
@property IBOutlet UISearchBar* searchBar;
@property (nonatomic) NSMutableArray *filteredList;
@property (nonatomic, assign) bool isFiltered;


@end
