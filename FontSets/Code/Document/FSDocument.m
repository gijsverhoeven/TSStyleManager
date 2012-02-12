//
//  FSDocument.m
//  FontSets
//
//  Created by Daan on 1/22/12.
//  Copyright (c) 2012 Touchwonders B.V.. All rights reserved.
//

#import "FSDocument.h"
#import "FSFont.h"
#import "FSColor.h"
#import "FSStyle.h"
#import "FSShadow.h"

@interface FSDocument (_Private)
/** Respond to the fact that a row will be removed */
-(void)willRemoveRow;
/** Respond to the fact that a cell is double clicked. Used for opening the fontwindow. */
-(IBAction)doubleClickedCell:(id)sender;
@end

@implementation FSDocument
@synthesize styles, fonts, colors, shadows;
@synthesize previewTextField, tabView;
@synthesize stylesTableView, fontsTableView, colorsTableView, shadowsTableView;
@synthesize stylesArrayController, fontsArrayController, colorsArrayController, shadowsArrayController;

#pragma mark - Initialization
- (id)init{
    self = [super init];
    if (self) {
        self.styles = [[NSMutableArray alloc] init];
        self.fonts = [[NSMutableArray alloc] init];
        self.colors = [[NSMutableArray alloc] init];
        self.shadows = [[NSMutableArray alloc] init];
        
        // subscribe to notifications
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tableViewSelectionDidChange:) name:@"tableViewSelectionDidChange" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tableViewSelectionDidChange:) name:kNotificationDidChangeFont object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willRemoveRow) name:kNotificationWillRemoveRow object:nil];
        
        // update preview after a short delay
        double delayInSeconds = 0.1;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self selectionDidChange:self.stylesTableView];
            [self.fontsTableView setDoubleAction:@selector(doubleClickedCell:)];
        });
        
    }
    return self;
}


-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if(self){
        self.styles = [aDecoder decodeObjectForKey:@"styles"];
        self.fonts = [aDecoder decodeObjectForKey:@"fonts"];
        self.colors = [aDecoder decodeObjectForKey:@"colors"];
        self.shadows = [aDecoder decodeObjectForKey:@"shadows"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.styles forKey:@"styles"];
    [aCoder encodeObject:self.fonts forKey:@"fonts"];
    [aCoder encodeObject:self.colors forKey:@"colors"];
    [aCoder encodeObject:self.shadows forKey:@"shadows"];
}

#pragma mark - TableView Datasource

/**
 *  We need to use a datasource for some of tableColumns, because we want to do some value checking.
 *  For example, only numerical data is valid in color columns and the font size. Also, color values are clamped
 *  to the range [0, 255]. To my knowledge, this is not possible with cocoa bindings. The rest of the data (names, comments, etc)
 *  is delivered to the tableviews using cocoa bindings.
 *  Also, we use it for the styles tab so we actually set the object properties instead of just object.name
 */

