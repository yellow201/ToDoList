//
//  ViewController.m
//  ToDoList
//
//  Created by Luis alberto Torres on 15/03/15.
//  Copyright (c) 2015 Luis Torres. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize toDoTable;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.toDoTable.allowsMultipleSelectionDuringEditing = NO;
    [self.toDoTable setDelegate:self];
    [self.toDoTable setDataSource:self];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // typically you need know which item the user has selected.
    // this method allows you to keep track of the selection
   
    NSLog(@"Hola");
    
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return UITableViewCellEditingStyleDelete;
}

// This will tell your UITableView how many rows you wish to have in each section.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifer = @"customCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer];
    
    // Using a cell identifier will allow your app to reuse cells as they come and go from the screen.
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifer];
    }
    
    if( (indexPath.row % 2) != 0){
       // cell.backgroundColor = [UIColor lightGrayColor];
    }
    
    self.toDoTable.allowsSelection = NO;
    
    
    UILabel *titleLbl = (UILabel *)[cell viewWithTag:1];
    [titleLbl setText:@"Titulo"];
    
    UILabel *descLbl = (UILabel *)[cell viewWithTag:2];
    [descLbl setText:@"Descripcion"];
    
    UILabel *dateLbl = (UILabel *)[cell viewWithTag:3];
    [dateLbl setText:@"Fecha"];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
       return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        [self.toDoTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}


-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Set NSString for button display text here.
    NSString *newTitle = @"Eliminar";
    return newTitle;
    
}




@end
