//
//  AMViewController.h
//  Vyana
//
//  Created by Mark Lilback on 8/18/11.
//  Copyright 2011 Agile Monks. All rights reserved.
//

// This subclass of NSViewControllers offers the following features:
//		* keeps track of AMBlockTokens so you don't have to implement that logic
//			(see NSObject+AMBlockObservation.h)

@interface AMViewController : NSViewController {}

-(void)saveBlockToken:(id)aToken forObject:(id)obj;
-(void)releaseAllBlockTokens;

@end
