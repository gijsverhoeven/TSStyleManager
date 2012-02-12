//
//  FSFont.h
//  FontSets
//
//  Created by Daan on 1/23/12.
//  Copyright (c) 2012 Touchwonders B.V.. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSFont : NSObject <NSCoding>

/**
 * Default font
 *
 * @return default font
 */
+ (FSFont *)defaultFont;

/**
 * Generate a name for the font
 */
- (void)generateName;

/**
 * Generate a description for the font
 */
- (void)generateDescription;

/**
 * This method wil be called when a font is selected in the fontpanel
 */
- (void)changeFont:(id)sender;

///-------------------------------------------------
/// @name Properties
///-------------------------------------------------

@property (strong) NSFont *font;
@property (strong) NSString *fontFile;
@property (strong) NSNumber *fontSize;
@property (strong) NSString *fontName;
@property (strong) NSString *fontDescription;

@end
