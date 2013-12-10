//
//  fvLogCell.m
//  FitVoice
//
//  Created by Brian Clark on 11/24/13.
//  Copyright (c) 2013 FitVoice. All rights reserved.
//

#import "fvLogCell.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation fvLogCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

@end
