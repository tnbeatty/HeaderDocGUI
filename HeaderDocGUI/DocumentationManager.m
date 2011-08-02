//
//  DocumentationManager.m
//  HeaderDocGUI
//
//  Created by Nate Beatty on 8/1/11.
//  Copyright 2011 Nate Beatty. All rights reserved.
//

#import "DocumentationManager.h"

@interface DocumentationManager (InternalMethods)

-(NSString *)executeCommand:(NSString *)command withArguments:(NSArray *)arguments;

@end

@implementation DocumentationManager

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(void)documentDirectory:(NSString *)inputDirectory toDirectory:(NSString *)outputDirectory {
    NSLog(@"Run Document Directory Called");
    [self executeCommand:@"headerdoc2html" withArguments:[NSArray arrayWithObjects: @"-o", outputDirectory, inputDirectory, nil]];
}

-(void)createMasterTOCInDirectory:(NSString*)directory {
    [self executeCommand:@"gatherheaderdoc" withArguments:[NSArray arrayWithObjects: directory, nil]];
}

-(void)execute {
    [self executeCommand:@"open" withArguments:[NSArray arrayWithObjects: @"/users/tnbeatty/desktop", nil]];
}

@end

@implementation DocumentationManager (InternalMethods)

-(NSString *)executeCommand:(NSString *)command withArguments:(NSArray *)arguments {
    NSTask *task;
    task = [[NSTask alloc] init];
    [task setLaunchPath: [@"/usr/bin" stringByAppendingPathComponent:command]];
    
    [task setArguments: arguments];
    
    NSPipe *pipe;
    pipe = [NSPipe pipe];
    [task setStandardOutput: pipe];
    
    NSFileHandle *fileHandle;
    fileHandle = [pipe fileHandleForReading];
    
    [task launch];
    
    NSData *data;
    data = [fileHandle readDataToEndOfFile];
    
    NSString *string;
    string = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
    NSLog (@"headerdoc2html returned:\n%@", string);
    
    return string;
}

@end
