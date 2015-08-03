//
//  CoredataManager.m
//  TrueSpecGolf
//
//  Created by AnCheng on 11/24/14.
//  Copyright (c) 2014 Winning Identity. All rights reserved.
//

#import "CoredataManager.h"
#import "AppDelegate.h"
#import "TweetEntity.h"

@implementation CoredataManager

+ (id)sharedManager
{
    static CoredataManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[CoredataManager alloc] init];
    });
    return sharedManager;
}

// Used to propegate saves to the persistent store (disk) without blocking the UI
- (NSManagedObjectContext *)masterManagedObjectContext {
    if (_masterManagedObjectContext != nil) {
        return _masterManagedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _masterManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [_masterManagedObjectContext performBlockAndWait:^{
            [_masterManagedObjectContext setPersistentStoreCoordinator:coordinator];
        }];
        
    }
    return _masterManagedObjectContext;
}

// Return the NSManagedObjectContext to be used in the background during sync
- (NSManagedObjectContext *)backgroundManagedObjectContext {
    if (_backgroundManagedObjectContext != nil) {
        return _backgroundManagedObjectContext;
    }
    
    NSManagedObjectContext *masterContext = [self masterManagedObjectContext];
    if (masterContext != nil) {
        _backgroundManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [_backgroundManagedObjectContext performBlockAndWait:^{
            [_backgroundManagedObjectContext setParentContext:masterContext];
        }];
    }
    
    return _backgroundManagedObjectContext;
}

// Return the NSManagedObjectContext to be used in the background during sync
- (NSManagedObjectContext *)newManagedObjectContext {
    NSManagedObjectContext *newContext = nil;
    NSManagedObjectContext *masterContext = [self masterManagedObjectContext];
    if (masterContext != nil) {
        newContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [newContext performBlockAndWait:^{
            [newContext setParentContext:masterContext];
        }];
    }
    
    return newContext;
}

- (void)saveMasterContext {
    [self.masterManagedObjectContext performBlockAndWait:^{
        NSError *error = nil;
        BOOL saved = [self.masterManagedObjectContext save:&error];
        if (!saved) {
            // do some real error handling
            NSLog(@"Could not save master context due to %@", error);
        }
    }];
}

- (void)saveBackgroundContext {
    [self.backgroundManagedObjectContext performBlockAndWait:^{
        NSError *error = nil;
        BOOL saved = [self.backgroundManagedObjectContext save:&error];
        if (!saved) {
            // do some real error handling
            NSLog(@"Could not save background context due to %@", error);
        }
    }];
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"MyTweet" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"MyTweet.sqlite"];
    NSLog(@"DB Path : %@" ,storeURL.path);
    
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (void)addTweet:(Tweet *)tweet
{
    // check if exist tweet
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"TweetEntity"];
    // You are only interested in 1 result so limit the request to 1
    [request setFetchLimit:1];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(self.id = %@)" , [NSString stringWithFormat:@"%d" ,tweet.id]];
    [request setPredicate:pred];
    
    NSManagedObjectContext *managedObjectContext = [[CoredataManager sharedManager] masterManagedObjectContext];
    [managedObjectContext performBlockAndWait:^{
        NSError *error = nil;
        NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
        if ([results lastObject])   {
            
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"existing tweet !!!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [av show];
            
        }
        else
        {
            TweetEntity *entity = [NSEntityDescription insertNewObjectForEntityForName:@"TweetEntity" inManagedObjectContext:managedObjectContext];
            entity.id = [NSString stringWithFormat:@"%d" ,tweet.id];
            entity.text = tweet.text;
            entity.date = tweet.createdAt;
            entity.datestr = tweet.createdAtString;
            entity.name = tweet.user.name;
            entity.screenname = tweet.user.screenname;
            entity.profilethumb = tweet.user.profileImageUrl;
            
            [managedObjectContext performBlockAndWait:^{
                NSError *error = nil;
                if (![managedObjectContext save:&error]) {
                    NSLog(@"Unable to save context");
                }
                else
                {
                    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Success" message:@"successfully saved tweet !!!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [av show];
                }
            }];
        }
        
    }];
}

@end
