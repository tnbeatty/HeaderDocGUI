//
//  WindowController.h
//  HeaderDocGUI
//
//  Created by Nate Beatty on 8/1/11.
//  Copyright 2011 Nate Beatty. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DocumentationManager.h"

@interface WindowController : NSWindowController {
    
    IBOutlet NSWindow *myParentWindow;
    
    IBOutlet NSControl *inputTextField;
    IBOutlet NSControl *outputTextField;
    
    // Required Options
    IBOutlet NSButton *createSubDirectoryCheckbox;
    IBOutlet NSButton *createMasterTOCCheckbox;
    
    IBOutlet NSProgressIndicator *progressBar;
    IBOutlet NSTextField *progressText;
    
    // Optional Argument Outlets
    // Semioptional
    IBOutlet NSMatrix *outputFormat;
    // Optional
    IBOutlet NSButton *processEverythingBox;
    IBOutlet NSButton *functionListOutputBox;
    IBOutlet NSButton *unsortedBox;
    IBOutlet NSButton *doxytagsBox;
    IBOutlet NSButton *suppressLocalVariablesBox;
    
    NSString *inputURL;
    NSString *outputURL;
    
    // Drawers
    // Preset Drawer
    NSDrawer *presetsDrawer;
    // Preset Drawer Content
    
    // Activity Drawer
    NSDrawer *activityDrawer;
    // Activity Drawer Content
    NSTextView *activityTextView;
}

-(IBAction)displaySourceBrowser:(id)sender;
-(IBAction)displayDestinationBrowser:(id)sender;
-(IBAction)runDocumentation:(id)sender;

-(IBAction)togglePresetsDrawer:(id)sender;
-(IBAction)toggleActivityDrawer:(id)sender;

@end