-(id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    id returnValue = nil;

    // styles tab
    if([tableColumn.identifier isEqualToString:kStylesTabFontColumn]){
        FSStyle *style = [self.styles objectAtIndex:row];
        returnValue = style.font.fontName;
    }
    if([tableColumn.identifier isEqualToString:kStylesTabColorColumn]){
        FSStyle *style = [self.styles objectAtIndex:row];
        returnValue = style.color.name;
    }
    if([tableColumn.identifier isEqualToString:kStylesTabShadowsColumn]){
        FSStyle *style = [self.styles objectAtIndex:row];
        returnValue = style.shadow.name;
    }
    
    // color tab
    if([tableColumn.identifier isEqualToString:kColorTabRedColumn]){
        FSColor *color = [self.colors objectAtIndex:row];
        returnValue = color.red;
    }
    if([tableColumn.identifier isEqualToString:kColorTabGreenColumn]){
        FSColor *color = [self.colors objectAtIndex:row];
        returnValue = color.green;
    }
    if([tableColumn.identifier isEqualToString:kColorTabBlueColumn]){
        FSColor *color = [self.colors objectAtIndex:row];
        returnValue = color.blue;
    }
    if([tableColumn.identifier isEqualToString:kColorTabAlphaColumn]){
        FSColor *color = [self.colors objectAtIndex:row];
        returnValue = color.alpha;
    }
    
    // shadow tab
    if([tableColumn.identifier isEqualToString:kShadowsTabRedColumn]){
        FSShadow *shadow = [self.shadows objectAtIndex:row];
        returnValue = shadow.red;
    }
    if([tableColumn.identifier isEqualToString:kShadowsTabGreenColumn]){
        FSShadow *shadow = [self.shadows objectAtIndex:row];
        returnValue = shadow.green;
    }
    if([tableColumn.identifier isEqualToString:kShadowsTabBlueColumn]){
        FSShadow *shadow = [self.shadows objectAtIndex:row];
        returnValue = shadow.blue;
    }
    if([tableColumn.identifier isEqualToString:kShadowsTabAlphaColumn]){
        FSShadow *shadow = [self.shadows objectAtIndex:row];
        returnValue = shadow.alpha;
    }
    
    // fonts tab
    if([tableColumn.identifier isEqualToString:kFontsTabSizeColumn]){
        FSFont *font = [self.fonts objectAtIndex:row];
        returnValue = font.fontSize;
    }
    
    // null placeholder
    return returnValue == nil ? @"(null)" : returnValue;
}

-(void)tableView:(NSTableView *)tableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{    
    // mark document as changed
    [self setHasUndoManager:NO];
    [self updateChangeCount:0];
    
    // styles tab (string value)
    if([tableColumn.identifier isEqualToString:kStylesTabFontColumn]){
        FSStyle *style = [self.styles objectAtIndex:row];   // find the font object by name
        for (FSFont *font in self.fonts) {
            if([font.fontName isEqualToString:object]){
                style.font = font;
            }
        }
    }
    
    if([tableColumn.identifier isEqualToString:kStylesTabColorColumn]){
        FSStyle *style = [self.styles objectAtIndex:row];   // find the color object by name
        for (FSColor *color in self.colors) {
            if([color.name isEqualToString:object]){
                style.color = color;
            }
        }
    }
    
    if([tableColumn.identifier isEqualToString:kStylesTabShadowsColumn]){
        FSStyle *style = [self.styles objectAtIndex:row];   // find the shadow object by name
        for (FSShadow *shadow in self.shadows) {
            if([shadow.name isEqualToString:object]){
                style.shadow = shadow;
            }
        }
    }
    
    // Use the number formatter to check if the string is a valid numerical input
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    NSLocale *loc = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [numberFormatter setLocale:loc];
    
    NSNumber *number = [numberFormatter numberFromString:object];
    if(!number){ // Don't set the value if it's not numerical
        // update preview and generate names
        [self selectionDidChange:nil];
        return;
    }
    
    // fonts tab (unclamped numerical value)
    if([tableColumn.identifier isEqualToString:kFontsTabSizeColumn]){
        FSFont *font = [self.fonts objectAtIndex:row];
        font.fontSize = number;
    }
    
    number = [NSNumber numberWithInt:clampColor([number intValue])];
    
    // color and shadow tabs (clamped numerical value)
    if([tableColumn.identifier isEqualToString:kColorTabRedColumn]){
        FSColor *color = [self.colors objectAtIndex:row];
        color.red = number;
    }
    if([tableColumn.identifier isEqualToString:kColorTabGreenColumn]){
        FSColor *color = [self.colors objectAtIndex:row];
        color.green = number;
    }
    if([tableColumn.identifier isEqualToString:kColorTabBlueColumn]){
        FSColor *color = [self.colors objectAtIndex:row];
        color.blue = number;
    }
    if([tableColumn.identifier isEqualToString:kColorTabAlphaColumn]){
        FSColor *color = [self.colors objectAtIndex:row];
        color.alpha = number;
    }
    
    if([tableColumn.identifier isEqualToString:kShadowsTabRedColumn]){
        FSShadow *shadow = [self.shadows objectAtIndex:row];
        shadow.red = number;
    }
    if([tableColumn.identifier isEqualToString:kShadowsTabGreenColumn]){
        FSShadow *shadow = [self.shadows objectAtIndex:row];
        shadow.green = number;
    }
    if([tableColumn.identifier isEqualToString:kShadowsTabBlueColumn]){
        FSShadow *shadow = [self.shadows objectAtIndex:row];
        shadow.blue = number;
    }
    if([tableColumn.identifier isEqualToString:kShadowsTabAlphaColumn]){
        FSShadow *shadow = [self.shadows objectAtIndex:row];
        shadow.alpha = number;
    }
    
    // update preview and generate names
    [self selectionDidChange:nil];
}

