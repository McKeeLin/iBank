//
//  sendMsgVC.m
//  iBank
//
//  Created by McKee on 15/5/16.
//  Copyright (c) 2015年 McKee. All rights reserved.
//

#import "sendMsgVC.h"
#import "dataHelper.h"
#import "qryUsersService.h"
#import "SendMsgService.h"
#import "indicatorView.h"
#import "userCell.h"
#import "Utility.h"
#import <QuartzCore/QuartzCore.h>

@interface sendMsgVC ()<UITableViewDataSource,UITableViewDelegate>
{
    UITapGestureRecognizer *_tgr;
}

@property IBOutlet UITableView *tableView;

@property IBOutlet UITextField *titleField;

@property IBOutlet UITextView *contentView;

@property IBOutlet UIButton *sendButton;

@property IBOutlet UIView *tableHeaderView;

@property CGRect contentViewFrame;

@property CGRect sendButtonFrame;

@end

@implementation sendMsgVC

+ (instancetype)viewController
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    sendMsgVC *vc = [storyboard instantiateViewControllerWithIdentifier:@"sendMsgVC"];
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _contentViewFrame = _contentView.frame;
    _sendButtonFrame = _sendButton.frame;
    _tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onViewTap:)];
    _contentView.layer.borderColor = [Utility colorWithRead:230 green:230 blue:230 alpha:1].CGColor;
    _contentView.layer.borderWidth = 1.0;
    _titleField.layer.borderColor = [Utility colorWithRead:230 green:230 blue:230 alpha:1].CGColor;
    _titleField.layer.borderWidth = 1.0;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.layer.borderColor = [Utility colorWithRead:230 green:230 blue:230 alpha:1].CGColor;
    _tableView.layer.borderWidth = 1.0;
    if( ![dataHelper helper].users )
    {
        [indicatorView showMessage:@"" atView:[UIApplication sharedApplication].keyWindow.rootViewController.view];
        qryUsersService *srv = [[qryUsersService alloc] init];
        srv.qryUserBlock = ^(int code, id data){
            [indicatorView dismissAtView:[UIApplication sharedApplication].keyWindow.rootViewController.view];
            if( code == 1 ){
                [dataHelper helper].users = (NSArray*)data;
                [_tableView reloadData];
            }
        };
        [srv request];
    }
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(onKeyboardFrameWillShowNotification:)
     name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(onKeyboardWillHideNotification:)
     name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataHelper helper].users.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    userCell *cell = (userCell*)[tableView dequeueReusableCellWithIdentifier:@"userCell"];
    if( !cell )
    {
        cell = [[NSBundle mainBundle] loadNibNamed:@"userCell" owner:nil options:nil].firstObject;
    }
    UserObj *user = [[dataHelper helper].users objectAtIndex:indexPath.row];
    cell.portraitView.layer.masksToBounds = YES;
    if( user.image ){
        cell.portraitView.image = user.image;
    }
    else{
        cell.portraitView.image = [UIImage imageNamed:@"default"];
    }
    if( user.selected ){
        cell.checkboxView.image = [UIImage imageNamed:@"check"];
    }
    else{
        cell.checkboxView.image = [UIImage imageNamed:@"uncheck"];
    }
    cell.userName.text = user.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UserObj *user = [[dataHelper helper].users objectAtIndex:indexPath.row];
    user.selected = !user.selected;
    userCell *cell = (userCell*)[tableView cellForRowAtIndexPath:indexPath];
    if( user.selected ){
        cell.checkboxView.image = [UIImage imageNamed:@"check"];
    }
    else{
        cell.checkboxView.image = [UIImage imageNamed:@"uncheck"];
    }
}

- (IBAction)onTouchSend:(id)sender
{
    if( _titleField.text.length == 0 ){
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入消息标题！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [av show];
        return;
    }
    else if( _titleField.text.length > 128 ){
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"消息标题不能大于128个字符！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [av show];
        return;
    }
    
    if( _contentView.text.length == 0 ){
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入消息内容！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [av show];
        return;
    }
    else if( _contentView.text.length > 255 ){
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"消息内容不能大于255个字符！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [av show];
        return;
    }
    
    NSMutableString *receivers = [[NSMutableString alloc] initWithCapacity:0];
    for( UserObj *user in [dataHelper helper].users ){
        if( user.selected ){
            if( receivers.length > 0 ){
                [receivers appendFormat:@",%d", user.userId];
            }
            else{
                [receivers appendFormat:@"%d", user.userId];
            }
        }
    }
    if( receivers.length == 0 ){
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择接收人！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [av show];
        return;
    }
    
    __weak sendMsgVC *weakSelf = self;
    SendMsgService *srv = [[SendMsgService alloc] init];
    srv.reciverIds = receivers;
    srv.title = _titleField.text;
    srv.msg = _contentView.text;
    srv.repId = -1;
    srv.sendMsgBlock = ^(int code, NSString *error){
        [indicatorView dismissAtView:self.view];
        if( code == 1 )
        {
            weakSelf.titleField.text = @"";
            weakSelf.contentView.text = @"";
            error = @"发送消息成功！";
            for( UserObj *user in [dataHelper helper].users ){
                user.selected = NO;
            }
            [weakSelf.tableView reloadData];
        }
        else{
            ;
        }
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:error delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [av show];
    };
    [indicatorView showMessage:@"正在发送消息，请稍候..." atView:self.view];
    [srv request];
}

- (IBAction)onTouchBack:(id)sender
{
    for( UserObj *user in [dataHelper helper].users ){
        user.selected = NO;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onTouchCancel:(id)sender
{
    ;
}

- (void)onKeyboardFrameWillShowNotification:(NSNotification*)notification
{
    NSLog(@"%s", __func__);
    [self.view addGestureRecognizer:_tgr];
    NSDictionary *userInfo = notification.userInfo;
    NSValue *endFrameValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    NSValue *durationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    CGRect endFrame;
    double duration;
    [endFrameValue getValue:&endFrame];
    [durationValue getValue:&duration];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGRect keyboardFrameSelfView = [window convertRect:endFrame toView:self.view];
    CGFloat yDiff = keyboardFrameSelfView.origin.y - (_sendButtonFrame.origin.y + _sendButtonFrame.size.height + 5);
    if( yDiff < 0 ){
        CGRect contentViewNewFrame = _contentViewFrame;
        contentViewNewFrame.size.height += yDiff;
        [UIView animateWithDuration:duration animations:^(){
            _sendButton.frame = CGRectOffset(_sendButtonFrame, 0, yDiff);
            _contentView.frame = contentViewNewFrame;
        }completion:^(BOOL finished){
        }];
    }
}

- (void)onKeyboardWillHideNotification:(NSNotification*)notification
{
    NSLog(@"%s", __func__);
    [self.view removeGestureRecognizer:_tgr];
    NSDictionary *userInfo = notification.userInfo;
    NSValue *endFrameValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    NSValue *durationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    CGRect endFrame;
    double duration;
    [endFrameValue getValue:&endFrame];
    [durationValue getValue:&duration];
    [UIView beginAnimations:@"keyboardWillHide" context:nil];
    [UIView setAnimationCurve:curve.unsignedIntegerValue];
    [UIView setAnimationDuration:duration];
    _contentView.frame = _contentViewFrame;
    _sendButton.frame = _sendButtonFrame;
    [UIView commitAnimations];
}



- (void)onViewTap:(UITapGestureRecognizer*)tgr
{
    [_contentView resignFirstResponder];
}

@end
