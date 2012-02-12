//
//  FSShadow.h
//  FontSets
//
//  Created by Daan van Hasselt on 09-02-12.
//  Copyright (c) 2012 Touchwonders B.V.. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSShadow : NSObject <NSCoding>

/**
 * Default shadow with an opacity of 0
 *
 * @return default shadow
 */
+(FSShadow *) defaultShadow;

///-------------------------------------------------
/// @name Properties
///-------------------------------------------------

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *red;
@property (nonatomic, strong) NSNumber *green;
@property (nonatomic, strong) NSNumber *blue;
@property (nonatomic, strong) NSNumber *alpha;
@property (nonatomic, strong) NSString *offset;
@property (nonatomic, strong) NSString *comments;

@end
