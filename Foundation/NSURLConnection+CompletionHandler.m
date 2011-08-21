//
//  NSURLConnection+CompletionHandler.m
//  Vyana
//
//  Created by Mark Lilback on 8/21/11.
//  Copyright 2011 Agile Monks. All rights reserved.
//

#import "NSURLConnection+CompletionHandler.h"

@interface URLCompletionDelegate : NSObject {
	@private
	void (^_completionHandler)(NSData *, NSURLResponse *,  NSError *);
	BOOL _shouldCacheResponse;
	
	NSMutableData *_receivedData;
	NSURLResponse *_receivedResponse;
}

- (id)initWithCompletionHandler:(void (^)(NSData *data,
										  NSURLResponse *response,
										  NSError *error))newHandler
			shouldCacheResponse:(BOOL)shouldCache;

@end

@implementation URLCompletionDelegate

- (id)initWithCompletionHandler:(void (^)(NSData *data,
										  NSURLResponse *response,
										  NSError *error))newHandler
			shouldCacheResponse:(BOOL)shouldCache
{
	if (self = [super init]) {
		_completionHandler = Block_copy(newHandler);
		_shouldCacheResponse = shouldCache;
	}
	
	return self;
}

- (void)dealloc
{
	[_completionHandler release];
	[_receivedResponse release];
	[_receivedData release];
	[super dealloc];
}

#pragma mark NSURLConnection delegate

- (void)connection:(NSURLConnection *)connection
didReceiveResponse:(NSURLResponse *)response
{
	[response retain];
	[_receivedResponse release];
	_receivedResponse = response;
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
	_completionHandler(nil, nil, error);
	
	[_completionHandler release];
	_completionHandler = nil;
	
	[_receivedData release];
	_receivedData = nil;
	
	[_receivedResponse release];
	_receivedResponse = nil;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	if (_receivedData == nil) {
		_receivedData = [[NSMutableData alloc] initWithData:data];
	} else {
		[_receivedData appendData:data];
	}
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	_completionHandler(_receivedData, _receivedResponse, nil);
	
	[_receivedData release];
	_receivedData = nil;
	
	[_receivedResponse release];
	_receivedResponse = nil;
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
				  willCacheResponse:(NSCachedURLResponse *)cachedResponse
{
	return _shouldCacheResponse ? cachedResponse : nil;
}

#pragma mark -

@end

@implementation NSURLConnection (CompletionHandler)
+(BOOL)sendAsynchronousRequest:(NSURLRequest *)request
			shouldCacheResponse:(BOOL)shouldCache
		  withCompletionHandler:(void (^)(NSData *receivedData,
										  NSURLResponse *receivedResponse,
										  NSError *error))handler
{
	URLCompletionDelegate *delegate =
	[[URLCompletionDelegate alloc] initWithCompletionHandler:handler
										 shouldCacheResponse:shouldCache];
	
	
	NSURLConnection *connection =
	[NSURLConnection connectionWithRequest:request delegate:delegate];
	
	[delegate release];
	
	return connection != nil;
}
@end
