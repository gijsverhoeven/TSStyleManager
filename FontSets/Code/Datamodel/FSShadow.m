//
//  FSShadow.m
//  FontSets
//
//  Created by Daan van Hasselt on 09-02-12.
//  Copyright (c) 2012 Touchwonders B.V.. All rights reserved.
//

#import "FSShadow.h"

@implementation FSShadow

@synthesize name;
@synthesize red;
@synthesize green;
@synthesize blue;
@synthesize alpha;
@synthesize offset;
@synthesize comments;

-(id)init{
    self = [super init];
    if(self){
        self.name = @"DefaultShadow";
        self.red = [NSNumber numberWithInt:0];
        self.green = [NSNumber numberWithInt:0];
        self.blue = [NSNumber numberWithInt:0];
        self.alpha = [NSNumber numberWithInt:0];
        self.offset = @"0,0";
        self.comments = @"This is the default shadow (none)";
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if(self = [self init]){
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.red = [aDecoder decodeObjectForKey:@"red"];
        self.green = [aDecoder decodeObjectForKey:@"green"];
        self.blue = [aDecoder decodeObjectForKey:@"blue"];
        self.alpha = [aDecoder decodeObjectForKey:@"alpha"];
        self.offset = [aDecoder decodeObjectForKey:@"offset"];
        self.comments = [aDecoder decodeObjectForKey:@"comments"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.red forKey:@"red"];
    [aCoder encodeObject:self.green forKey:@"green"];
    [aCoder encodeObject:self.blue forKey:@"blue"];
    [aCoder encodeObject:self.alpha forKey:@"alpha"];
    [aCoder encodeObject:self.offset forKey:@"offset"];
    [aCoder encodeObject:self.comments forKey:@"comments"];
}

+(FSShadow *)defaultShadow{
    FSShadow *shadow = [[FSShadow alloc] init];
    shadow.name = @"DefaultShadow";
    shadow.red = [NSNumber numberWithInt:0];
    shadow.green = [NSNumber numberWithInt:0];
    shadow.blue = [NSNumber numberWithInt:0];
    shadow.alpha = [NSNumber numberWithInt:0];
    shadow.offset = @"0,0";
    shadow.comments = @"This is the default shadow (none)";
    return shadow;
}

@end
