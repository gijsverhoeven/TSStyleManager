//
//  GeneratedExtensions.m
//  This file is generated by the TSStyleManager application
//  http://www.touchwonders.com
//  Generation date: Feb 12, 2012 17:13:04 
//

#import "GeneratedExtensions.h"

/** UIColor extension */
@implementation UIColor (_StyleExtension)

+(UIColor *)Greenish{
	return [UIColor colorWithRed:0.078431 green:0.784314 blue:0.196078 alpha:1.000000];
}

+(UIColor *)DarkRed{
	return [UIColor colorWithRed:0.470588 green:0.090196 blue:0.074510 alpha:1.000000];
}

+(UIColor *)DarkGray{
	return [UIColor colorWithRed:0.078431 green:0.078431 blue:0.078431 alpha:1.000000];
}

@end

/** UIFont extension */
@implementation UIFont (_StyleExtension)

+(UIFont *)Zapfino35{
	NSString *fontName = @"Zapfino";
	int size = 35;
	UIFont *font = [UIFont fontWithName:fontName size:size];
	if(font == nil)
		 font = [UIFont searchForAlternativesWithName:fontName andSize:size];
	return font;
}

+(UIFont *)CalibriItalic40{
	NSString *fontName = @"Calibri Italic";
	int size = 40;
	UIFont *font = [UIFont fontWithName:fontName size:size];
	if(font == nil)
		 font = [UIFont searchForAlternativesWithName:fontName andSize:size];
	return font;
}

+(UIFont *)MyriadProRegular33{
	NSString *fontName = @"MyriadPro-Regular";
	int size = 33;
	UIFont *font = [UIFont fontWithName:fontName size:size];
	if(font == nil)
		 font = [UIFont searchForAlternativesWithName:fontName andSize:size];
	return font;
}

+(UIFont *)searchForAlternativesWithName:(NSString *)fontName andSize:(int)size{
    NSLog(@"TSStyleManager: Font with name %@ not found", fontName);
    NSString *spacesToDashes = [fontName stringByReplacingOccurrencesOfString:@" " withString:@"-"];
    NSLog(@"...Trying %@", spacesToDashes);
    UIFont *font = [UIFont fontWithName:spacesToDashes size:size];
    if(font){
        NSLog(@"...Found font %@", spacesToDashes);
        return font;
    }
    NSString *removeSpaces = [fontName stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"...Trying %@", removeSpaces);
    font = [UIFont fontWithName:removeSpaces size:size];
    if(font){
        NSLog(@"...Found font %@", removeSpaces);
        return font;
    }
    
    NSLog(@"...No substitution found for %@. Please check if the font is included in the project and in the info.plist. If it is, correct the font name to be the correct Postscript name.", fontName);
    return nil;
}

@end


/** TSShadow implementation */
@implementation TSShadow
@synthesize shadowOffset;
@synthesize shadowColor;

+(TSShadow *)WhiteRightShadow{
	TSShadow *shadow = [[TSShadow alloc] init];
	shadow.shadowColor = [UIColor colorWithRed:1.000000 green:1.000000 blue:1.000000 alpha:0.705882];
	shadow.shadowOffset = CGSizeMake(2,0);
	return shadow;
}

+(TSShadow *)WhiteTopShadow{
	TSShadow *shadow = [[TSShadow alloc] init];
	shadow.shadowColor = [UIColor colorWithRed:1.000000 green:1.000000 blue:1.000000 alpha:1.000000];
	shadow.shadowOffset = CGSizeMake(0,-2);
	return shadow;
}

+(TSShadow *)RedRightShadow{
	TSShadow *shadow = [[TSShadow alloc] init];
	shadow.shadowColor = [UIColor colorWithRed:0.784314 green:0.470588 blue:0.274510 alpha:0.784314];
	shadow.shadowOffset = CGSizeMake(2, 0);
	return shadow;
}

+(TSShadow *)DarkBottomShadow{
	TSShadow *shadow = [[TSShadow alloc] init];
	shadow.shadowColor = [UIColor colorWithRed:0.000000 green:0.000000 blue:0.000000 alpha:0.705882];
	shadow.shadowOffset = CGSizeMake(0,1);
	return shadow;
}

@end

/** TSStyle implementation */
@implementation TSStyle
@synthesize font;
@synthesize color;
@synthesize shadow;

+(TSStyle *)style1{
	TSStyle *style = [[TSStyle alloc] init];
	style.font = [UIFont MyriadProRegular33];
	style.color = [UIColor Greenish];
	style.shadow = [TSShadow DarkBottomShadow];
	return style;
}

+(TSStyle *)style2{
	TSStyle *style = [[TSStyle alloc] init];
	style.font = [UIFont CalibriItalic40];
	style.color = [UIColor DarkGray];
	style.shadow = [TSShadow WhiteRightShadow];
	return style;
}

+(TSStyle *)style3{
	TSStyle *style = [[TSStyle alloc] init];
	style.font = [UIFont Zapfino35];
	style.color = [UIColor DarkRed];
	style.shadow = [TSShadow WhiteTopShadow];
	return style;
}

@end

/** UILabel extension */
@implementation UILabel (_StyleExtension)

-(id)initWithFrame:(CGRect)frame 
          andColor:(UIColor *)color 
           andFont:(UIFont *)textFont 
         andShadow:(TSShadow *)shadow{
    self = [self initWithFrame:frame];
    self.textColor = color;
    self.font = textFont;
    self.shadowColor = shadow.shadowColor;
    self.shadowOffset = shadow.shadowOffset;
    return self;
}

-(id)initWithFrame:(CGRect)frame andStyle:(TSStyle *)style{
    return [self initWithFrame:frame andColor:style.color andFont:style.font andShadow:style.shadow];
}

@end
