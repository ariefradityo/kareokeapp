//
//  SongMeta.m
//  kareokeapp
//
//  Created by Bukalapak on 6/16/16.
//  Copyright © 2016 Bukalapak. All rights reserved.
//

#import "SongMeta.h"

@implementation SongMeta

- (instancetype)init
{
    if (self = [super init]) {
        self.iid = 0;
        self.title = @"No Title";
        self.dateCreated = [[NSDate alloc] init];
    }
    return self;
}

- (SongMeta *) initWithId:(int)iid;{
    self = [self init];
    self.iid = iid;
    return self;
}

@end
