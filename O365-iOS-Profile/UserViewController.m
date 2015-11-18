/*
 * Copyright (c) Microsoft. All rights reserved. Licensed under the MIT license. See full license at the bottom of this file.
 */

#import "UserViewController.h"
#import "O365UnifiedEndpointOperations.h"
#import "BasicUserInfo.h"
#import "GeneralUserInfoCell.h"
#import "ManagerCell.h"
#import "DirectReport.h"
#import "DirectReportCell.h"
#import "ManagerInfo.h"
#import "MembershipCell.h"
#import "User.h"

typedef NS_ENUM(NSUInteger, UserViewControllerSection) {
    UserViewControllerSectionBasicUserInfo,
    UserViewControllerSectionManager,
    UserViewControllerSectionDirectReports, 
    UserViewControllerSectionMembershipInfo,
};

static const NSUInteger kNumberOfSections = 4;


//This is view controller that displays the profile for the selected or current user
@implementation UserViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    //This ensures that the table cells adjust in height as required by the content
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    // We want to go back to the All Users view from the profile page
    // So change the back button to cancel and add an event handler
    // to override the default behavior of the Back button
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"All Users"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(handleBack:)];
    
    self.navigationItem.leftBarButtonItem = backButton;
    
    self.unifiedEndpointClient = [[O365UnifiedEndpointOperations alloc] init];
    [self fetchAllUserInfo];
    
    
}

//Let's make the calls to populate the profile page
- (void)fetchAllUserInfo
{
    [self fetchBasicProfile];
    [self fetchUserThumbnail];
    [self fetchHireDate];
    [self fetchTags];
    
    [self fetchManager];
    [self fetchDirectReports];
    [self fetchMembershipGroups];
}

- (BOOL)handleErrors:(NSError *)error {
    
    if (!error) {
        return NO;
    }
    
    NSLog(@"%@", [error localizedDescription]);
    dispatch_async(dispatch_get_main_queue(), ^{
        
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                       message:@"Error has occurred. Check log for more details"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"Close"
                                                  style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert
                           animated:YES completion:nil];
    });
    return YES;
}

- (void)fetchBasicProfile
{
    [self.unifiedEndpointClient fetchBasicUserInfoForUserId:self.user.objectId
                       completionHandler:^(BasicUserInfo *basicUserInfo, NSError *error) {
                           
                           if ([self handleErrors:error]) {
                               return;
                           }
                           self.basicUserInfo = basicUserInfo;

                       }];
    
}


- (void)fetchUserThumbnail
{
    [self.unifiedEndpointClient fetchThumbnailForUserId:self.user.objectId
                              completionHandler:^(UIImage *image, NSError *error) {

                                      if ([self handleErrors:error]) {
                                          return;
                                      }
                                      self.thumbnailPhoto= image;
                              }];
    
    
}

- (void)fetchHireDate
{
    [self.unifiedEndpointClient fetchHireDateForUserId:self.user.objectId
                             completionHandler:^(NSString *hireDate, NSError *error) {

                                     if ([self handleErrors:error]) {
                                         return;
                                     }
                                     self.hireDate = hireDate;
                             }];
    
}

- (void)fetchTags
{
    [self.unifiedEndpointClient fetchTagsForUserId:self.user.objectId
                         completionHandler:^(NSArray *tags, NSError *error) {

                                 if ([self handleErrors:error]) {
                                     return;
                                 }
      
                                 NSMutableString *tagString = [[NSMutableString alloc] init];
                                 for (NSObject * obj in tags) {
                                     [tagString appendString:[obj description]];
                                 }
                                 self.tags= tagString;

                         }];
}

- (void)fetchManager
{
    [self.unifiedEndpointClient fetchManagerInfoForUserId:self.user.objectId
                                completionHandler:^(ManagerInfo *managerInfo, NSError *error) {

                                        if ([self handleErrors:error]) {
                                            return;
                                        }
                                        self.manager = managerInfo;
                                }];
    
}

- (void)fetchDirectReports
{
    [self.unifiedEndpointClient fetchDirectReportsForUserId:self.user.objectId
                                  completionHandler:^(NSArray *directReports, NSError *error) {
                                      if ([self handleErrors:error]) {
                                          return;
                                      }
                                      
                                      self.directReports = directReports;
                                      
                                  }];
    
}

- (void)fetchMembershipGroups
{
    [self.unifiedEndpointClient fetchMembershipInfoForUserId:self.user.objectId
                                   completionHandler:^(NSArray *membershipGroups, NSError *error) {
                                       if ([self handleErrors:error]) {
                                           return;
                                       }
                                       self.membershipGroups = membershipGroups;
                                       
                                   }];
    
}



#pragma mark - Properties

// When properties are set, reload the table cell
- (void)performReloadOnIndex:(NSNumber *)index {
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:[index intValue]]
                  withRowAnimation:UITableViewRowAnimationNone];
}

- (void)setBasicUserInfo:(BasicUserInfo *)basicUserInfo
{
    _basicUserInfo = basicUserInfo;
    [self performSelectorOnMainThread:@selector(performReloadOnIndex:) withObject:@(UserViewControllerSectionBasicUserInfo) waitUntilDone:NO];
}

- (void)setThumbnailPhoto:(UIImage *)thumbnailPhoto
{
    _thumbnailPhoto = thumbnailPhoto;
    
    [self performSelectorOnMainThread:@selector(performReloadOnIndex:) withObject:@(UserViewControllerSectionBasicUserInfo) waitUntilDone:NO];
}

- (void)setHireDate:(NSString *)hireDate
{
    _hireDate = hireDate;
    [self performSelectorOnMainThread:@selector(performReloadOnIndex:) withObject:@(UserViewControllerSectionBasicUserInfo) waitUntilDone:NO];
}

