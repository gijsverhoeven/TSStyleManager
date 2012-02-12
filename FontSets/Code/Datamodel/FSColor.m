//
//  FSColor.m
//  FontSets
//
//  Created by Daan van Hasselt on 09-02-12.
//  Copyright (c) 2012 Touchwonders B.V.. All rights reserved.
//

#import "FSColor.h"

@implementation FSColor

@synthesize name;
@synthesize red;
@synthesize green;
@synthesize blue;
@synthesize alpha;
@synthesize comments;

-(id)init{
    self = [super init];
    if(self){
        self.name = @"DefaultColor";
        self.comments = @"This is the default color (black)";
        self.red = [NSNumber numberWithInt:0];
        self.green = [NSNumber numberWithInt:0];
        self.blue = [NSNumber numberWithInt:0];
        self.alpha = [NSNumber numberWithInt:255];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.red forKey:@"red"];
    [aCoder encodeObject:self.green forKey:@"green"];
    [aCoder encodeObject:self.blue forKey:@"blue"];
    [aCoder encodeObject:self.alpha forKey:@"alpha"];
    [aCoder encodeObject:self.comments forKey:@"comments"];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if(self = [self init]){
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.red = [aDecoder decodeObjectForKey:@"red"];
        self.green = [aDecoder decodeObjectForKey:@"green"];
        self.blue = [aDecoder decodeObjectForKey:@"blue"];
        self.alpha = [aDecoder decodeObjectForKey:@"alpha"];
        self.comments = [aDecoder decodeObjectForKey:@"comments"];
    }
    return self;
}

+(FSColor *)defaultColor{
    FSColor *color = [[FSColor alloc] init];
    color.name = @"DefaultColor";
    color.comments = @"This is the default color (black)";
    color.red = [NSNumber numberWithInt:0];
    color.green = [NSNumber numberWithInt:0];
    color.blue = [NSNumber numberWithInt:0];
    color.alpha = [NSNumber numberWithInt:255];
    return color;
}

@end
