//
//  NSDictionary+CPAdditions.h
//  itwitter
//
//  Created by Sriram Varadarajan on 8/17/13.
//  Copyright (c) 2013 Y.CORP.YAHOO.COM\vsriram. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (CPAdditions)

- (id)objectOrNilForKey:(id)key;
- (id)valueOrNilForKeyPath:(id)keyPath;

@end
