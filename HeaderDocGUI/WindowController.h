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
    
    // Optional Argument Outlets
    IBOutlet NSMatrix *outputFormat;
    
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
