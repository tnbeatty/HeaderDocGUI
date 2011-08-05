//
//  WindowController.m
//  HeaderDocGUI
//
//  Created by Nate Beatty on 8/1/11.
//  Copyright 2011 Nate Beatty. All rights reserved.
//

#import "WindowController.h"

#define kPlayIconToolbarItemID @"RunDocumentation"

@interface WindowController (DocumentationManagerDelegate) <DocumentationManagerDelegate>
-(void)invalidSourceDirectory;
-(void)invalidDestinationDirectory;
-(void)someOtherError:(NSError *)error;
@end

@interface WindowController (NSDrawerDelegate) <NSDrawerDelegate>
@end

@interface WindowController (NSTextFieldDelegate) <NSTextFieldDelegate>
@end

@interface WindowController (InternalMethods)
-(void)createDocumentation;
-(void)setupPresetsDrawer;
-(void)setupActivityDrawer;
-(NSArray *)gatherAdditionalArguments;
@end

@implementation WindowController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code
    }
    
    return self;
}

- (void)awakeFromNib {
    // Create drawers
    [self setupPresetsDrawer];
    [self setupActivityDrawer];
    
    // Set initial progress bar stati
    [progressBar stopAnimation:nil];
    [progressBar setDisplayedWhenStopped:NO];
}

#pragma mark - Button Handling

-(IBAction)displaySourceBrowser:(id)sender {
    NSOpenPanel *browser = [NSOpenPanel openPanel];
    [browser setCanChooseFiles:YES];
    [browser setCanChooseDirectories:YES];
    [browser setAllowsMultipleSelection:NO];
    [browser runModal];
    inputURL = [[[browser URLs] objectAtIndex:0] relativePath];
    inputTextField.stringValue = inputURL;
    NSLog(@"URL: %@", inputURL);
}

-(IBAction)displayDestinationBrowser:(id)sender {
    NSOpenPanel *browser = [NSOpenPanel openPanel];
    [browser setCanChooseFiles:NO];
    [browser setCanChooseDirectories:YES];
    [browser setAllowsMultipleSelection:NO];
    [browser runModal];
    outputURL = [[[browser URLs] objectAtIndex:0] relativePath];
    outputTextField.stringValue = outputURL;
    NSLog(@"URL: %@", outputURL);
}

-(IBAction)runDocumentation:(id)sender {
    NSLog(@"Run Doc Called");
    if (outputURL && inputURL) {
        [self createDocumentation];
    } else {
        NSString *alertText = @"Please enter valid source and destination directories.";
        NSAlert *alert = [NSAlert alertWithMessageText:@"Invalid directories entered"
                                         defaultButton:nil 
                                       alternateButton:nil 
                                           otherButton:nil 
                             informativeTextWithFormat:alertText];
        [alert runModal];
    }
}

-(IBAction)togglePresetsDrawer:(id)sender {
    NSLog(@"Toggling Drawer");
    NSDrawerState state = [presetsDrawer state];
    if (NSDrawerOpeningState == state || NSDrawerOpenState == state) {
        NSLog(@"Closing Drawer");
        [presetsDrawer close];
    } else {
        NSLog(@"Opening Drawer");
        [presetsDrawer openOnEdge:NSMaxXEdge];
    }
}

-(IBAction)toggleActivityDrawer:(id)sender {
    NSLog(@"Toggling Drawer");
    NSDrawerState state = [activityDrawer state];
    if (NSDrawerOpeningState == state || NSDrawerOpenState == state) {
        NSLog(@"Closing Drawer");
        [activityDrawer close];
    } else {
        NSLog(@"Opening Drawer");
        [activityDrawer openOnEdge:NSMinYEdge];
    }
}

@end

@implementation WindowController (InternalMethods)

-(NSArray *)gatherAdditionalArguments {
    NSMutableArray *args = [[NSMutableArray alloc] init];
    if (outputFormat.selectedRow == 1) {
        [createMasterTOCCheckbox setState:NSOffState];
        NSLog(@"XML Selected");
        [args addObject:@"-X"];
    }
    return args;
}

-(void)createDocumentation {
    NSLog(@"Create Doc Called");
    DocumentationManager *docsManager = [DocumentationManager documentationManagerWithInputDirectory:inputURL outputDirectory:outputURL];
    docsManager.createDocumentationInSubDirectory = [createSubDirectoryCheckbox state];
    docsManager.buildTOC = [createMasterTOCCheckbox state];
    docsManager.delegate = self;
    NSArray *optionalArgs = [self gatherAdditionalArguments];
    if (optionalArgs.count > 0) {
        NSLog(@"Executing with Options");
        [docsManager executeWithArguments:optionalArgs];
    } else {
        NSLog(@"Executing without Options");
        [docsManager execute];
    }
    docsManager = nil;
}

#pragma mark - Drawer Handling

-(void)setupPresetsDrawer {
    NSSize contentSize = NSMakeSize(100, 100);
    presetsDrawer = [[NSDrawer alloc] initWithContentSize:contentSize preferredEdge:NSMaxXEdge];
    [presetsDrawer setParentWindow:myParentWindow];
    [presetsDrawer setDelegate:self];
    [presetsDrawer setMinContentSize:contentSize];
    [presetsDrawer setMaxContentSize:contentSize];
}

-(void)setupActivityDrawer {
    NSSize contentSize = NSMakeSize(640, 200);
    activityDrawer = [[NSDrawer alloc] initWithContentSize:contentSize preferredEdge:NSMinYEdge];
    [activityDrawer setParentWindow:myParentWindow];
    [activityDrawer setDelegate:self];
    [activityDrawer setMaxContentSize:contentSize];
    [activityDrawer setMinContentSize:contentSize];
    
    // Create Content
    activityTextView = [[NSTextView alloc] initWithFrame:NSRectFromCGRect(CGRectMake(0, 0, 640, 200))];
    //[activityTextView setAllowedInputSourceLocales:[NSArray arrayWithObjects: self, nil]];
    //[activityTextView setSelectable:NO];
    NSScrollView *scroll = [[NSScrollView alloc] initWithFrame:[activityDrawer.contentView frame]];
    [scroll setBorderType:NSGrooveBorder];
    [scroll setHasHorizontalScroller:NO];
    [scroll setHasVerticalScroller:YES];
    [scroll setDocumentView:activityTextView];
    [[activityDrawer contentView] addSubview:scroll];
}

@end

@implementation WindowController (NSDrawerDelegate)


@end

@implementation WindowController (DocumentationManagerDelegate)

-(void)invalidSourceDirectory {
    
}

-(void)invalidDestinationDirectory {
    
}

-(void)someOtherError:(NSError *)error {
    NSAlert *alert = [NSAlert alertWithError:error];
    [alert runModal];
    
}

-(void)activityMonitorReturnedOutput:(NSString *)text {
    [activityTextView insertText:text];
}

@end

@implementation WindowController (NSTextFieldDelegate)

-(BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor {
    if (control.tag == 1) {
        NSLog(@"Text entered in field 1: %@", fieldEditor.string);
        inputURL = fieldEditor.string;
    } else if (control.tag == 2) {
        NSLog(@"Text entered in field 2: %@", fieldEditor.string);
        outputURL = fieldEditor.string;
    } else {
        return NO;
    }
    
    return YES;
}

@end