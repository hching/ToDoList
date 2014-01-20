//
//  ToDoListTableViewController.m
//  todo_list
//
//  Created by Henry Ching on 1/20/14.
//  Copyright (c) 2014 YahooHenry. All rights reserved.
//

#import "ToDoListTableViewController.h"
#import "ToDoListCell.h"
#import <objc/runtime.h>

@interface ToDoListTableViewController ()

@property (nonatomic, strong) NSMutableArray *toDoList;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editToDoButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *createToDoButton;

- (IBAction)onEditToDoButton:(id)sender;
- (IBAction)onCreateToDoButton:(id)sender;

- (void)saveToDoList;
- (NSMutableArray*)getToDoList;

@end

@implementation ToDoListTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.toDoList = [self getToDoList];
        if (!self.toDoList) {
            self.toDoList = [[NSMutableArray alloc] init];
            [self saveToDoList];
        }
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Methods

- (void)saveToDoList {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.toDoList forKey:@"savedToDoList"];
    [defaults synchronize];
}

- (NSMutableArray*) getToDoList {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *savedToDoList = [defaults objectForKey:@"savedToDoList"];
    return [[NSMutableArray alloc] initWithArray:savedToDoList];
}

- (IBAction)onEditToDoButton:(id)sender {
    if ([self.tableView isEditing] == YES) {
        [self.tableView setEditing:NO animated:YES];
        [self.view endEditing:YES];
        self.navigationItem.leftBarButtonItem.title = @"Edit";
        self.navigationItem.rightBarButtonItem.enabled = true;
    } else {
        [self.tableView setEditing:YES animated:YES];
        self.navigationItem.leftBarButtonItem.title = @"Done";
        self.navigationItem.rightBarButtonItem.enabled = false;
    }
}

- (IBAction)onCreateToDoButton:(id)sender {
    self.toDoList = [self getToDoList];
    [self.toDoList insertObject:[[NSString alloc] init] atIndex:0];
    [self saveToDoList];
    [self.tableView reloadData];
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    UITableViewCell *cell = [self tableView:self.tableView cellForRowAtIndexPath:path];
    ToDoListCell *toDoListCell = (ToDoListCell *) cell;
    [toDoListCell.toDoTextField becomeFirstResponder];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.toDoList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ToDoListCell";
    ToDoListCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.toDoTextField.text = [self.toDoList objectAtIndex:indexPath.row];
    objc_setAssociatedObject(cell.toDoTextField, "ToDoPath", indexPath, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.toDoList removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self saveToDoList];
        [self.tableView reloadData];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    //NSLog(@"Saving...");
    NSIndexPath *indexPath = objc_getAssociatedObject(textField, "ToDoPath");
    NSUInteger row = indexPath.row;
    [self.toDoList setObject:textField.text atIndexedSubscript:row];
    [self saveToDoList];
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    NSUInteger sourceIndex = sourceIndexPath.row;
    NSUInteger destIndex = destinationIndexPath.row;
    NSString *toDoTask = [self.toDoList objectAtIndex:sourceIndex];
    
    [self.toDoList removeObjectAtIndex:sourceIndex];
    [self.toDoList insertObject:toDoTask atIndex:destIndex];
    [self saveToDoList];
    [self.tableView reloadData];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


@end
