//
//  DocumentationManager.m
//  HeaderDocGUI
//
//  Created by Nate Beatty on 8/1/11.
//  Copyright 2011 Nate Beatty. All rights reserved.
//

#import "DocumentationManager.h"

@interface DocumentationManager (InternalMethods)

-(void)executeCommand:(NSString *)command withArguments:(NSArray *)arguments;

@end

@implementation DocumentationManager

@synthesize delegate;
@synthesize createDocumentationInSubDirectory;
@synthesize buildTOC;
@synthesize inputDirectory;
@synthesize outputDirectory;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        
        // Set defaults
        self.createDocumentationInSubDirectory = YES;
        self.buildTOC = YES;
    }
    
    return self;
}

+(DocumentationManager *)documentationManagerWithInputDirectory:(NSString *)inDirectory outputDirectory:(NSString *)outDirectory {
    DocumentationManager *docManager = [[DocumentationManager alloc] init];
    
    // Set directories according to method args
    docManager.inputDirectory = inDirectory;
    docManager.outputDirectory = outDirectory;
    
    return docManager;
}

-(void)execute {
    // only execute if given a valid input and output directory
    if (inputDirectory && outputDirectory) {
        //[self executeCommand:@"open" withArguments:[NSArray arrayWithObjects: @"/users/tnbeatty/desktop", nil]];
        // New local output directory
        NSString *outputDirLocal = outputDirectory;
        
        if (createDocumentationInSubDirectory) {
            outputDirLocal = [outputDirectory stringByAppendingPathComponent:@"Documentation"];
        }
        
        [self executeCommand:@"headerdoc2html" withArguments:[NSArray arrayWithObjects: @"-o", outputDirLocal, inputDirectory, nil]];
        
        if (buildTOC) {
            [self executeCommand:@"gatherheaderdoc" withArguments:[NSArray arrayWithObjects: outputDirLocal, nil]];
        }
    }
}

-(void)executeWithArguments:(NSArray *)arguments {
    // only execute if given a valid input and output directory
    if (inputDirectory && outputDirectory) {
        //[self executeCommand:@"open" withArguments:[NSArray arrayWithObjects: @"/users/tnbeatty/desktop", nil]];
        // New local output directory
        NSString *outputDirLocal = outputDirectory;
        
        if (createDocumentationInSubDirectory) {
            outputDirLocal = [outputDirectory stringByAppendingPathComponent:@"Documentation"];
        }
        NSArray *standardArguments = [NSArray arrayWithObjects:@"-o", outputDirLocal, inputDirectory, nil];
        NSArray *combinedArguments = [arguments arrayByAddingObjectsFromArray:standardArguments];
        NSLog(@"Arguments: %@", combinedArguments);
        [self executeCommand:@"headerdoc2html" withArguments:combinedArguments];
        
        if (buildTOC) {
            [self executeCommand:@"gatherheaderdoc" withArguments:[NSArray arrayWithObjects: outputDirLocal, nil]];
        }
    }
}

@end

@implementation DocumentationManager (InternalMethods)

-(void)executeCommand:(NSString *)command withArguments:(NSArray *)arguments {
    // Executing Task
    if ([self.delegate respondsToSelector:@selector(activityMonitorReturnedOutput:)]) {
        [self.delegate activityMonitorReturnedOutput:[NSString stringWithFormat:@"\nExecuting Task...\n%@%@",command,arguments]];
    }
    
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
    string = [[NSString alloc] initWithData:data encoding: NSUTF8StringEncoding];
    
    // Output results
    if ([self.delegate respondsToSelector:@selector(activityMonitorReturnedOutput:)]) {
        [self.delegate activityMonitorReturnedOutput:string];
    }
}

@end
