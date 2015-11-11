/*
 * Copyright (c) Microsoft. All rights reserved. Licensed under the MIT license. See full license at the bottom of this file.
 */

#import "AllUsersViewController.h"
#import "O365UnifiedEndpointOperations.h"
#import "UserCell.h"
#import "User.h"
#import "UserViewController.h"
#import "AuthenticationManager.h"

//The root view controller that displays all the users in the organization
@implementation AllUsersViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.unifiedEndpointClient = [[O365UnifiedEndpointOperations alloc] init];
    
    [self fetchAllUsers];
}

//Makes the call to fetch all users from Active Directory
- (void)fetchAllUsers
{
    [self.unifiedEndpointClient fetchAllUsersWithCompletionHandler:^(NSArray *allUsers, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!allUsers) {
                NSLog(@"Error fetching users");
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:@"Error fetching users. Check the log for errors."
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
                return;
            }
            
            self.allUsers = allUsers;
        });
    }];
}


#pragma mark - Properties
//When properties are set, reload the table cell
- (void)setAllUsers:(NSArray *)allUsers
{
    _allUsers = allUsers;
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.allUsers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserCell"
                                                     forIndexPath:indexPath];
    
    User *selectedUser = self.allUsers[indexPath.row];
    
    cell.displayNameLabel.text = selectedUser.displayName;
    cell.jobTitleLabel.text    = selectedUser.jobTitle;
    
    return cell;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"ShowUserViewController"]) {
        NSIndexPath *selectedIndexPath = [self.tableView indexPathForCell:sender];
        UserViewController *userVC = segue.destinationViewController;
        User *selectedUser = self.allUsers[selectedIndexPath.row];
        
        userVC.user = selectedUser;
    }
    
    else if ([segue.identifier isEqualToString:@"ShowUserViewControllerForCurrentUser"]) {

        UserViewController *userVC = segue.destinationViewController;
    
        //We stored the current user's ID in NSUserDefaulfts in AuthenticationManager
        User *currentLoggedInUser = [[User alloc] initWithId:[[NSUserDefaults standardUserDefaults] stringForKey:@"LogInUser"]
                                                        displayName:nil
                                                        jobTitle:nil];
        
    
        
        userVC.user = currentLoggedInUser;
    }

}

@end

// *********************************************************
//
// O365-iOS-Profile, https://github.com/OfficeDev/O365-iOS-Profile
//
// Copyright (c) Microsoft Corporation
// All rights reserved.
//
// MIT License:
// Permission is hereby granted, free of charge, to any person obtaining
// a copy of this software and associated documentation files (the
// "Software"), to deal in the Software without restriction, including
// without limitation the rights to use, copy, modify, merge, publish,
// distribute, sublicense, and/or sell copies of the Software, and to
// permit persons to whom the Software is furnished to do so, subject to
// the following conditions:
//
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
// LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
// OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
// WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//
// *********************************************************
