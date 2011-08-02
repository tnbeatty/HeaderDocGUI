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

@interface WindowController (NSTextFieldDelegate) <NSTextFieldDelegate>
@end

@interface WindowController (NSToolbarDelegate) <NSToolbarDelegate>
@end

@interface WindowController (InternalMethods)
-(void)createDocumentation;
@end

@implementation WindowController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code
        docManager = [[DocumentationManager alloc] init];
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    docManager = [[DocumentationManager alloc] init];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

#pragma mark - Button Handling

-(IBAction)displaySourceBrowser:(id)sender {
    NSOpenPanel *browser = [NSOpenPanel openPanel];
    [browser setCanChooseFiles:YES];
    [browser setCanChooseDirectories:YES];
    [browser setAllowsMultipleSelection:NO];
    [browser runModal];
    inputURL = [[[browser URLs] objectAtIndex:0] absoluteString];
    inputTextField.stringValue = inputURL;
    NSLog(@"URL: %@", inputURL);
}

-(IBAction)displayDestinationBrowser:(id)sender {
    NSOpenPanel *browser = [NSOpenPanel openPanel];
    [browser setCanChooseFiles:NO];
    [browser setCanChooseDirectories:YES];
    [browser setAllowsMultipleSelection:NO];
    [browser runModal];
    outputURL = [[[browser URLs] objectAtIndex:0] absoluteString];
    outputTextField.stringValue = outputURL;
    NSLog(@"URL: %@", outputURL);
}

-(IBAction)runDocumentation:(id)sender {
    NSLog(@"Run Doc Called");
    if (outputURL && inputURL) {
        [self createDocumentation];
    } else {
        NSLog(@"You have not entered text!");
    }
}

//-(IBAction)drawerToggled:(id)sender {
//    NSLog(@"Button Pressed");
//    [docManager execute];
//}

@end

@implementation WindowController (InternalMethods)

-(void)createDocumentation {
    NSLog(@"Create Doc Called");
//    if (createSubDirectoryCheckbox.state == NSOnState) {
//        outputURL = [outputURL stringByAppendingPathComponent:@"Documentation"];
//    }
    // Create documentation
    [docManager documentDirectory:inputURL toDirectory:outputURL];
    // Create MasterTOC if necessary
    if (createMasterTOCCheckbox.state == NSOnState) {
        [docManager createMasterTOCInDirectory:outputURL];
    }
}

- (NSToolbarItem *)toolbarItemWithIdentifier:(NSString *)identifier
                                       label:(NSString *)label
                                 paleteLabel:(NSString *)paletteLabel
                                     toolTip:(NSString *)toolTip
                                      target:(id)target
                                 itemContent:(id)imageOrView
                                      action:(SEL)action
                                        menu:(NSMenu *)menu
{
    // here we create the NSToolbarItem and setup its attributes in line with the parameters
    NSToolbarItem *item = [[NSToolbarItem alloc] initWithItemIdentifier:identifier];
    
    [item setLabel:label];
    [item setPaletteLabel:paletteLabel];
    [item setToolTip:toolTip];
    [item setTarget:target];
    [item setAction:action];
    
    // Set the right attribute, depending on if we were given an image or a view
    if([imageOrView isKindOfClass:[NSImage class]]){
        [item setImage:imageOrView];
    } else if ([imageOrView isKindOfClass:[NSView class]]){
        [item setView:imageOrView];
    }else {
        assert(!"Invalid itemContent: object");
    }
    
    
    // If this NSToolbarItem is supposed to have a menu "form representation" associated with it
    // (for text-only mode), we set it up here.  Actually, you have to hand an NSMenuItem
    // (not a complete NSMenu) to the toolbar item, so we create a dummy NSMenuItem that has our real
    // menu as a submenu.
    //
    if (menu != nil)
    {
        // we actually need an NSMenuItem here, so we construct one
        NSMenuItem *mItem = [[NSMenuItem alloc] init];
        [mItem setSubmenu:menu];
        [mItem setTitle:label];
        [item setMenuFormRepresentation:mItem];
    }
    
    return item;
}

@end

@implementation WindowController (DocumentationManagerDelegate)

-(void)invalidSourceDirectory {
    
}

-(void)invalidDestinationDirectory {
    
}

-(void)someOtherError:(NSError *)error {
    
}

@end

@implementation WindowController (NSToolbarDelegate)

- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSString *)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag
{
    NSToolbarItem *toolbarItem = nil;
    NSLog(@"Adding toolbar item");
    if ([itemIdentifier isEqualToString:kPlayIconToolbarItemID]) {
        toolbarItem = [self toolbarItemWithIdentifier:kPlayIconToolbarItemID
                                                label:@"Run"
                                          paleteLabel:@"Run"
                                              toolTip:@"Run the Documentation Tool"
                                               target:self
                                          itemContent:[NSImage imageNamed:@"Play-Icon.png"]
                                               action:@selector(runDocumentation:)
                                                 menu:nil];
    }  
    
    return toolbarItem;
}

- (NSArray *)toolbarDefaultItemIdentifiers:(NSToolbar *)toolbar
{
    return [NSArray arrayWithObjects: kPlayIconToolbarItemID, nil];
}

- (NSArray *)toolbarAllowedItemIdentifiers:(NSToolbar *)toolbar
{
    return [NSArray arrayWithObjects: kPlayIconToolbarItemID, nil];
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