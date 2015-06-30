//
//  LoginViewController.m
//  SimpleiOSApp
//
//  Created by skyduck on 15/6/12.
//  Copyright (c) 2015年 Skyduck. All rights reserved.
//

#import "LoginViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "LoginManager.h"
#import "SimpleProgressBar.h"
#import "SimpleToast.h"

#import "LoginNetRequestBean.h"
#import "LoginNetRespondBean.h"

#import "RegisterViewController.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  @weakify(self);
  
  // 判断用户输入的 "用户名" 和 "密码" 是否有效的信号
  RACSignal *validUsernameSignal = [self.usernameTextField.rac_textSignal map:^id(NSString *text) {
    @strongify(self);
    return @([self isValidUsername:text]);
  }];
  
  RACSignal *validPasswordSignal = [self.passwordTextField.rac_textSignal map:^id(NSString *text) {
    @strongify(self);
    return @([self isValidPassword:text]);
  }];
  
  // 控制输入框的背景颜色(输入数据有效和无效时的背景颜色不同)
  RAC(self.usernameTextField, backgroundColor)
  = [validUsernameSignal map:^id(NSNumber *isUsernameValid) {
    return isUsernameValid.boolValue ? [UIColor clearColor] : [UIColor yellowColor];
  }];
  
  RAC(self.passwordTextField, backgroundColor)
  = [validPasswordSignal map:^id(NSNumber *isPasswordValid) {
    return isPasswordValid.boolValue ? [UIColor clearColor] : [UIColor yellowColor];
  }];

  // 控制 "登录按钮" 的 enabled 状态
  RACSignal *loginButtonEnabledSignal
  = [RACSignal combineLatest:@[validUsernameSignal, validPasswordSignal]
                      reduce:^id(NSNumber *isUsernameValid, NSNumber *isPasswordValid){
                        return @(isUsernameValid.boolValue && isPasswordValid.boolValue);
                      }];
  
  // 点击 "登录按钮" 之后的事件流
  RACCommand *loginCommand
  = [[RACCommand alloc] initWithEnabled:loginButtonEnabledSignal signalBlock:^RACSignal *(id input) {
    LoginNetRequestBean *loginNetRequestBean
    = [[LoginNetRequestBean alloc] initWithUsername:self.usernameTextField.text
                                           password:self.passwordTextField.text];
    
    // 注意 : 如果在这里直接订阅loginSignal的结果的话, 就不需要订阅loginCommand了, 但是我感觉这种做法有悖响应流的设计
    //       应该形成一个从上到下的响应流, 而不应该从中间就开始处理结果, 不过从command订阅很麻烦, 目前还没有好办法
    //       正常的流程请参考 RegisterViewController
    // 登录信号
    RACSignal *loginSignal = [[LoginManager sharedInstance] signalForLoginWithLoginNetRequestBean:loginNetRequestBean];
    [loginSignal subscribeNext:^(LoginNetRespondBean *loginNetRespondBean) {
      // 登录成功
      [SimpleToast showWithText:@"登录成功" duration:1.0];
    } error:^(NSError *error) {
      // 登录失败
      [SimpleToast showWithText:error.localizedDescription duration:1.5];
    }];
    return loginSignal;
  }];
  
  // 监控command是否正在执行中
  [loginCommand.executing subscribeNext:^(NSNumber *isExecuting) {
    if (isExecuting.boolValue) {
      [SimpleProgressBar show];
      self.registerButton.enabled = NO;
    } else {
      [SimpleProgressBar dismiss];
      self.registerButton.enabled = YES;
    }
  }];
  
  self.loginButton.rac_command = loginCommand;
  
  // 点击 "注册按钮" 之后的事件流
  [[self.registerButton rac_signalForControlEvents:UIControlEventTouchUpInside]
   subscribeNext:^(id x) {
     // 跳转 "注册界面"
     @strongify(self);
     RegisterViewController *registerViewController = [[RegisterViewController alloc] init];
     registerViewController.title = @"注册";
     [self.navigationController pushViewController:registerViewController animated:YES];
   }];
  
    
  
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (BOOL)isValidUsername:(NSString *)username {
  return username.length > 6;
}

- (BOOL)isValidPassword:(NSString *)password {
  return password.length > 6;
}

@end