//
//  TweetTableViewCell.m
//  ios_twitter
//
//  Created by Stanley Ng on 7/3/14.
//  Copyright (c) 2014 Stanley Ng. All rights reserved.
//

#import "TweetTableViewCell.h"

@implementation TweetTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.contentView layoutIfNeeded];
    self.statusTextLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.statusTextLabel.frame);
}

@end
