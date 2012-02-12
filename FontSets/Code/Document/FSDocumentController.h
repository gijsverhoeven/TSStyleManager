//
//  FSDocumentController.h
//  FontSets
//
//  Created by Daan on 1/23/12.
//  Copyright (c) 2012 Touchwonders B.V.. All rights reserved.
//

/**
 * Document controller
 *
 * This document controller keeps track of the currently active document. This is useful when performing document-specific actions from the main menu.
 *
 */

#import <AppKit/AppKit.h>
#import "FSDocument.h"

@interface FSDocumentController : NSDocumentController

/**
 * Call export on the currently active document.
 *
 * @param sender button clicked
 */
- (IBAction)exportCategoryForCurrentDocument:(id)sender;

/**
 * Select a tab in the currently active document.
 *
 * @param sender button clicked
 */
-(IBAction)selectTab:(id)sender;

/**
 * Remove the selected row in the currently active document in response to the user pressing backspace or clicking the menubaritem.
 *
 * @param sender clicked menubaritem
 */
- (IBAction)removeSelectedRowForCurrentDocument:(id)sender;

@end
