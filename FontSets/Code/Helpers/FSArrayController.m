//
//  FSArrayController.m
//  FontSets
//
//  Created by Daan van Hasselt on 2/11/12.
//  Copyright (c) 2012 Touchwonders B.V. All rights reserved.
//

#import "FSArrayController.h"

@implementation FSArrayController

-(void)remove:(id)sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationWillRemoveRow object:nil];
    [super remove:sender];
}

@end
