//
//  NSURLConnection+CompletionHandler.h
//  Vyana
//
//  Created by Mark Lilback on 8/21/11.
//  Copyright 2011 Agile Monks. All rights reserved.
//

// based on <https://gist.github.com/1095187> by Michael Sanders


#import <Foundation/Foundation.h>

@interface NSURLConnection (CompletionHandler)
//
// Performs an asynchronous load of the specified URL, and invokes the given
// block upon completion or error.
//
// Returns true if the connection was created successfully.
//
+(BOOL)sendAsynchronousRequest:(NSURLRequest *)request
            shouldCacheResponse:(BOOL)shouldCache
          withCompletionHandler:(void (^)(NSData *receivedData,
                                          NSURLResponse *receivedResponse,
                                          NSError *error))handler;
@end
