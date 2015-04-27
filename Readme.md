
#Office 365 Profile Sample for iOS#

This sample uses the Office 365 unified endpoint (preview) to fetch the user directory and user profile data from various services like Active Directory, SharePoint, and OneDrive, and then displays them in a simple user interface.

**Table of contents**

* [Set up your environment](#set-up-your-environment)
* [Use CocoaPods to import the O365 iOS SDK](#use-cocoapods-to-import-the-o365-ios-sdk)
* [Register your app with Microsoft Azure](#register-your-app-with-microsoft-azure)
* [Get the Client ID and Redirect Uri and other constants into the project](#get-the-client-id-and-redirect-uri-into-the-project)
* [Important Code Files](#code-files)
* [Questions and comments](#questions-and-comments)
* [Additional resources](#additional-resources)



## Set up your environment ##

To run the Office 365 Profile sample, you need the following:


* [Xcode](https://developer.apple.com/) from Apple.
* An Office 365 account. You can get an Office 365 account by signing up for an [Office 365 Developer site](http://msdn.microsoft.com/en-us/library/office/fp179924.aspx). This will give you access to the APIs that you can use to create apps that target Office 365 data.
* A Microsoft Azure tenant to register your application. Azure Active Directory provides identity services that applications use for authentication and authorization. A trial subscription can be acquired here: [Microsoft Azure](https://account.windowsazure.com/SignUp).

**Important**: You will also need to ensure your Azure subscription is bound to your Office 365 tenant. To do this, see the Adding a new directory section in the Active Directory team's blog post, [Creating and Managing Multiple Windows Azure Active Directories](http://blogs.technet.com/b/ad/archive/2013/11/08/creating-and-managing-multiple-windows-azure-active-directories.aspx). You can also read [Set up Azure Active Directory access for your Developer Site](http://msdn.microsoft.com/en-us/office/office365/howto/setup-development-environment#bk_CreateAzureSubscription) for more information.


* Installation of [CocoaPods](https://cocoapods.org/) as a dependency manager. CocoaPods will allow you to pull the Office 365 and Azure Active Directory Authentication Library (ADAL) dependencies into the project.

Once you have an Office 365 account and an Azure AD account that is bound to your Office 365 Developer site, you'll need to perform the following steps:

1. Register your application with Azure, and configure the appropriate Office 365 permissions. 
2. Install and use CocoaPods to get the Office 365 and ADAL authentication dependencies into your project.
3. Enter the Azure app registration specifics (ClientID and RedirectUri) and other constants into the project in XCode.

## Use CocoaPods to import the O365 iOS SDK
Note: If you've never used **CocoaPods** before as a dependency manager you'll have to install it prior to getting your Office 365 iOS SDK dependencies into your project. 

Execute the next lines of code from the **Terminal** app on your Mac.

sudo gem install cocoapods
pod setup

If the install and setup are successful, you should see the message **Setup completed in Terminal**. For more information on CocoaPods, and its usage, see [CocoaPods](https://cocoapods.org/).


**Get the ADALiOS dependency in your project**
The Profile sample  already contains a podfile that will get the ADAL components (pods) into your project. It's located in the sample root ("Podfile"). The example shows the contents of the file.

target 'O365-iOS-Profile' do
pod 'ADALiOS', '~> 1.0.0'   # 1.0.0 < ver < 1.1.0
end


You'll simply need to navigate to the project directory in the **Terminal** app (root of the project folder) and run the following command.


pod install

Note: You should receive confirmation that these dependencies have been added to the project and that you must open the workspace instead of the project from now on in Xcode (**O365-iOS-Profile.xcworkspace**).  If there is a syntax error in the Podfile, you will encounter an error when you run the install command.

## Register your app with Microsoft Azure
1.	Sign in to the [Azure Management Portal](https://manage.windowsazure.com), using your Azure AD credentials.
2.	Select **Active Directory** on the left menu, then select the directory for your Office 365 developer site.
3.	On the top menu, select **Applications**.
4.	Seelct **Add** from the bottom menu.
5.	On the **What do you want to do** page, select **Add an application my organization is developing**.
6.	On the **Tell us about your application** page, specify **O365-iOS-Profile** for the application name and select **NATIVE CLIENT APPLICATION** for type.
7.	Select the arrow icon on the lower-right corner of the page.
8.	On the Application information page, specify a Redirect URI, for this example, you can specify http://localhost/connect, and then select the check box in the lower-right hand corner of the page. Remember this value for the section **Getting the ClientID and RedirectUri into the project**.
9.	Once the application has been successfully added, you will be taken to the quick start page for the application. Select Configure in the top menu.
10.	Under **permissions to other applications**, select Office 365 unified API (preview) and add the following permissions: **Read all user's basic profiles**, **Read user's files** and **Read items in all site collections**.
11.	Copy the value specified for **Client ID** on the **Configure** page. Remember this value for the section **Getting the ClientID and RedirectUri into the project**.
12.	Select **Save** in the bottom menu.


## Get the Client ID and Redirect Uri and other constants into the project

Finally you'll need to add the Client ID and Redirect Uri you recorded from the previous section **Register your app with Microsoft Azure**.

Browse the **O365-iOS-Profile** project directory and open up the workspace (O365-iOS-Profile.xcworkspace). In the **AuthenticationManager.m** file you'll see that the **ClientID** and **RedirectUri** values can be added to the top of the file. Supply the necessary values in this file.

// You will set your application's clientId and redirect URI. You get
// these when you register your application in Azure AD.

static NSString * const REDIRECT_URL_STRING = @"ENTER_REDIRECT_URI_HERE";

static NSString * const CLIENT_ID           = @"ENTER_CLIENT_ID_HERE";


Next enter the other constants in the files.

In O365UnifiedEndpointOperations, enter your tenant name, such as x.onmicrosoft.com.
static NSString * const TENANT_STRING = @"ENTER_YOUR-TENANT_NAME_HERE/";

In AllUsersViewController, enter your friendly organization name. This will be displayed as the title.
static NSString * const ORGANIZATION_NAME           = @"ENTER_YOUR_ORG_NAME_HERE";


## Important Code Files


**Models**

These domain entities are custom classes that represent the data of the application. All of these classes are immutable.  They wrap the basic entities provided by the Office 365 APIs. 

**Office365 Helpers**

The helpers are the classes that actually communicate with Office 365 by making REST API calls. This architecture decouples the rest of the app from the Office365 APIs.


**Controllers**

These are the controllers for the two views supported by this sample.

**Views**

This implements all of the custom cells used by the controllers in this sample to display nicely formatted data.  Note that the number of rows needed for each type of table cell varies depending on the number of direct reports, or the number of files shared. It is for this reason, that it has been created independently instead of as a prototype cell in the storyboard. 


## Questions and comments

We'd love to get your feedback on the Office 365 Profile sample. You can send your feedback to us in the [Issues](https://github.com/OfficeDev/O365-iOS-Profile) section of this repository. <br>
Questions about Office 365 development in general should be posted to [Stack Overflow](http://stackoverflow.com/questions/tagged/Office365+API). Make sure that your questions are tagged with [Office365] and [API].

## Additional resources

* [Office 365 Connect app for iOS](https://github.com/OfficeDev/O365-iOS-Connect)
* [Office 365 Code Snippets for iOS](https://github.com/OfficeDev/O365-iOS-Snippets)
* [Office 365 APIs documentation](http://msdn.microsoft.com/office/office365/howto/platform-development-overview)
* [Office Dev Center](http://dev.office.com/)

## Copyright
Copyright (c) 2015 Microsoft. All rights reserved.