/*
 *  AMStandardMacros.h
 *
 *  Created by Mark Lilback on 7/17/2010.
 *  Copyright 2010 Agile Monks, LLC. All rights reserved.
 *
 */

#ifdef DEBUG
	#define DLog(...) NSLog(@"%s: %@", __PRETTY_FUNCTION__, [NSString stringWithFormat:__VA_ARGS__])
	#define ALog(...) [[NSAssertionHandler currentHandler] handleFailureInFunction:[NSString stringWithCString:__PRETTY_FUNCTION__ encoding:NSUTF8StringEncoding] file:[NSString stringWithCString:__FILE__ encoding:NSUTF8StringEncoding] lineNumber:__LINE__ description:__VA_ARGS__]
#else
	#define DLog(...) do { } while (0)
	#ifndef NS_BLOCK_ASSERTIONS
		#define NS_BLOCK_ASSERTIONS
	#endif
	#define ALog(...) NSLog(@"%s %@", __PRETTY_FUNCTION__, [NSString stringWithFormat:__VA_ARGS__])
#endif

#define ZAssert(condition, ...) do { if (!(condition)) { ALog(__VA_ARGS__); }} while(0)

//can be called with basically any cocoa object and checks for nil
//followed by length (if implemented) and count (if implemented)
static inline BOOL IsEmpty(id thing) { return thing == nil || ([thing respondsToSelector:@selector(length)] && [(NSData *)thing length] == 0) || ([thing respondsToSelector:@selector(count)] && [(NSArray *)thing count] == 0); }


//the following is from <http://www.mikeash.com/?page=pyblog/friday-qa-2010-12-31-c-macro-tips-and-tricks.html>

#define IDARRAY(...) (id []){ __VA_ARGS__ }
#define IDCOUNT(...) (sizeof(IDARRAY(__VA_ARGS__)) / sizeof(id))

#define ARRAY(...) [NSArray arrayWithObjects: IDARRAY(__VA_ARGS__) count: IDCOUNT(__VA_ARGS__)]

//The helper function unpacks the object array and then calls through to NSDictionary to create the dictionary:
__inline__  NSDictionary *DictionaryWithIDArray(id *array, NSUInteger count)
{
	id keys[count];
	id objs[count];
	
	for(NSUInteger i = 0; i < count; i++)
	{
		keys[i] = array[i * 2];
		objs[i] = array[i * 2 + 1];
	}
	
	return [NSDictionary dictionaryWithObjects: objs forKeys: keys count: count];
}

#define DICT(...) DictionaryWithIDArray(IDARRAY(__VA_ARGS__), IDCOUNT(__VA_ARGS__) / 2)

