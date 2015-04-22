/*
 * Copyright (c) Microsoft. All rights reserved. Licensed under the MIT license. See full license at the bottom of this file.
 */

#import <UIKit/UIKit.h>

@class User;
@class O365UnifiedEndpointOperations;
@class ManagerInfo;
@class BasicUserInfo;
@class DirectReport;
@class MembershipGroup;
@class File;

//This is view controller that displays the profile for the selected or current user
@interface UserViewController : UITableViewController

@property (strong, nonatomic) User *user;
@property (strong, nonatomic) BasicUserInfo *basicUserInfo;
@property (strong, nonatomic) UIImage *thumbnailPhoto;
@property (strong, nonatomic) NSString *hireDate;
@property (strong, nonatomic) NSString *tags;
@property (strong, nonatomic) ManagerInfo *manager;
@property (strong, nonatomic) NSArray *directReports;
@property (strong, nonatomic) NSArray *membershipGroups;
@property (strong, nonatomic) NSArray *files;
@property (strong, nonatomic) O365UnifiedEndpointOperations *unifiedEndpointClient;

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