//
//  TweetCell.h
//  itwitter
//
//  Created by Sriram Varadarajan on 8/18/13.
//  Copyright (c) 2013 Y.CORP.YAHOO.COM\vsriram. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TweetCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *tweetLabel;
@property (nonatomic, weak) IBOutlet UIImageView *userImage;

@end

