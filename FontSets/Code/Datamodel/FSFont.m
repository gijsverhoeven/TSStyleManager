//
//  FSFont.m
//  FontSets
//
//  Created by Daan on 1/23/12.
//  Copyright (c) 2012 Touchwonders B.V.. All rights reserved.
//

#import "FSFont.h"

@implementation FSFont
@synthesize font;
@synthesize fontFile;
@synthesize fontSize;
@synthesize fontName;
@synthesize fontDescription;

-(NSString *)description{
    return [NSString stringWithFormat:@"%@, %@, %@, %@", fontFile, fontSize, fontName, fontDescription];
}

-(id)init{
    self = [super init];
    if(self){
        self.font = [NSFont systemFontOfSize:13];
        self.fontFile = @"LucidaGrande";
        self.fontName = @"DefaultFont";
        self.fontSize = [NSNumber numberWithInt:13];
        self.fontDescription = @"This is the default system font";
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.font forKey:@"font"];
    [aCoder encodeObject:self.fontFile forKey:@"fontFile"];
    [aCoder encodeObject:self.fontSize forKey:@"fontSize"];
    [aCoder encodeObject:self.fontName forKey:@"fontName"];
    [aCoder encodeObject:self.fontDescription forKey:@"fontDescription"];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if(self = [self init]){
        if([aDecoder decodeObjectForKey:@"font"] != nil)
            self.font = [aDecoder decodeObjectForKey:@"font"];
        self.fontFile = [aDecoder decodeObjectForKey:@"fontFile"];
        self.fontName = [aDecoder decodeObjectForKey:@"fontName"];
        self.fontSize = [aDecoder decodeObjectForKey:@"fontSize"];
        self.fontDescription = [aDecoder decodeObjectForKey:@"fontDescription"];
    }
    return self;
}

+ (FSFont *)defaultFont{
    FSFont *font = [[FSFont alloc] init];
    font.fontFile = @"LucidaGrande";
    font.fontName = @"DefaultFont";
    font.fontSize = [NSNumber numberWithInt:13];
    font.fontDescription = @"This is the default system font";
    return font;
}

- (void)changeFont:(id)sender{
    NSFont *oldFont = self.font;
    NSFont *newFont = [sender convertFont:oldFont]; 
    self.font = newFont;
    self.fontFile = [newFont fontName];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationDidChangeFont object:nil];
}

- (void)generateName{
    if(self.fontFile == nil || self.fontSize == nil){
        self.fontName = @"";
        return;
    };
    
    // remove dashes, brackets, colons, semicolons, periods, commas and spaces
    NSString *fileName = [self.fontFile stringByReplacingOccurrencesOfString:@"-" withString:@""];
    fileName = [fileName stringByReplacingOccurrencesOfString:@"{" withString:@""];
    fileName = [fileName stringByReplacingOccurrencesOfString:@"}" withString:@""];
    fileName = [fileName stringByReplacingOccurrencesOfString:@"[" withString:@""];
    fileName = [fileName stringByReplacingOccurrencesOfString:@"]" withString:@""];
    fileName = [fileName stringByReplacingOccurrencesOfString:@":" withString:@""];
    fileName = [fileName stringByReplacingOccurrencesOfString:@";" withString:@""];
    fileName = [fileName stringByReplacingOccurrencesOfString:@"," withString:@""];
    fileName = [fileName stringByReplacingOccurrencesOfString:@"." withString:@""];
    fileName = [fileName stringByReplacingOccurrencesOfString:@"-" withString:@""];
    fileName = [fileName stringByReplacingOccurrencesOfString:@"+" withString:@""];
    fileName = [fileName stringByReplacingOccurrencesOfString:@"(" withString:@""];
    fileName = [fileName stringByReplacingOccurrencesOfString:@")" withString:@""];
    fileName = [fileName stringByReplacingOccurrencesOfString:@" " withString:@""];
    self.fontName = [NSString stringWithFormat:@"%@%@", fileName, self.fontSize];
    
    [self generateDescription];
}

- (void)generateDescription{
    self.fontDescription = [NSString stringWithFormat:@"This is the %@ font, size %@", 
                            self.fontFile, 
                            self.fontSize];
}

@end