#pragma mark - TableView Delegate
- (IBAction)removeSelectedRow:(id)sender{
    if([[[self.tabView selectedTabViewItem] label] isEqualToString:@"Styles"]){
        [self.stylesArrayController remove:sender];
    }
    if([[[self.tabView selectedTabViewItem] label] isEqualToString:@"Fonts"]){
        [self.fontsArrayController remove:sender];
    }
    if([[[self.tabView selectedTabViewItem] label] isEqualToString:@"Colors"]){
        [self.colorsArrayController remove:sender];
    }
    if([[[self.tabView selectedTabViewItem] label] isEqualToString:@"Shadows"]){
        [self.shadowsArrayController remove:sender];
    }
}

-(void)willRemoveRow{
    // we need to abort editing on all our tableview, because an exception is raised when removing a row which is being edited
    [self.stylesTableView abortEditing];
    [self.fontsTableView abortEditing];
    [self.colorsTableView abortEditing];
    [self.shadowsTableView abortEditing];
}

- (IBAction)doubleClickedCell:(id)sender{
    NSTableView *tableView = sender;
    if(tableView.tag != FontTableViewTag || [tableView clickedColumn] != 0){
        if([tableView clickedColumn] == 1)  //only for font size: edit the cell
            [tableView editColumn:[tableView clickedColumn] row:[tableView clickedRow] withEvent:nil select:YES];
        return;
    }
    
    // get the shared fontmanager, set the clicked font as target, create a fontpanel and send it to front
    FSFont *selectedFont = [self.fonts objectAtIndex:[self.fontsTableView clickedRow]];
    NSFontManager *fontManager = [NSFontManager sharedFontManager];
    [fontManager setTarget:selectedFont];
    NSFontPanel *fontPanel = [fontManager fontPanel:YES];
    [fontPanel makeKeyAndOrderFront:sender];
}

-(void)tableViewSelectionDidChange:(NSNotification *)notification{
    [self selectionDidChange:[notification object]];
}

