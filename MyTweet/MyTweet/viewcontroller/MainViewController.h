//
//  MainViewController.h
//  MyTweet
//
//  Created by AnCheng on 8/2/15.
//  Copyright (c) 2015 ancheng1114. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController

@property (nonatomic ,assign) IBOutlet UIButton * loginButton;

- (IBAction)onTwitterLogin:(id)sender;

@end
