//
//  msgListVC.m
//  iBank
//
//  Created by McKee on 15/5/17.
//  Copyright (c) 2015年 McKee. All rights reserved.
//

#import "msgListVC.h"
#import "qryMsgListService.h"
#import "SendMsgService.h"
#import "getMsgService.h"
#import "dataHelper.h"
#import "indicatorView.h"

@interface msgListVC ()<UITableViewDataSource,UITableViewDelegate>
{
    UITapGestureRecognizer *_tgr;
}

@property IBOutlet UITableView *tableView;

@property IBOutlet UILabel *titleLabel;

@property IBOutlet UILabel *msgTitleLabel;

@property IBOutlet UIView *replayArea;

@property IBOutlet UILabel *timeLabel;

@property IBOutlet UITextView *msgView;

@property IBOutlet UITextView *replyView;

@property IBOutlet UIButton *replyButton;

@property IBOutlet UIScrollView *scrollView;

@property MsgObj *selectedMsg;

@property CGPoint originalOffset;

@end

@implementation msgListVC

+ (instancetype)viewController
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"msgListVC"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onViewTap:)];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _originalOffset = _scrollView.contentOffset;
    if( _msgs.count > 0 ){
        [self getMsgContent:_msgs.firstObject];
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
    return _msgs.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"msgListCell"];
    if( !cell ){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"msgListCell"];
    }
    MsgObj *msg = [_msgs objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld. %@", indexPath.row+1, msg.title];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _replyView.text = @"";
    MsgObj *msg = [_msgs objectAtIndex:indexPath.row];
    _selectedMsg = msg;
    if( msg.content ){
        [self updateMsg:msg];
    }
    else{
        [self getMsgContent:msg];
    }
}

- (IBAction)onTouchBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onTouchReply:(id)sender
{
    [_replyView resignFirstResponder];
    if( _replyView.text.length == 0 ){
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入消息内容！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [av show];
        return;
    }
    else if( _replyView.text.length > 255 ){
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"消息内容不能大于255个字符！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [av show];
        return;
    }
    
    __weak msgListVC *weakSelf = self;
    SendMsgService *srv = [[SendMsgService alloc] init];
    srv.title = [NSString stringWithFormat:@"回复:%@", _selectedMsg.title];
    srv.msg = _replyView.text;
    srv.reciverIds = [NSString stringWithFormat:@"%d", _selectedMsg.senderId];
    srv.repId = _selectedMsg.msgId;
    srv.sendMsgBlock = ^(int code, NSString *error){
        [indicatorView dismissAtView:self.view];
        if( code == 1 )
        {
            weakSelf.replyView.text = @"";
            error = @"回复消息成功！";
            for( UserObj *user in [dataHelper helper].users ){
                user.selected = NO;
            }
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


- (void)getMsgContent:(MsgObj*)message
{
    __weak msgListVC *weakSelf = self;
    __block MsgObj *msg = message;
    getMsgService *svr = [[getMsgService alloc] init];
    svr.msgId = message.msgId;
    svr.getMsgBlock = ^(int code ,id data){
        [indicatorView dismissOnlyIndicatorAtView:self.view];
        if( code == 1 ){
            MsgObj *newMsg = (MsgObj*)data;
            msg.type = newMsg.type;
            msg.state = newMsg.state;
            msg.time = newMsg.time;
            msg.title = newMsg.title;
            msg.content = newMsg.content;
            msg.sender = newMsg.sender;
            msg.senderId = newMsg.senderId;
            [weakSelf updateMsg:newMsg];
        }
    };
    [indicatorView showOnlyIndicatorAtView:self.view];
    [svr request];
}

- (void)updateMsg:(MsgObj*)msg
{
    _msgTitleLabel.text = msg.title;
    if( [msg.time isKindOfClass:[NSString class]] && msg.time.length > 0 ){
        _timeLabel.text = [NSString stringWithFormat:@"%@     发自：%@", msg.time, msg.sender];
    }
    else{
        _timeLabel.text = [NSString stringWithFormat:@"发自：%@", msg.sender];
    }
    _msgView.text = msg.content;
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
    CGRect buttonFrame = [self.view convertRect:_replyButton.bounds fromView:_replyButton];
    CGFloat yDiff = keyboardFrameSelfView.origin.y - (buttonFrame.origin.y + buttonFrame.size.height + 5);
    if( yDiff < 0 ){
        [UIView animateWithDuration:duration animations:^(){
            _scrollView.contentOffset = CGPointMake(_originalOffset.x, _originalOffset.y - yDiff);
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
    _scrollView.contentOffset = _originalOffset;
    [UIView commitAnimations];
}



- (void)onViewTap:(UITapGestureRecognizer*)tgr
{
    [_replyView resignFirstResponder];
}


@end
