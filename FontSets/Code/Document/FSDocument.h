//
//  FSDocument.h
//  FontSets
//
//  Created by Daan on 1/22/12.
//  Copyright (c) 2012 Touchwonders B.V.. All rights reserved.
//

/**
 * Document class
 *
 * This class describes a complete document. It contains fonts, colors, shadows and styles. It also handles most of the user input.
 *
 */

#import <Cocoa/Cocoa.h>
#import "FSArrayController.h"

#define clampColor(x) MIN(MAX(x, 0), 255)

#define StylesTableViewTag 1
#define FontTableViewTag 2

#define kStylesTabNameColumn @"StylesTabNameColumn"
#define kStylesTabFontColumn @"StylesTabFontColumn"
#define kStylesTabColorColumn @"StylesTabColorColumn"
#define kStylesTabShadowsColumn @"StylesTabShadowsColumn"

#define kColorTabRedColumn @"ColorTabRedColumn"
#define kColorTabGreenColumn @"ColorTabGreenColumn"
#define kColorTabBlueColumn @"ColorTabBlueColumn"
#define kColorTabAlphaColumn @"ColorTabAlphaColumn"

#define kShadowsTabRedColumn @"ShadowsTabRedColumn"
#define kShadowsTabGreenColumn @"ShadowsTabGreenColumn"
#define kShadowsTabBlueColumn @"ShadowsTabBlueColumn"
#define kShadowsTabAlphaColumn @"ShadowsTabAlphaColumn"

#define kFontsTabSizeColumn @"FontsTabSizeColumn"

@interface FSDocument : NSDocument <NSTableViewDelegate, NSTableViewDataSource, NSTabViewDelegate, NSCoding>

/**
 * Export the category.
 *
 * @param sender button clicked
 */
- (IBAction)exportCategory:(id)sender;

/**
 * Notify the document that the selection of a tableview changed.
 *
 * @param sender tableview 
 */
- (IBAction)selectionDidChange:(id)sender;

/**
 * Remove the selected row in response to the user pressing backspace or clicking the menubaritem.
 *
 * @param sender clicked menubaritem
 */
- (IBAction)removeSelectedRow:(id)sender;

/**
 * Select the tabview at a given index.
 *
 * @param tabViewIndex index of tabview to be selected
 */
- (void)selectTabViewItemAtIndex:(NSInteger)tabViewIndex;

///-------------------------------------------------
/// @name Properties
///-------------------------------------------------

/** Mutable array of styles, contains FSStyle objects */
@property (strong) IBOutlet NSMutableArray *styles;

/** Mutable array of fonts, contains FSFont objects */
@property (strong) IBOutlet NSMutableArray *fonts;

/** Mutable array of colors, contains FSColor objects */
@property (strong) IBOutlet NSMutableArray *colors;

/** Mutable array of shadow, contains FSShadow objects */
@property (strong) IBOutlet NSMutableArray *shadows;

/** Label used for previewing settings */
@property (strong) IBOutlet NSTextField *previewTextField;

@property (strong) IBOutlet NSTabView *tabView;

///-------------------------------------------------
/// @name TableViews
///-------------------------------------------------

/** Reference to the styles-tableview */
@property (strong) IBOutlet NSTableView *stylesTableView;

/** Reference to the fonts-tableview */
@property (strong) IBOutlet NSTableView *fontsTableView;

/** Reference to the colors-tableview */
@property (strong) IBOutlet NSTableView *colorsTableView;

/** Reference to the shadows-tableview */
@property (strong) IBOutlet NSTableView *shadowsTableView;


///-------------------------------------------------
/// @name ArrayControllers
///-------------------------------------------------

/** Reference to the styles-controller */
@property (strong) IBOutlet FSArrayController *stylesArrayController;

/** Reference to the fonts-controller */
@property (strong) IBOutlet FSArrayController *fontsArrayController;

/** Reference to the colors-controller */
@property (strong) IBOutlet FSArrayController *colorsArrayController;

/** Reference to the shadows-controller */
@property (strong) IBOutlet FSArrayController *shadowsArrayController;

@end
