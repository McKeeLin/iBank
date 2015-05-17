//
//  msgVC.m
//  iBank
//
//  Created by McKee on 15/5/16.
//  Copyright (c) 2015年 McKee. All rights reserved.
//

#import "msgVC.h"
#import "getMsgService.h"
#import "dataHelper.h"
#import "indicatorView.h"

@interface msgVC ()<UITableViewDataSource,UITableViewDelegate>

@property IBOutlet UITableView *tableView;

@property IBOutlet UITextView *textView;

@end

@implementation msgVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if( _msgs.count > 0 ){
        [self getMsgContent:_msgs.firstObject];
    }
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
    return [dataHelper helper].qrySystemMsgListSrv.msgs.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"msgListCell"];
    if( !cell ){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"msgListCell"];
    }
    MsgObj *msg = [_msgs objectAtIndex:indexPath.row];
    cell.textLabel.text = msg.title;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MsgObj *msg = [_msgs objectAtIndex:indexPath.row];
    if( msg.content ){
        _textView.text = msg.content;
    }
    else{
        [self getMsgContent:msg];
    }
}

- (void)getMsgContent:(MsgObj*)message
{
    __weak msgVC *weakSelf = self;
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
            weakSelf.textView.text = msg.content;
        }
    };
    [indicatorView showOnlyIndicatorAtView:self.view];
    [svr request];
}

- (IBAction)onTouchClose:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
