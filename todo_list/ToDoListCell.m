//
//  ToDoListCell.m
//  todo_list
//
//  Created by Henry Ching on 1/20/14.
//  Copyright (c) 2014 YahooHenry. All rights reserved.
//

#import "ToDoListCell.h"

@implementation ToDoListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
