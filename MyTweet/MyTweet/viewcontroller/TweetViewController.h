//
//  TweetViewController.h
//  MyTweet
//
//  Created by AnCheng on 8/2/15.
//  Copyright (c) 2015 ancheng1114. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TweetTableViewCell.h"

@interface TweetViewController : UIViewController <UITableViewDataSource ,UITableViewDelegate ,TweetTableViewCellDelegate>

@property (nonatomic ,assign) IBOutlet UITableView *tweetTableView;

@property (nonatomic ,strong) NSMutableArray *tweetArr;

@end
