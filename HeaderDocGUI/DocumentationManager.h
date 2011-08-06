//
//  DocumentationManager.h
//  HeaderDocGUI
//
//  Created by Nate Beatty on 8/1/11.
//  Copyright 2011 Nate Beatty. All rights reserved.
//

/*!
 @header DocumentationManager
    @CFBundleIdentifier edu.self.HeaderDocGUI
    @encoding utf-8
 @copyright Copyright 2011 Nate Beatty. All rights reserved.
 @updated 2011-08-03
    
 */

#import <Foundation/Foundation.h>

/*!
 @protocol DocumentationManagerDelegate
 @abstract This protocol is mostly used for error handling.
 */
@protocol DocumentationManagerDelegate <NSObject>
@required

/*!
 @method invalidSourceDirectory
 */
-(void)invalidSourceDirectory;

/*!
 @method invalidDestinationDirectory
 */
-(void)invalidDestinationDirectory;

/*!
 @method someOtherError
 */
-(void)someOtherError:(NSError *)error;

@optional

/*!
 @method activityMonitorReturned:
 @abstract Returns strings that are output from the execute method.
 @discussion Use this method to display the execute output to the user. While it is impractical to attempt to parse or analyze the resulting text, it might be helpful to display on the screen.
 @param text The text output meant to be shown in an activity monitor - the result of running a task.
 */
-(void)activityMonitorReturnedOutput:(NSString *)text;

/*!
 @method updateProgress:
 @abstract Called to let the delegate know what task is about to be performed
 @discussion This method is called when a new task (like executing headerdoc2html or gatherheaderdoc) is about to be performed, and is then called once again when the task has been completed.
 @param text A description of the pending task or completion status
 */
-(void)updateProgress:(NSString *)text;

@end

/*!
 @class DocumentationManager
 @abstract A mechanism for executing headerdoc commands
 @discussion A DocumentationManager is a mechanism for executing headerdoc commands. It includes functionality for working with both "headerdoc2html" and "gatherheaderdoc" command line tools and all available arguments.
 */
@interface DocumentationManager : NSObject {
    id delegate;
    BOOL createDocumentationInSubdirectory;
    BOOL buildTOC;
    NSString *inputDirectory;
    NSString *outputDirectory;
}
/*!
 @property delegate
 @abstract Delegate
 @discussion delegate description
 */
@property (nonatomic,strong) id delegate;

/*!
 @property createDocumentationInSubDirectory
 @abstract Boolean which determines whether or not to create a sub directory to hold all documentation.
 @discussion The subdirectory created by this class is called "Documentation" by default. The default value of this property is "YES"
 */
@property (nonatomic) BOOL createDocumentationInSubDirectory;

/*!
 @property buildTOC
 @abstract Boolean - builds a table of contents of all documentation if true.
 @discussion The TOC contains links to all relevant HeaderDoc documentation within the output directory. The default value of this property is "YES"
 */
@property (nonatomic) BOOL buildTOC;

/*!
 @property inputDirectory
 @abstract The directory to search for header files
 */
@property (nonatomic,strong) NSString *inputDirectory;

/*!
 @property outputDirectory
 @abstract The directory in which the documentation will be placed and the TOC will be created.
 */
@property (nonatomic,strong) NSString *outputDirectory;

/*!
 @method documentationManagerWithInputDirectory:outputDirectory:
 @abstract Creates a new instance of a DocumentationManager with parameters
 @discussion Builds and returns a new instance of a DocumentationManager. The input and output directories are set to those given by the parameters. By default, buildTOC and createDocumentationInSubDirectory are set to YES.
 @param inDirectory The input directory
 @param outDirectory The output directory
 @result Returns the newly initialized DocumentationManager object or nil on error
 */
+(DocumentationManager *)documentationManagerWithInputDirectory:(NSString *)inDirectory outputDirectory:(NSString *)outDirectory;

/*!
 @method execute
 @abstract Creates the HeaderDoc documentation using the object's properties.
 @discussion Calls an internal "execute command" method with "headerdoc2html" and DocumentationManager object's arguments. Adds the documentation sub directory onto the output string if createDocumentationInSubDirectory == YES and calls gatherheaderdoc in the output directory if buildTOC == YES.
 */
-(void)execute;

/*!
 @method executeWithArguments:
 @abstract Same as execute but with additional special arguments
 @discussion See "execute." Calls execute with an array of special arguments along with the "headerdoc2html" command.
 @param arguments An array of optional headerdoc2html arguments
 */
-(void)executeWithArguments:(NSArray *)arguments;

@end
