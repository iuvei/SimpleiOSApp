 
#import "NetworkInterfaceMappingSingleton.h"

// 登录
#import "LoginNetRequestBean.h"
#import "LoginDomainBeanHelper.h"

// 收藏
#import "RegistNetRequestBean.h"
#import "RegistDomainBeanHelper.h"

// 我的收藏
#import "FavorListNetRequestBean.h"
#import "FavorListDomainBeanHelper.h"

@implementation NetworkInterfaceMappingSingleton
#pragma mark -
#pragma mark Singleton Implementation

// 使用 Grand Central Dispatch (GCD) 来实现单例, 这样编写方便, 速度快, 而且线程安全.
- (id)init {
  // 禁止调用 -init 或 +new
  RNAssert(NO, @"Cannot create instance of Singleton");
  
  // 在这里, 你可以返回nil 或 [self initSingleton], 由你来决定是返回 nil还是返回 [self initSingleton]
  return nil;
}

// 真正的(私有)init方法
- (id)initSingleton {
  
  if ((self = [super init])) {
    // 初始化代码
    _networkInterfaceMapping = [NSMutableDictionary dictionaryWithCapacity:20];
    
    [self initNetworkInterfaceMapping];
  }
  
  return self;
}

+ (NetworkInterfaceMappingSingleton *)sharedInstance {
  static id singletonInstance = nil;
  static dispatch_once_t pred;
  dispatch_once(&pred, ^{singletonInstance = [[self alloc] initSingleton];});
  return singletonInstance;
}

- (void)initNetworkInterfaceMapping {
  
  
  /**
   * 登录
   */
  _networkInterfaceMapping[NSStringFromClass([LoginNetRequestBean class])] = [[LoginDomainBeanHelper alloc] init];
  
  /**
   * 注册
   */
  _networkInterfaceMapping[NSStringFromClass([RegistNetRequestBean class])] = [[RegistDomainBeanHelper alloc] init];

  /**
   * 我的收藏
   */
  _networkInterfaceMapping[NSStringFromClass([FavorListNetRequestBean class])] = [[FavorListDomainBeanHelper alloc] init];
  
}
@end
