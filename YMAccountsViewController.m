    //
//  YMAccountsViewController.m
//  Yammer
//
//  Created by Samuel Sutch on 4/30/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "YMAccountsViewController.h"
#import "YMWebService.h"
#import "YMLoginViewController.h"

@implementation YMAccountsViewController

@synthesize web;

- (IBAction)addAccount:(UIControl *)sender
{
  [self.navigationController pushViewController:
   [[YMLoginViewController alloc] init] animated:YES];
}

- (void)loadView
{
  self.tableView = [[UITableView alloc] initWithFrame:
                    CGRectMake(0, 0, 320, 460) style:UITableViewStyleGrouped];
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  self.title = @"Accounts";
  self.navigationItem.rightBarButtonItem = 
  [[UIBarButtonItem alloc] initWithBarButtonSystemItem:
   UIBarButtonSystemItemAdd target:self action:@selector(addAccount:)];
  
  if (!web) web = [YMWebService sharedWebService];
}


- (void) viewDidAppear:(BOOL)animated
{
  if (![[self.web loggedInUsers] count]) {
    [self.navigationController pushViewController:
     [[YMLoginViewController alloc] init] animated:YES];
  } else {    
    [self.tableView reloadData];
    [self.tableView setEditing:YES animated:YES];
  }
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)table
{
  return 1;
}

- (NSInteger) tableView:(UITableView *)table 
  numberOfRowsInSection:(NSInteger)section
{
  if (![[self.web loggedInUsers] count]) return 0;
  return [YMUserAccount count];
}

- (UITableViewCell *) tableView:(UITableView *)table
          cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *ident = @"YMAccountCell1";
  UITableViewCell *cell;
  YMUserAccount *acct = [[YMUserAccount findByCriteria:
                         @"ORDER BY username, pk ASC LIMIT 1 OFFSET %i",
                          indexPath.row] objectAtIndex:0];
  
  cell = [table dequeueReusableCellWithIdentifier:ident];
  if (!cell)
    cell = [[[UITableViewCell alloc]
             initWithStyle:UITableViewCellStyleDefault
             reuseIdentifier:ident] autorelease];
  
  cell.textLabel.text = acct.username;
  
  return cell;
}

- (UITableViewCellEditingStyle) tableView:(UITableView *)table
editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return UITableViewCellEditingStyleDelete;
}

- (NSString *) tableView:(UITableView *)table
titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return @"Logout";
}

- (void) tableView:(UITableView *)table 
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
 forRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    YMUserAccount *acct = [[YMUserAccount findByCriteria:
                            @"ORDER BY username, pk ASC LIMIT 1 OFFSET %i", 
                            indexPath.row] objectAtIndex:0];
    [[YMLegacyShim sharedShim] _cleanupBeforeLoggingOutAccount:acct];
    [acct deleteObjectCascade:YES];
    [self.tableView reloadData];
    [self.tableView setEditing:YES animated:YES];
  }
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
  self.tableView = nil;
  [super viewDidUnload];
}


- (void)dealloc
{
  [super dealloc];
}


@end
