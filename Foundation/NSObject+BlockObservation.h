//
//  NSObject+BlockObservation.h
//  Version 1.0
//
//  Andy Matuschak
//  andy@andymatuschak.org
//  Public domain because I love you. Let me know how you use it.
//

typedef NSString AMBlockToken;
typedef void (^AMBlockTask)(id obj, NSDictionary *change);

@interface NSObject (AMBlockObservation)

/// @name KVO via Blocks

/// Registers a block to be executed when KVO is fired on a key path.
///
///@param keyPath The key path to observe on this object
///@param task The block to execute when KVO is fired for keyPath. Should take the arguments (id obj, NSDictionary *change)
///@returns A token object. When the token is released, the task will be unregistered from KVO.
- (AMBlockToken *)addObserverForKeyPath:(NSString *)keyPath task:(AMBlockTask)task;

/// Registers a block to be executed when KVO is fired on a key path.
///
///@param keyPath The key path to observe on this object
///@param queue The queue to schedule the block on
///@param task The block to execute when KVO is fired for keyPath. Should take the arguments (id obj, NSDictionary *change)
///@returns A token object. When the token is released, the task will be unregistered from KVO.
- (AMBlockToken *)addObserverForKeyPath:(NSString *)keyPath onQueue:(NSOperationQueue *)queue task:(AMBlockTask)task;

/// Unregisters an observer associated with a token
///
/// All block tokens must be removed or standard KVO exceptions will be thrown.
/// @param token A block token returned from addObserverForKeyPath:task: or addObserverForKeyPath:onQueue:task:
- (void)removeObserverWithBlockToken:(AMBlockToken *)token;

/// Removes all block observers on this object. 
///
/// Custom objects can call this in dealloc
/// so observers don't have to call removeObserverWithBlockToken:, they can just release the token.
- (void)removeAllBlockObservers;

/// @name Storing Tokens
/// Store tokens from NSNotificationCenter using store and the unregister them all in dealloc.

///Stores a NSNotificationCenter block token for later removal.
///@param aToken a token returned from NSNotificationCenter's addObserverForName:object:queue:usingBlock:
- (void)storeNotificationToken:(id)aToken;
///Removes all NSNotificationCenter tokens stored via storeNotificationToken: Useful to call in dealloc
- (void)unregisterAllNotificationTokens;
@end
