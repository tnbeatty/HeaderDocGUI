//
//  DrawerController.h
//  HeaderDoc GUI
//
//  Created by Nate Beatty on 8/1/11.
//  Copyright 2011 Nate Beatty. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DrawerController : NSObject <NSDrawerDelegate> {
    IBOutlet NSWindow *myParentWindow;
    IBOutlet NSDrawer *leftDrawer;
}

-(void)toggleLeftDrawer;

@end
