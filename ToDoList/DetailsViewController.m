//
//  DetailsViewController.m
//  ToDoList
//
//  Created by Luis alberto Torres on 17/03/15.
//  Copyright (c) 2015 Luis Torres. All rights reserved.
//

#import "DetailsViewController.h"
#import "AppDelegate.h"
#import <CoreData/CoreData.h>
#import <CoreData/CoreData.h>

@interface DetailsViewController ()

@end

@implementation DetailsViewController

@synthesize imageView;
@synthesize statusSwitch;
@synthesize titleTxtFld;
@synthesize descriptionTxtFld;
@synthesize detailsTable;
@synthesize managedObject;
@synthesize fetchedResultsController;

/*
 *
 *Loads basic UI info
 *
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.detailsTable setDelegate:self];
    [self.detailsTable setDataSource:self];
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(125, 40, 100, 100)];
    self.statusSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(280, 5, 100, 100)];
    self.titleTxtFld = [[UITextField alloc]initWithFrame:CGRectMake(20, 5, 300, 35)];
    self.descriptionTxtFld = [[UITextField alloc]initWithFrame:CGRectMake(20, 5, 300, 35)];
    self.mailComposer.mailComposeDelegate = self;
    
    
    [self.titleTxtFld setDelegate:self];
    [self.descriptionTxtFld setDelegate:self];
    
    if (self.managedObject != nil) {
        NSNumber *status = [self.managedObject valueForKey:@"status"];
       
        if( [status isEqualToNumber: [NSNumber numberWithInt:1]]){
            [self.statusSwitch setOn:YES];
        }
        self.titleTxtFld.text = [self.managedObject valueForKey:@"title"];
        self.descriptionTxtFld.text = [self.managedObject valueForKey:@"tDescription"];
        self.imageView.image = [UIImage imageWithData:[self.managedObject valueForKey:@"image"]];
    }else{
        self.imageView.image = [UIImage imageNamed:@"cameraIcon"];
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
}

-(void)dismissKeyboard {
    [self.titleTxtFld resignFirstResponder];
    [self.descriptionTxtFld resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)selectImage:(UIButton *)sender {
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:imagePicker animated:YES completion:NULL];
    
}

/*
 *Adds image to view
 *
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *image = info[UIImagePickerControllerEditedImage];
    self.imageView.image = image;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return NO;
}

/*
 *Saves and edit a toDo register
 *
 */
-(IBAction)addItem:(id)sender{
    
    AppDelegate *appDelegate =
    [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context =
    [appDelegate managedObjectContext];
    NSData *imageData = UIImageJPEGRepresentation(self.imageView.image, 1.0);
    
    int isCompleted = 0;

    if([self.statusSwitch isOn] == YES){
        isCompleted = 1;
    }
    
    NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
    [dateformate setDateFormat:@"dd/MM/YYYY"];
    NSString *dateString=[dateformate stringFromDate:[NSDate date]];
    
    if(self.managedObject != nil){
        
        [self.managedObject setValue: self.titleTxtFld.text forKey:@"title"];
        [self.managedObject setValue: self.descriptionTxtFld.text forKey:@"tDescription"];
        [self.managedObject setValue: [NSNumber numberWithBool:isCompleted] forKey:@"status"];
        [self.managedObject setValue: imageData forKey:@"image"];
        [self.managedObject setValue: dateString forKey:@"date"];
        
    }else{
        
        NSManagedObject *newContact;
        newContact = [NSEntityDescription
                      insertNewObjectForEntityForName:@"ToDo"
                      inManagedObjectContext:context];
        
        
        [newContact setValue: self.titleTxtFld.text forKey:@"title"];
        [newContact setValue: self.descriptionTxtFld.text forKey:@"tDescription"];
        [newContact setValue: [NSNumber numberWithBool:isCompleted] forKey:@"status"];
        [newContact setValue: imageData forKey:@"image"];
        [newContact setValue: dateString forKey:@"date"];
    }
    
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Error saving data %@, %@", error, [error userInfo]);
        exit(-1);
    }

    [appDelegate saveContext];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 4;
}

// This will tell your UITableView how many rows you wish to have in each section.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if(indexPath.section == 0){
        cell = [tableView dequeueReusableCellWithIdentifier:@"Title"];
        [cell addSubview:self.titleTxtFld];
    }else if(indexPath.section == 1){
        cell = [tableView dequeueReusableCellWithIdentifier:@"Description"];
        [cell addSubview:self.descriptionTxtFld];
    }else if(indexPath.section == 2){
        cell = [tableView dequeueReusableCellWithIdentifier:@"Status"];
        [cell addSubview:self.statusSwitch];
    }else if(indexPath.section == 3){
        cell = [tableView dequeueReusableCellWithIdentifier:@"Imagen"];
        [cell addSubview:self.imageView];
    }
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] init];
    }
    
    return cell;
}
 


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 3){
        return 180;
    }
    
    return 44;
    
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    switch (section){
        case 0:
            return @"Titulo";
            break;
            
        case 1:
            return @"Descripcion";
            break;
        
        case 2:
            return @"Status";
            break;
            
        case 3:
            return @"Imagen";
            break;
            
        default:
            break;
            
    }
    
    return @"";
}

/*
 *Shares a MyToDo by e-mail
 *
 */
-(void)sendMail:(id)sender{
    NSMutableString *body = [NSMutableString string];
    // add HTML before the link here with line breaks (\n)
    [body appendString: self.titleTxtFld.text];
    [body appendString:@"\n"];
    [body appendString: self.descriptionTxtFld.text];
    [body appendString:@"\n"];
    [body appendString:@"TEST"];
    
    NSData *jpegData = UIImageJPEGRepresentation(self.imageView.image, 1);
    
    NSString *fileName = @"test";
    fileName = [fileName stringByAppendingPathExtension:@"jpeg"];
    [self.mailComposer addAttachmentData:jpegData mimeType:@"image/jpeg" fileName:fileName];
    
    self.mailComposer = [[MFMailComposeViewController alloc]init];
    self.mailComposer.mailComposeDelegate = self;
    [self.mailComposer setSubject:@"My ToDo"];
    [self.mailComposer setMessageBody:body isHTML:YES];
    [self presentViewController:self.mailComposer animated:YES completion:nil];
    
}


-(void)mailComposeController:(MFMailComposeViewController *)controller
             didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    if (result) {
        NSLog(@"Result : %d",result);
    }
                 
    if (error) {
        NSLog(@"Error : %@",error);
    }
                 
    [self dismissViewControllerAnimated:YES completion:nil];
                 
}



@end
