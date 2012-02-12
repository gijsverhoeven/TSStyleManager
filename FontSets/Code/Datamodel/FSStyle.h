//
//  FSStyle.h
//  FontSets
//
//  Created by Daan on 2/10/12.
//  Copyright (c) 2012 Touchwonders B.V.. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FSShadow.h"
#import "FSFont.h"
#import "FSColor.h"

@interface FSStyle : NSObject <NSCoding>

/**
 * Default style with black system font without shadow
 *
 * @return default style
 */
+(FSStyle *) defaultStyle;

///-------------------------------------------------
/// @name Properties
///-------------------------------------------------

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *comments;
@property (nonatomic, strong) FSFont *font;
@property (nonatomic, strong) FSColor *color;
@property (nonatomic, strong) FSShadow *shadow;

@end