- (void)setTags:(NSString *)tags
{
    _tags = tags;
        [self performSelectorOnMainThread:@selector(performReloadOnIndex:) withObject:@(UserViewControllerSectionBasicUserInfo) waitUntilDone:NO];
}

- (void)setManager:(ManagerInfo *)manager
{
    _manager = manager;
    [self performSelectorOnMainThread:@selector(performReloadOnIndex:) withObject:@(UserViewControllerSectionManager) waitUntilDone:NO];
}

- (void)setDirectReports:(NSArray *)directReports
{
    _directReports = [directReports copy];
    
    [self performSelectorOnMainThread:@selector(performReloadOnIndex:) withObject:@(UserViewControllerSectionDirectReports) waitUntilDone:NO];
}

- (void)setMembershipGroups:(NSArray *)membershipGroups
{
    _membershipGroups = [membershipGroups copy];

    [self performSelectorOnMainThread:@selector(performReloadOnIndex:) withObject:@(UserViewControllerSectionMembershipInfo) waitUntilDone:NO];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return kNumberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case UserViewControllerSectionBasicUserInfo:
            return 1;
            break;
        case UserViewControllerSectionManager:
            return 1;
            break;
        case UserViewControllerSectionDirectReports:
            return self.directReports.count;
            break;
        case UserViewControllerSectionMembershipInfo:
            return self.membershipGroups.count;
            break;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    switch (indexPath.section) {
        case UserViewControllerSectionBasicUserInfo: {
            GeneralUserInfoCell *generalUserInfoCell = [self.tableView dequeueReusableCellWithIdentifier:@"GeneralUserInfoCell"];
            
            [self configureGenericUserInfoCell:generalUserInfoCell];
            cell = generalUserInfoCell;

            break;
        }
        case UserViewControllerSectionManager: {
            ManagerCell *managerCell = [self.tableView dequeueReusableCellWithIdentifier:@"ManagerCell"];
            
            [self configureManagerCell:managerCell];
            
            cell = managerCell;
            break;
        }
        case UserViewControllerSectionDirectReports: {
            DirectReportCell *directReportCell = [self.tableView dequeueReusableCellWithIdentifier:@"DirectReportCell"];
            
            [self configureDirectReportCell:directReportCell
                               forIndexPath:indexPath];
            
            cell = directReportCell;
            break;
        }
        case UserViewControllerSectionMembershipInfo: {
            MembershipCell *membershipCell = [self.tableView dequeueReusableCellWithIdentifier:@"MembershipCell"];
            
            [self configureMembershipCell:membershipCell
                               forIndexPath:indexPath];
            
            cell = membershipCell;
            break;
        }
    }
    
    return cell;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case UserViewControllerSectionBasicUserInfo:
            return nil;
            break;
        case UserViewControllerSectionManager:
            return @"Manager";
            break;
        case UserViewControllerSectionDirectReports:
            return @"Direct Reports";
            break;
        case UserViewControllerSectionMembershipInfo:
            return @"Membership";
            break;
    }
    
    return nil;
}

//Configure the custom cells with the data

- (void)configureGenericUserInfoCell:(GeneralUserInfoCell *)cell
{
    cell.displayNameLabel.text = self.basicUserInfo.displayName;
    cell.tagsLabel.text = self.tags;
    cell.thumbnailImageView.image = self.thumbnailPhoto ;
    cell.jobTitleLabel.text = self.basicUserInfo.jobTitle;
    cell.departmentLabel.text = self.basicUserInfo.department;
    cell.hireDateLabel.text = self.hireDate;
    cell.emailLabel.text = self.basicUserInfo.email;
    cell.phoneLabel.text = self.basicUserInfo.phone;
    cell.stateLabel.text = self.basicUserInfo.state;
    cell.countryLabel.text = self.basicUserInfo.country;
}

- (void)configureManagerCell:(ManagerCell *)cell
{
    cell.displayNameLabel.text = self.manager.displayName;
    cell.jobTitleLabel.text = self.manager.jobTitle;
}

- (void)configureDirectReportCell:(DirectReportCell *)cell
                     forIndexPath:(NSIndexPath *)indexPath
{
    DirectReport *directReport = self.directReports[indexPath.row];
    
    cell.displayNameLabel.text = directReport.displayName;
    cell.jobTitleLabel.text = directReport.jobTitle;
}

- (void)configureMembershipCell:(MembershipCell *)cell
                    forIndexPath:(NSIndexPath *)indexPath
{
        MembershipGroup *membershipGroup= self.membershipGroups[indexPath.row];
        
        cell.groupNameLabel.text = membershipGroup.groupName;
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"ShowManager"]) {
        UserViewController *userViewController = segue.destinationViewController;
        
        User *selectedUser = [[User alloc] initWithId:self.manager.objectId
                                          displayName:self.manager.displayName
                                             jobTitle:self.manager.jobTitle];
        
        userViewController.user = selectedUser;

    }
    else if ([segue.identifier isEqualToString:@"ShowDirectReport"]) {
        UserViewController *userViewController = segue.destinationViewController;
        NSIndexPath *selectedIndexPath = [self.tableView indexPathForCell:sender];
        DirectReport *directReport = self.directReports[selectedIndexPath.row];
        
        
        User *selectedUser = [[User alloc] initWithId:directReport.objectId
                                          displayName:directReport.displayName
                                             jobTitle:directReport.jobTitle];
        
        userViewController.user = selectedUser;
        
    }
    

}


// Override the Back button to jump to the All Users view
- (void) handleBack:(id)sender
{
    // pop to root view controller
    [self.navigationController popToRootViewControllerAnimated:YES];
    
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
