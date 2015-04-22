//
//  UICKeyChainStore.h
//  UICKeyChainStore
//
//

#import <Foundation/Foundation.h>

/**
 *  KeyChain操作类
 */
@interface UICKeyChainStore : NSObject

/**
 *  服务
 */
@property (nonatomic, readonly) NSString *service;

/**
 *  分组
 */
@property (nonatomic, readonly) NSString *accessGroup;

/**
 *  默认服务标识
 *
 *  @return 默认服务标识
 */
+ (NSString *)defaultService;

/**
 *  设置默认服务
 *
 *  @param defaultService 服务标识
 */
+ (void)setDefaultService:(NSString *)defaultService;

/**
 *  获取单例对象
 *
 *  @return UICKeyChainStore对象
 */
+ (UICKeyChainStore *)keyChainStore;

/**
 *  指定服务的单例对象
 *
 *  @param service 服务标识
 *
 *  @return UICKeyChainStore对象
 */
+ (UICKeyChainStore *)keyChainStoreWithService:(NSString *)service;

/**
 *  指定服务、分组的单例对象
 *
 *  @param service     服务
 *  @param accessGroup 分组
 *
 *  @return UICKeyChainStore对象
 */
+ (UICKeyChainStore *)keyChainStoreWithService:(NSString *)service accessGroup:(NSString *)accessGroup;

/**
 *  初始化
 *
 *  @return UICKeyChainStore对象
 */
- (instancetype)init;

/**
 *  用指定服务初始化
 *
 *  @param service 服务标识
 *
 *  @return UICKeyChainStore对象
 */
- (instancetype)initWithService:(NSString *)service;

/**
 *  指定服务、分组初始化
 *
 *  @param service     服务标识
 *  @param accessGroup 分组
 *
 *  @return UICKeyChainStore对
 */
- (instancetype)initWithService:(NSString *)service accessGroup:(NSString *)accessGroup;

/**
 *  从keychain获取字符串
 *
 *  @param key 关键字
 *
 *  @return 关键字对应的字符串
 */
+ (NSString *)stringForKey:(NSString *)key;

/**
 *  指定服务，从keychain获取字符串
 *
 *  @param key     关键字
 *  @param service 服务标识
 *
 *  @return 对应的字符串
 */
+ (NSString *)stringForKey:(NSString *)key service:(NSString *)service;

/**
 *  指定服务、分组，从keychain获取字符串
 *
 *  @param key         关键字
 *  @param service     服务标识
 *  @param accessGroup 分组
 *
 *  @return 对应的字符串
 */
+ (NSString *)stringForKey:(NSString *)key service:(NSString *)service accessGroup:(NSString *)accessGroup;

/**
 *  保存字符串到keyChain
 *
 *  @param value 字符串
 *  @param key   关键字
 *
 *  @return YES/NO
 */
+ (BOOL)setString:(NSString *)value forKey:(NSString *)key;

/**
 *  指定服务，保存字符串到keyChain
 *
 *  @param value   字符串
 *  @param key     关键字
 *  @param service 服务标识
 *
 *  @return YES/NO
 */
+ (BOOL)setString:(NSString *)value forKey:(NSString *)key service:(NSString *)service;

/**
 *  指定服务、分组，保存字符串到keyChain
 *
 *  @param value       字符串
 *  @param key         关键字
 *  @param service     服务标识
 *  @param accessGroup 分组
 *
 *  @return YES/NO
 */
+ (BOOL)setString:(NSString *)value forKey:(NSString *)key service:(NSString *)service accessGroup:(NSString *)accessGroup;

/**
 *  从keyChain获取NSData对象
 *
 *  @param key 关键字
 *
 *  @return NSData对象
 */
+ (NSData *)dataForKey:(NSString *)key;

/**
 *  指定服务，从keyChain获取NSData对象
 *
 *  @param key     关键字
 *  @param service 服务标识
 *
 *  @return NSData对象
 */
+ (NSData *)dataForKey:(NSString *)key service:(NSString *)service;

/**
 *  指定服务、分组，从keyChain获取NSData对象
 *
 *  @param key         关键字
 *  @param service     服务标识
 *  @param accessGroup 分组
 *
 *  @return NSData对象
 */
+ (NSData *)dataForKey:(NSString *)key service:(NSString *)service accessGroup:(NSString *)accessGroup;

/**
 *  保存NSData对象到keyChain
 *
 *  @param data NSData对象
 *  @param key  关键字
 *
 *  @return YES/NO
 */
+ (BOOL)setData:(NSData *)data forKey:(NSString *)key;

/**
 *  指定服务，保存NSData对象到keyChain
 *
 *  @param data    NSData对象
 *  @param key     关键字
 *  @param service 服务标识
 *
 *  @return YES/NO
 */
+ (BOOL)setData:(NSData *)data forKey:(NSString *)key service:(NSString *)service;


/**
 *  指定服务、分组，保存NSData对象到keyChain
 *
 *  @param data        NSData对象
 *  @param key         关键字
 *  @param service     服务标识
 *  @param accessGroup 分组
 *
 *  @return YES/NO
 */
+ (BOOL)setData:(NSData *)data forKey:(NSString *)key service:(NSString *)service accessGroup:(NSString *)accessGroup;

/**
 *  保存字符串到keychain
 *
 *  @param string  字符串
 *  @param key    关键字
 */
- (void)setString:(NSString *)string forKey:(NSString *)key;

/**
 *  从keychain获取字符串
 *
 *  @param key 关键字
 *
 *  @return 对应的字符串
 */
- (NSString *)stringForKey:(NSString *)key;

/**
 *  保存NSData到keyChain
 *
 *  @param data 数据对象
 *  @param key  关键字
 */
- (void)setData:(NSData *)data forKey:(NSString *)key;

/**
 *  从keyChain获取NSData对象
 *
 *  @param key 关键字
 *
 *  @return 对应的NSData
 */
- (NSData *)dataForKey:(NSString *)key;

/**
 *  从keyChain删除数据
 *
 *  @param key 关键字
 *
 *  @return YES/NO
 */
+ (BOOL)removeItemForKey:(NSString *)key;

/**
 *  指定服务，从keyChain删除数据
 *
 *  @param key     关键字形
 *  @param service 服务标识
 *
 *  @return YES/NO
 */
+ (BOOL)removeItemForKey:(NSString *)key service:(NSString *)service;

/**
 *  指定服务、分组，从keyChain删除数据
 *
 *  @param key         关键字形
 *  @param service     服务标识
 *  @param accessGroup 分组
 *
 *  @return YES/NO
 */
+ (BOOL)removeItemForKey:(NSString *)key service:(NSString *)service accessGroup:(NSString *)accessGroup;

/**
 *  从keyChain删除所有数据
 *
 *  @return YES/NO
 */
+ (BOOL)removeAllItems;

/**
 *  删除指定服务的所有数据
 *
 *  @param service 服务标识
 *
 *  @return YES/NO
 */
+ (BOOL)removeAllItemsForService:(NSString *)service;

/**
 *  删除指定服务、分组的所有数据
 *
 *  @param service     服务标识
 *  @param accessGroup 分组
 *
 *  @return YES/NO
 */
+ (BOOL)removeAllItemsForService:(NSString *)service accessGroup:(NSString *)accessGroup;

/**
 *  删除某一项数据
 *
 *  @param key 关键字
 */
- (void)removeItemForKey:(NSString *)key;

/**
 *  删除所有数据
 */
- (void)removeAllItems;

/**
 *  同步
 */
- (void)synchronize;

@end
