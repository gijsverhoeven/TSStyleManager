//
//  FSDocumentController.m
//  FontSets
//
//  Created by Daan on 1/23/12.
//  Copyright (c) 2012 Touchwonders B.V.. All rights reserved.
//

#import "FSDocumentController.h"

@implementation FSDocumentController

- (IBAction)exportCategoryForCurrentDocument:(id)sender{
    [[self currentDocument] exportCategory:sender];
}

- (IBAction)removeSelectedRowForCurrentDocument:(id)sender{
    [[self currentDocument] removeSelectedRow:sender];
}

-(IBAction)selectTab:(id)sender{
    NSMenuItem *item = sender;
    if([[item title] isEqualToString:@"Styles"])
        [[self currentDocument] selectTabViewItemAtIndex:0];
    if([[item title] isEqualToString:@"Fonts"])
        [[self currentDocument] selectTabViewItemAtIndex:1];
    if([[item title] isEqualToString:@"Colors"])
        [[self currentDocument] selectTabViewItemAtIndex:2];
    if([[item title] isEqualToString:@"Shadows"])
        [[self currentDocument] selectTabViewItemAtIndex:3];
}

@end
