//
//  FSArrayController.h
//  FontSets
//
//  Created by Daan van Hasselt on 2/11/12.
//  Copyright (c) 2012 Touchwonders B.V. All rights reserved.
//

/**
 * NSArrayController subclass
 *
 * We override the 'remove' method to post a notification. FSDocument can respond to this before the row is actually removed.
 *
 */

#import <AppKit/AppKit.h>

@interface FSArrayController : NSArrayController

@end
