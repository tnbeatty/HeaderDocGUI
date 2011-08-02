//
//  DocumentationManager.h
//  HeaderDocGUI
//
//  Created by Nate Beatty on 8/1/11.
//  Copyright 2011 Nate Beatty. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DocumentationManagerDelegate <NSObject>
@required
-(void)invalidSourceDirectory;
-(void)invalidDestinationDirectory;
-(void)someOtherError:(NSError *)error;
@optional
@end

@interface DocumentationManager : NSObject {
    
}

-(void)documentDirectory:(NSString *)inputDirectory toDirectory:(NSString *)outputDirectory;
-(void)createMasterTOCInDirectory:(NSString*)directory;

-(void)execute; // Test method

@end
