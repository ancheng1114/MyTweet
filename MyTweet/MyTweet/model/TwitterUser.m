//
//  TwitterUser.m
//  MyTweet
//
//  Created by AnCheng on 8/2/15.
//  Copyright (c) 2015 ancheng1114. All rights reserved.
//

#import "TwitterUser.h"

@implementation TwitterUser

- (void)setDic:(NSDictionary *)userDictionary
{
    _userDictionary = userDictionary;
    _name = userDictionary[@"name"];
    _screenname = userDictionary[@"screen_name"];
    _profileImageUrl = userDictionary[@"profile_image_url"];
    _tagline = userDictionary[@"description"];
    _location = userDictionary[@"location"];
    
//    _numTweets = userDictionary["statusesCount"] as? Int
//    _friendsCount = userDictionary["friendsCount"] as? Int
//    _followersCount = userDictionary["followersCount"] as? Int

}

@end
