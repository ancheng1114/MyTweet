//
//  TweetTableViewCell.m
//  MyTweet
//
//  Created by AnCheng on 8/2/15.
//  Copyright (c) 2015 ancheng1114. All rights reserved.
//

#import "TweetTableViewCell.h"
#import "TwitterUser.h"
#import "NSDate+PrettyTimestamp.h"
#import "SDWebImageManager.h"

@implementation TweetTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTweet:(Tweet *)sourceTweet
{
    self.retweetViewHeightConstraint.constant = 0;
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager downloadImageWithURL:[NSURL URLWithString:sourceTweet.user.profileImageUrl] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize){
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL){
        
        self.userThumbnailImage.image = image;
    }];
    
    
    self.userNameLabel.text = sourceTweet.user.name;
    self.userScreennameLabel.text = sourceTweet.user.screenname;
    self.tweetTextLabel.text = sourceTweet.text;
    self.shortTimestampLabel.text = [sourceTweet.createdAt prettyTimestampSinceNow];
}

- (void)setTweet1:(TweetEntity *)tweetEntity
{
    self.retweetViewHeightConstraint.constant = 0;
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager downloadImageWithURL:[NSURL URLWithString:tweetEntity.profilethumb] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize){
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL){
        
        self.userThumbnailImage.image = image;
    }];
    
    
    self.userNameLabel.text = tweetEntity.name;
    self.userScreennameLabel.text = tweetEntity.screenname;
    self.tweetTextLabel.text = tweetEntity.text;
    self.shortTimestampLabel.text = [tweetEntity.date prettyTimestampSinceNow];
}

- (IBAction)onSave:(id)sender
{
    [self.celldelegate saveTweet:self];
}

@end
