//
//  ViewController.h
//  ToDoList
//
//  Created by Luis alberto Torres on 15/03/15.
//  Copyright (c) 2015 Luis Torres. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>


@property IBOutlet UITableView* toDoTable;


@end

