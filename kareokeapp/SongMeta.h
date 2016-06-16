//
//  SongMeta.h
//  kareokeapp
//
//  Created by Bukalapak on 6/16/16.
//  Copyright © 2016 Bukalapak. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SongMeta : NSObject


@property int iid;
@property(strong, nonatomic) NSString *title;
@property(strong, nonatomic) NSDate *dateCreated;

- (SongMeta *) initWithId:(int)iid;


@end
