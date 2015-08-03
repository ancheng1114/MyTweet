//
//  TweetTableViewCell.h
//  MyTweet
//
//  Created by AnCheng on 8/2/15.
//  Copyright (c) 2015 ancheng1114. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTAttributedLabel.h"
#import "Tweet.h"
#import "TweetEntity.h"

@class TweetTableViewCell;

@protocol TweetTableViewCellDelegate <NSObject>

@optional

- (void)saveTweet:(TweetTableViewCell *)cell;

@end

@interface TweetTableViewCell : UITableViewCell

@property (nonatomic ,assign) IBOutlet UIView *retweetView;
@property (nonatomic ,assign) IBOutlet UILabel *retweeterLabel;
@property (nonatomic ,assign) IBOutlet NSLayoutConstraint *retweetViewHeightConstraint;

@property (nonatomic ,assign) IBOutlet UIImageView *userThumbnailImage;
@property (nonatomic ,assign) IBOutlet UILabel *userNameLabel;
@property (nonatomic ,assign) IBOutlet UILabel *userScreennameLabel;
@property (nonatomic ,assign) IBOutlet UILabel *shortTimestampLabel;
@property (nonatomic ,assign) IBOutlet TTTAttributedLabel *tweetTextLabel;

@property (nonatomic ,assign) IBOutlet UIButton *replyButton;
@property (nonatomic ,assign) IBOutlet UIButton *retweetButton;
@property (nonatomic ,assign) IBOutlet UIButton *favoriteButton;

@property (nonatomic ,assign) IBOutlet UIButton *saveBtn;

@property (nonatomic ,weak) id <TweetTableViewCellDelegate> celldelegate;

- (void)setTweet:(Tweet *)sourceTweet;
- (void)setTweet1:(TweetEntity *)tweetEntity;

- (IBAction)onSave:(id)sender;

@end
