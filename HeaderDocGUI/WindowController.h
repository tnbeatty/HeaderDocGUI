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
    DocumentationManager *docManager;
    
    IBOutlet NSToolbar *toolbar;
    
    IBOutlet NSControl *inputTextField;
    IBOutlet NSControl *outputTextField;
    
    IBOutlet NSButton *createSubDirectoryCheckbox;
    IBOutlet NSButton *createMasterTOCCheckbox;
    
    NSString *inputURL;
    NSString *outputURL;
}

-(IBAction)displaySourceBrowser:(id)sender;
-(IBAction)displayDestinationBrowser:(id)sender;
-(IBAction)runDocumentation:(id)sender;

//-(IBAction)drawerToggled:(id)sender;

@end
