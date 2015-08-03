//
//  MainViewController.m
//  MyTweet
//
//  Created by AnCheng on 8/2/15.
//  Copyright (c) 2015 ancheng1114. All rights reserved.
//

#import "MainViewController.h"
#import "FHSTwitterEngine.h"

@interface MainViewController () <FHSTwitterEngineAccessTokenDelegate>

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[FHSTwitterEngine sharedEngine]setDelegate:self];
    [[FHSTwitterEngine sharedEngine]permanentlySetConsumerKey:@"K7mHPGrN7Wa6LNIyDRTYggLdT" andSecret:@"J3qV90jMeSmqOdSyzISl24MddXlKvbH8ckwSJplYikZtDmqHfx"];
    [[FHSTwitterEngine sharedEngine]loadAccessToken];
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
    if ([[FHSTwitterEngine sharedEngine]isAuthorized])
    {
        [self performSegueWithIdentifier:@"mainSegue" sender:nil];
    }
    else
    {
        UIViewController *loginController = [[FHSTwitterEngine sharedEngine]loginControllerWithCompletionHandler:^(BOOL success) {
            
            if (success)
            {
                [self performSegueWithIdentifier:@"mainSegue" sender:nil];
            }
            else
            {
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Twitter Login failed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [av show];
            }
            
            
        }];
        
        [self presentViewController:loginController animated:YES completion:nil];
    }

}

#pragma twitter delegate functions

- (void)storeAccessToken:(NSString *)accessToken {
    [[NSUserDefaults standardUserDefaults]setObject:accessToken forKey:@"accessToken"];
}

- (NSString *)loadAccessToken {
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"accessToken"];
}

@end