- (IBAction)selectionDidChange:(id)sender{  
    NSTableView *tableView = (NSTableView *)sender;
    if(tableView.tag == FontTableViewTag || tableView == nil){
        for (FSFont *font in self.fonts) {
            [font generateName];
        }
    }
    if(tableView.tag == StylesTableViewTag || tableView == nil){
        tableView = self.stylesTableView;
        FSStyle *style;
        if(tableView.selectedRow == -1){
            style = [FSStyle defaultStyle];
        }
        else{
            style = [self.styles objectAtIndex:tableView.selectedRow];
        }
        // font
        NSColor *textColor = [NSColor colorWithDeviceRed:[style.color.red floatValue] / 255.0 
                                                   green:[style.color.green floatValue] / 255.0  
                                                    blue:[style.color.blue floatValue] / 255.0  
                                                   alpha:[style.color.alpha floatValue] / 255.0]; 
        NSFont *font = [NSFont fontWithName:style.font.fontFile size:[style.font.fontSize intValue]];
        
        // shadow
        NSShadow *shadow = [[NSShadow alloc] init];
        NSColor *shadowColor = [NSColor colorWithDeviceRed:[style.shadow.red floatValue] / 255.0 
                                                   green:[style.shadow.green floatValue] / 255.0  
                                                    blue:[style.shadow.blue floatValue] / 255.0  
                                                   alpha:[style.shadow.alpha floatValue] / 255.0]; 
        shadow.shadowColor = shadowColor;
        NSString *offset = style.shadow.offset;
        NSArray *components = [offset componentsSeparatedByString:@","];
        NSInteger offsetX = [[components objectAtIndex:0] intValue];
        NSInteger offsetY = [[components objectAtIndex:1] intValue];
        offsetY *= -1;
        shadow.shadowOffset = CGSizeMake(offsetX, offsetY);
        shadow.shadowBlurRadius = 0.0f;
        
        // attributed string with font and shadow
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, shadow, NSShadowAttributeName, textColor, NSForegroundColorAttributeName, nil];
        NSAttributedString *shadowText = [[NSAttributedString alloc] initWithString:@"Example text" attributes:attributes];
        [self.previewTextField setStringValue:(NSString *)shadowText];
        
        // set frame big enough
        CGSize size = [[shadowText string] sizeWithAttributes:attributes];
        [self.previewTextField setFrameSize:NSMakeSize(self.previewTextField.frame.size.width, size.height)];
    }
}

-(void)tableView:(NSTableView *)tableView sortDescriptorsDidChange:(NSArray *)oldDescriptors{
    if(tableView == self.stylesTableView)
        self.styles = [[self.styles sortedArrayUsingDescriptors:tableView.sortDescriptors] mutableCopy];
    
    if(tableView == self.fontsTableView)
        self.fonts = [[self.fonts sortedArrayUsingDescriptors:tableView.sortDescriptors] mutableCopy];
    
    if(tableView == self.colorsTableView)
        self.colors = [[self.colors sortedArrayUsingDescriptors:tableView.sortDescriptors] mutableCopy];
    
    if(tableView == self.shadowsTableView)
        self.shadows = [[self.shadows sortedArrayUsingDescriptors:tableView.sortDescriptors] mutableCopy];
    
}


#pragma mark - TabView
-(void)tabView:(NSTabView *)tabView willSelectTabViewItem:(NSTabViewItem *)tabViewItem{
    // update preview and generate names
    [self selectionDidChange:nil];
}

- (void)selectTabViewItemAtIndex:(NSInteger)tabViewIndex{
    [self.tabView selectTabViewItemAtIndex:tabViewIndex];
}

