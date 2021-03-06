 
#import "DeleteOrderDomainBeanHelper.h"

#import "DeleteOrderParseDomainBeanToDD.h"
#import "DeleteOrderNetRespondBean.h"

@implementation DeleteOrderDomainBeanHelper {
  id _parseNetRequestDomainBeanToDataDictionaryFunction;
}

/**
 * 将当前业务Bean, 解析成跟后台数据接口对应的数据字典
 * @return
 */
- (id<IParseNetRequestDomainBeanToDataDictionary>)parseNetRequestDomainBeanToDataDictionaryFunction {
  if (_parseNetRequestDomainBeanToDataDictionaryFunction == nil) {
    _parseNetRequestDomainBeanToDataDictionaryFunction = [[DeleteOrderParseDomainBeanToDD alloc] init];
  }
  return _parseNetRequestDomainBeanToDataDictionaryFunction;
}

/**
 * 当前业务Bean, 对应的URL地址.
 * @return
 */
- (NSString *)specialUrlPathWithNetRequestBean:(id)netRequestBean {
  return LastMinute_UrlConstant_SpecialPath_app_post_del_orderform;
}

/**
 * 当前网络响应业务Bean的Class
 * @return
 */
- (Class)netRespondBeanClass {
  return [DeleteOrderNetRespondBean class];
}

/**
 * 检查当前NetRespondBean是否有效
 * 这里的设计含义是 : 我们因为直接使用KVC, 将网络返回的数据字典直接解析成NetRespondBean, 但是这里有个隐患, 就是服务器返回的数据字典可能和本地的NetRespondBean字段不匹配, 所以每个NetRespondBean都应该设计有核心字段的概念, 只要服务器返回的数据字典包含有核心字典, 就认为本次数据有效,比如说登录接口,当登录成功后, 服务器会返回username和uid和其他一些字段, 那么uid和username就是核心字段, 只要这两个字段有效就可以认为本次网络请求有效
 * @return
 */
- (BOOL)isNetRespondBeanValidity:(in DeleteOrderNetRespondBean *)netRespondBean errorOUT:(out ErrorBean **)errorOUT {
  return YES;
}

/**
 * 考虑到后台不是同时都支持GET和POST请求, 而做的设计
 * @return GET/POST
 */
- (NSString *)httpMethod {
  return @"POST";
}
@end