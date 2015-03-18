//
//  DetailsViewController.h
//  ToDoList
//
//  Created by Luis alberto Torres on 17/03/15.
//  Copyright (c) 2015 Luis Torres. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <MessageUI/MessageUI.h>



@interface DetailsViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, MFMailComposeViewControllerDelegate>


- (IBAction)addItem:(id)sender;
- (IBAction)selectImage:(UIButton *)sender;
- (IBAction)sendMail:(id)sender;

@property UIImageView *imageView;
@property UISwitch *statusSwitch;
@property UITextField *titleTxtFld;
@property UITextField *descriptionTxtFld;
@property IBOutlet UITableView* detailsTable;
@property (nonatomic) NSManagedObject *managedObject;
@property (nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic) MFMailComposeViewController *mailComposer;


@end
