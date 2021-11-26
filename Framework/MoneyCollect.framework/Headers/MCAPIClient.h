//
//  MCAPIClient.h
//  MoneyCollect
//
//  Created by 邓侃 on 2021/9/28.
//  Copyright © 2021 AsiaBill. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MCCreateCustomerParams, MCPaymentMethodParams, MCCreatePaymentParams, MCConfirmPaymentParams;

/** 请求完成返回的结果 */
typedef void(^RequestCompletionBlock)(NSDictionary * _Nullable responseObject, NSError * _Nullable error);

NS_ASSUME_NONNULL_BEGIN

@interface MCAPIClient : NSObject

/** API公钥 */
@property (nonatomic,copy) NSString *publishableKey;
/** 商户传的 IP 地址 */
@property (nonatomic,copy) NSString *customerIPAddress;


/// 创建一个单列,返回一个全局的对象
+ (instancetype)shared;




/// 设置公钥 和 商户IP地址
/// @param publishableKey 公钥
/// @param customerIPAddress IP地址
- (void)setPublishableKey:(NSString * _Nonnull)publishableKey atCustomerIPAddress:(NSString *)customerIPAddress;




/** Customer */

/// 创建客户
/// @param createCustomerParams 请求参数
/// @param completionBlock 当数据请求完成时的block回调(当错误信息为nil时,请求成功;当错误信息存在,请求失败.)
- (void)createCustomerWithParams:(MCCreateCustomerParams *)createCustomerParams completionBlock:(RequestCompletionBlock)completionBlock;




/** PaymentMethod */

/// 获取支付方式(卡列表)
/// @param customerId customerId
/// @param completionBlock 当数据请求完成时的block回调(当错误信息为nil时,请求成功;当错误信息存在,请求失败.)
- (void)getCustomersPaymentMethodsAtCustomerId:(NSString *)customerId completionBlock:(RequestCompletionBlock)completionBlock;


/// 创建支付方式
/// @param paymentMethodParams 请求参数
/// @param completionBlock 当数据请求完成时的block回调(当错误信息为nil时,请求成功;当错误信息存在,请求失败.)
- (void)createPaymentMethodWithParams:(MCPaymentMethodParams *)paymentMethodParams completionBlock:(RequestCompletionBlock)completionBlock;


/// 添加支付方式（绑卡）
/// @param customerId 客户ID
/// @param paymentMethodId 卡ID (pm_1450754500111126530)
/// @param completionBlock 当数据请求完成时的block回调(当错误信息为nil时,请求成功;当错误信息存在,请求失败.)
- (void)attachPaymentMethodToCustomer:(NSString *)customerId paymentMethod:(NSString *)paymentMethodId completionBlock:(RequestCompletionBlock)completionBlock;


/// 检索支付方式
/// @param paymentMethodId 卡ID (pm_1450754500111126530)
/// @param completionBlock 当数据请求完成时的block回调(当错误信息为nil时,请求成功;当错误信息存在,请求失败.)
- (void)retrievePaymentMethod:(NSString *)paymentMethodId completionBlock:(RequestCompletionBlock)completionBlock;




/** Payment */

/// 创建支付
/// @param createPaymentParams 请求参数
/// @param completionBlock 当数据请求完成时的block回调(当错误信息为nil时,请求成功;当错误信息存在,请求失败.)
- (void)createPaymentWithParams:(MCCreatePaymentParams *)createPaymentParams completionBlock:(RequestCompletionBlock)completionBlock;


/// 确认支付（确认付款）
/// @param confirmPaymentParams 请求参数
/// @param completionBlock 当数据请求完成时的block回调(当错误信息为nil时,请求成功;当错误信息存在,请求失败.)
- (void)confirmPaymentWithParams:(MCConfirmPaymentParams *)confirmPaymentParams completionBlock:(RequestCompletionBlock)completionBlock;


/// 检索支付（查询
/// @param paymentId paymentId (py_1450653541889875969)
/// @param clientSecret clientSecret (createPayment 接口会返回)
/// @param completionBlock 当数据请求完成时的block回调(当错误信息为nil时,请求成功;当错误信息存在,请求失败.)
- (void)retrievePayment:(NSString *)paymentId clientSecret:(NSString *)clientSecret completionBlock:(RequestCompletionBlock)completionBlock;




@end

NS_ASSUME_NONNULL_END
