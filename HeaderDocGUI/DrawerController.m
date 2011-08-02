//
//  DrawerController.m
//  HeaderDoc GUI
//
//  Created by Nate Beatty on 8/1/11.
//  Copyright 2011 Nate Beatty. All rights reserved.
//

#import "DrawerController.h"

@implementation DrawerController

- (id)init
{
    self = [super init];
    if (self) {
        [leftDrawer setMinContentSize:NSMakeSize(100, 100)];
        [leftDrawer setMaxContentSize:NSMakeSize(400, 400)];
    }
    
    return self;
}

-(void)toggleLeftDrawer {
    NSDrawerState state = [leftDrawer state];
    if (NSDrawerOpeningState == state || NSDrawerOpenState == state) {
        [leftDrawer close];
    } else {
        [leftDrawer openOnEdge:NSMinXEdge];
    }
}

-(void)setupLeftDrawer {
    [leftDrawer setMinContentSize:NSMakeSize(100, 100)];
    [leftDrawer setMaxContentSize:NSMakeSize(400, 400)];
}

-(void)awakeFromNib {
    [self setupLeftDrawer];
}

@end
