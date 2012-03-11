//
//  AMODBEditor.h
//  Vyana
//
//  Created by Mark Lilback on 1/15/12.
//  Copyright (c) 2012 Agile Monks. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol AMODBEditorClient;

/** 
 @class AMODBEditor
 @brief Allows editing of text in an application that supports the ODB Editor Apple Event suite

 based on code from <http://gusmueller.com/odb/>
 */

@interface AMODBEditor : NSObject
+(id)sharedEditor;

@property (nonatomic, copy) NSString *editorBundleIdentifier;
@property (nonatomic, copy) NSString *tempFilePrefix;

-(void)abortEditingFile:(NSString*)path;
-(void)abortAllEditingSessionsForClient:(id)client;

-(BOOL)editFile:(NSString*)path 
   displayTitle:(NSString*)displayTitle
	  forClient:(id<AMODBEditorClient>)client 
		context:(NSDictionary*)context;

-(BOOL)editString:(NSString*)string 
	 displayTitle:(NSString*)displayTitle
		forClient:(id<AMODBEditorClient>)client 
		  context:(NSDictionary*)context;
@end

@protocol AMODBEditorClient <NSObject>
-(void)odbEditor:(AMODBEditor*)editor 
   didModifyFile:(NSString*)oldPath 
	 newLocation:(NSString*)newPath 
		 context:(NSDictionary*)context;

-(void)odbEditor:(AMODBEditor*)editor  
	didCloseFile:(NSString*)path 
		 context:(NSDictionary*)context;

-(void)odbEditor:(AMODBEditor*)editor 
 didModifyString:(NSString*)modifiedString 
		 context:(NSDictionary*)context;

-(void)odbEditor:(AMODBEditor*)editor 
   didFinishEdit:(NSString*)modifiedString 
		 context:(NSDictionary*)context;

@end