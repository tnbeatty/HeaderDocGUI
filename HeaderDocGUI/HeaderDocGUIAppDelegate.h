//
//  HeaderDocGUIAppDelegate.h
//  HeaderDocGUI
//
//  Created by Nate Beatty on 8/1/11.
//  Copyright 2011 MiddPoint. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface HeaderDocGUIAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *_window;
}

@property (strong) IBOutlet NSWindow *window;

@end
