//
//  FSStyle.m
//  FontSets
//
//  Created by Daan on 2/10/12.
//  Copyright (c) 2012 Touchwonders B.V.. All rights reserved.
//

#import "FSStyle.h"

@implementation FSStyle

@synthesize name;
@synthesize comments;
@synthesize font;
@synthesize color;
@synthesize shadow;

-(id)init{
    if(self = [super init]){
        self.name = @"DefaultStyle";
        self.comments = @"This is the default system style";
        self.color = [[FSColor alloc] init];
        self.font = [[FSFont alloc] init];
        self.shadow = [[FSShadow alloc] init];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if(self = [self init]){
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.comments = [aDecoder decodeObjectForKey:@"comments"];
        self.font = [aDecoder decodeObjectForKey:@"font"];
        self.color = [aDecoder decodeObjectForKey:@"color"];
        self.shadow = [aDecoder decodeObjectForKey:@"shadow"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.comments forKey:@"comments"];
    [aCoder encodeObject:self.font forKey:@"font"];
    [aCoder encodeObject:self.color forKey:@"color"];
    [aCoder encodeObject:self.shadow forKey:@"shadow"];
}

+(FSStyle*) defaultStyle{
    FSStyle *style = [[FSStyle alloc] init];
    style.name = @"DefaultStyle";
    style.comments = @"This is the default system style";
    style.font = [FSFont defaultFont];
    style.color = [FSColor defaultColor];
    style.shadow = [FSShadow defaultShadow];
    return style;
}

@end