#pragma mark - Read and write
- (IBAction)exportCategory:(id)sender{
    NSSavePanel *savePanel = [NSSavePanel savePanel];
    [savePanel setTitle:@"Export category"];
    [savePanel setNameFieldStringValue:@"GeneratedExtensions.h"];
    [savePanel beginWithCompletionHandler:^(NSInteger result) {
    
        /**
         *  Interface
         */
        
        NSString *saveToDir =  [[savePanel directoryURL] path];
        NSString *saveHeaderAsFile = [NSString stringWithFormat:@"%@/GeneratedExtensions.h", saveToDir];
        NSString *pathToTemplateInterface = [[NSBundle mainBundle] pathForResource:@"templateInterface" ofType:@"txt"];
        NSError *err = nil;
        NSString *interfaceAsString = [[NSString alloc] initWithContentsOfFile:pathToTemplateInterface encoding:NSUTF8StringEncoding error:&err];
        if(err)
            NSLog(@"Error reading interface template file: %@", [err localizedDescription]);
        
        // replace date placeholder
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
        NSString *date = [dateFormatter stringFromDate:[NSDate date]];
        interfaceAsString = [interfaceAsString stringByReplacingOccurrencesOfString:@"__DATE__" withString:date];
        
        // replace color interface
        NSString *colorInterface = @"";
        for (FSColor *color in self.colors) {
            colorInterface = [colorInterface stringByAppendingFormat:@"\n/** %@ */\n", color.comments];
            colorInterface = [colorInterface stringByAppendingFormat:@"+(UIColor *)%@;\n", color.name];
        }
        interfaceAsString = [interfaceAsString stringByReplacingOccurrencesOfString:@"__COLOR_INTERFACE__" withString:colorInterface];
        
        // replace font interface
        NSString *fontInterface = @"";
        for (FSFont *font in self.fonts) {
            fontInterface = [fontInterface stringByAppendingFormat:@"\n/** %@ */\n", font.fontDescription];
            fontInterface = [fontInterface stringByAppendingFormat:@"+(UIFont *)%@;\n", font.fontName];
        }
        interfaceAsString = [interfaceAsString stringByReplacingOccurrencesOfString:@"__FONT_INTERFACE__" withString:fontInterface];
        
        // replace shadow interface
        NSString *shadowInterface = @"";
        for (FSShadow *shadow in self.shadows) {
            shadowInterface = [shadowInterface stringByAppendingFormat:@"\n/** %@ */\n", shadow.comments];
            shadowInterface = [shadowInterface stringByAppendingFormat:@"+(TSShadow *)%@;\n", shadow.name];
        }
        interfaceAsString = [interfaceAsString stringByReplacingOccurrencesOfString:@"__SHADOW_INTERFACE__" withString:shadowInterface];
        
        // replace style interface
        NSString *styleInterface = @"";
        for (FSStyle *style in self.styles) {
            styleInterface = [styleInterface stringByAppendingFormat:@"\n/** %@ */\n", style.comments];
            styleInterface = [styleInterface stringByAppendingFormat:@"+(TSStyle *)%@;\n", style.name];
        }
        interfaceAsString = [interfaceAsString stringByReplacingOccurrencesOfString:@"__STYLE_INTERFACE__" withString:styleInterface];
        
        // write to file
        err = nil;
        [interfaceAsString writeToFile:saveHeaderAsFile atomically:NO encoding:NSUTF8StringEncoding error:&err];
        if(err)
            NSLog(@"Error writing interface file: %@", [err localizedDescription]);        
        
        
        /**
         *  Implementation
         */
            
        saveToDir =  [[savePanel directoryURL] path];
        NSString *saveImplementationAsFile = [NSString stringWithFormat:@"%@/GeneratedExtensions.m", saveToDir];
        NSString *pathToTemplateImplementation = [[NSBundle mainBundle] pathForResource:@"templateImplementation" ofType:@"txt"];
        err = nil;
        NSString *implementationAsString = [[NSString alloc] initWithContentsOfFile:pathToTemplateImplementation encoding:NSUTF8StringEncoding error:&err];
        if(err)
            NSLog(@"Error reading implementation template file: %@", [err localizedDescription]);
        
        // replace date placeholder
        implementationAsString = [implementationAsString stringByReplacingOccurrencesOfString:@"__DATE__" withString:date];
        
        // replace color implementation
        NSString *colorImplementation = @"";
        for (FSColor *color in self.colors) {
            colorImplementation = [colorImplementation stringByAppendingFormat:@"\n+(UIColor *)%@{\n", color.name];
            colorImplementation = [colorImplementation stringByAppendingFormat:@"\treturn [UIColor colorWithRed:%f green:%f blue:%f alpha:%f];\n}\n", [color.red floatValue] / 255.0, [color.green floatValue] / 255.0, [color.blue floatValue] / 255.0, [color.alpha floatValue] / 255.0];
        }
        implementationAsString = [implementationAsString stringByReplacingOccurrencesOfString:@"__COLOR_IMPLEMENTATION__" withString:colorImplementation];
        
        // replace font implementation
        NSString *fontImplementation = @"";
        for (FSFont *font in self.fonts) {            
            fontImplementation = [fontImplementation stringByAppendingFormat:@"\n+(UIFont *)%@{\n", font.fontName];
            fontImplementation = [fontImplementation stringByAppendingFormat:@"\tNSString *fontName = @\"%@\";\n", font.fontFile];
            fontImplementation = [fontImplementation stringByAppendingFormat:@"\tint size = %i;\n", [font.fontSize intValue]];
            fontImplementation = [fontImplementation stringByAppendingFormat:@"\tUIFont *font = [UIFont fontWithName:fontName size:size];\n", font.fontFile, [font.fontSize intValue]];
            fontImplementation = [fontImplementation stringByAppendingFormat:@"\tif(font == nil)\n\t\t font = [UIFont searchForAlternativesWithName:fontName andSize:size];\n"];
            fontImplementation = [fontImplementation stringByAppendingFormat:@"\treturn font;\n}\n"];
        }
        implementationAsString = [implementationAsString stringByReplacingOccurrencesOfString:@"__FONT_IMPLEMENTATION__" withString:fontImplementation];
        
        // replace shadow implementation
        NSString *shadowImplementation = @"";
        for (FSShadow *shadow in self.shadows) {
            shadowImplementation = [shadowImplementation stringByAppendingFormat:@"\n+(TSShadow *)%@{\n", shadow.name];
            shadowImplementation = [shadowImplementation stringByAppendingFormat:@"\tTSShadow *shadow = [[TSShadow alloc] init];\n"];
            shadowImplementation = [shadowImplementation stringByAppendingFormat:@"\tshadow.shadowColor = [UIColor colorWithRed:%f green:%f blue:%f alpha:%f];\n", [shadow.red floatValue] / 255.0, [shadow.green floatValue] / 255.0, [shadow.blue floatValue] / 255.0, [shadow.alpha floatValue] / 255.0];
            shadowImplementation = [shadowImplementation stringByAppendingFormat:@"\tshadow.shadowOffset = CGSizeMake(%@);\n", shadow.offset];
            shadowImplementation = [shadowImplementation stringByAppendingFormat:@"\treturn shadow;\n}\n"];
            
        }
        implementationAsString = [implementationAsString stringByReplacingOccurrencesOfString:@"__SHADOW_IMPLEMENTATION__" withString:shadowImplementation];

        
        // replace style implementation
        NSString *styleImplementation = @"";
        for (FSStyle *style in self.styles) {
            styleImplementation = [styleImplementation stringByAppendingFormat:@"\n+(TSStyle *)%@{\n", style.name];
            styleImplementation = [styleImplementation stringByAppendingFormat:@"\tTSStyle *style = [[TSStyle alloc] init];\n"];
            styleImplementation = [styleImplementation stringByAppendingFormat:@"\tstyle.font = [UIFont %@];\n", style.font.fontName];
            styleImplementation = [styleImplementation stringByAppendingFormat:@"\tstyle.color = [UIColor %@];\n", style.color.name];
            styleImplementation = [styleImplementation stringByAppendingFormat:@"\tstyle.shadow = [TSShadow %@];\n", style.shadow.name];
            styleImplementation = [styleImplementation stringByAppendingFormat:@"\treturn style;\n}\n"];
            
        }
        implementationAsString = [implementationAsString stringByReplacingOccurrencesOfString:@"__STYLE_IMPLEMENTATION__" withString:styleImplementation];
        
        err = nil;
        [implementationAsString writeToFile:saveImplementationAsFile atomically:NO encoding:NSUTF8StringEncoding error:&err];
        if(err)
            NSLog(@"Error writing implementation file: %@", [err localizedDescription]);
    }];
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError{
    // this class conforms to NSCoding so we can do this
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
    return data;
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError{
    FSDocument *archivedDocument = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    self.styles = archivedDocument.styles;
    self.fonts = archivedDocument.fonts;
    self.colors = archivedDocument.colors;
    self.shadows = archivedDocument.shadows;
    return YES;
}

#pragma mark - Misc
+ (BOOL)autosavesInPlace{
    return NO;
}

- (NSString *)windowNibName{
    return @"FSDocument";
}

@end
