//
//  MainViewController.m
//  MyTweet
//
//  Created by AnCheng on 8/2/15.
//  Copyright (c) 2015 ancheng1114. All rights reserved.
//

#import "MainViewController.h"

#define AccountTwitterAccessGranted @"TwitterAccessGranted"
#define AccountTwitterSelectedIdentifier @"TwitterAccountSelectedIdentifier"

@interface MainViewController ()
{
    
    ACAccountStore *account;
    NSArray * twitterAccounts;
    ACAccount * selectedAccount;
}

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (IBAction)onTwitterLogin:(id)sender
{
    
    [self grantedWithTwitter];

}

-(void) grantedWithTwitter
{
    
    if(account == nil)
        account = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [account accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [account requestAccessToAccountsWithType:accountType options:nil
                                  completion:^(BOOL granted, NSError *error)
     {
         if (granted)
         {
             twitterAccounts = [account accountsWithAccountType:accountType];
             [self showAccountSelectionsSheet];
             
         }
         else
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Twitter Error"
                                                                     message:@"Please make sure you have a Twitter account set up in Settings. Also grant access to this app"
                                                                    delegate:nil
                                                           cancelButtonTitle:@"Dismiss"
                                                           otherButtonTitles:nil];
                 [alertView show];
             });
         }
         
     }];
}

-(void) showAccountSelectionsSheet
{
    if (twitterAccounts.count == 0)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Twitter Error"
                                                                message:@"Please make sure you have a Twitter account set up in Settings. Also grant access to this app"
                                                               delegate:nil
                                                      cancelButtonTitle:@"Dismiss"
                                                      otherButtonTitles:nil];
            [alertView show];
        });

    }
    else
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Accounts"
                                                                                 message:@""
                                                                          preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel")
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction *action)
                                       {
                                           NSLog(@"Cancel action");
                                       }];
        [alertController addAction:cancelAction];
        
        for (int i=0; i<twitterAccounts.count; i++) {
            
            ACAccount * account1 = [twitterAccounts objectAtIndex:i];
            
            UIAlertAction * menuAlert = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"@%@", account1.username]                                                             style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction *action)
                                         {
                                             selectedAccount = account1;
                                             
                                             AppDelegate * delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
                                             delegate.curAccount = [selectedAccount copy];
                                             
                                             [self performSegueWithIdentifier:@"mainSegue" sender:nil];
                                             
                                         }];
            
            [alertController addAction:menuAlert];
            
        }
        
        UIPopoverPresentationController *popover = alertController.popoverPresentationController;
        if (popover)
        {
            
            popover.sourceView = _loginButton;
            popover.sourceRect = _loginButton.bounds;
            popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
        }
        
        [self presentViewController:alertController animated:YES completion:nil];
    }

}

@end
