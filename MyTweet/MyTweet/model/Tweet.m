//
//  Tweet.m
//  MyTweet
//
//  Created by AnCheng on 8/2/15.
//  Copyright (c) 2015 ancheng1114. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet

- (void)setDic:(NSDictionary *)tweetDictionary
{
    _tweetDictionary = tweetDictionary;
    
    
    _id = [tweetDictionary[@"id"] intValue];
    _text = tweetDictionary[@"text"];
    
    _createdAtString = tweetDictionary[@"created_at"];
    _createdAt = [NewDateFormatter() dateFromString:_createdAtString];

    NSDictionary  *userDictionary = tweetDictionary[@"user"];
    _user = [TwitterUser new];
    [_user setDic:userDictionary];
}

- (void)setDic1:(NSDictionary *)tweetDictionary;{
    
    _id = [tweetDictionary[@"id"] intValue];
    _text = tweetDictionary[@"description"];
    _createdAtString = tweetDictionary[@"created_at"];
    _createdAt = [NewDateFormatter() dateFromString:_createdAtString];
    
    _user = [TwitterUser new];
    _user.name = tweetDictionary[@"name"];
    _user.screenname = tweetDictionary[@"screen_name"];
    _user.profileImageUrl = tweetDictionary[@"profile_image_url"];
    
}

static inline NSDateFormatter *NewDateFormatter() {
    
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"EEE MMM d HH:mm:ss Z y";    //Optionally for time zone conversions
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    
    return formatter;
}

@end
