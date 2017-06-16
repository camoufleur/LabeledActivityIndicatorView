//
//  ViewController.m
//  LabeledActivityIndicatorView
//
//  Created by fanshaohua on 10/02/2017.
//  Copyright © 2017 Camoufleur. All rights reserved.
//

#import "ViewController.h"
#import "LabeledActivityIndicatorView.h"

@interface ViewController ()

@property (nonatomic, strong) LabeledActivityIndicatorView *laiView;
@property (nonatomic, strong) LabeledActivityIndicatorView *btnLAIView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat kScreenWidth = [[UIScreen mainScreen] bounds].size.width;
    
    _laiView = [LabeledActivityIndicatorView new];
    self.navigationItem.titleView = _laiView;
    [_laiView setDescription:@"小菊花" font:[UIFont boldSystemFontOfSize:16] color:nil];
    [_laiView startRotation];
    
//    LabeledActivityIndicatorView *btnLAIView = [LabeledActivityIndicatorView new];
//    [btnLAIView setDescription:@"Loading..." font:nil color:nil];
//    [btnLAIView startRotation];
//    _btnLAIView = btnLAIView;
    
    UIButton *btnStop = [[UIButton alloc] initWithFrame:CGRectMake(0, 100, kScreenWidth, 60)];
    btnStop.backgroundColor = [UIColor lightGrayColor];
    [btnStop setTitle:@"停止转动" forState:UIControlStateNormal];
    [self.view addSubview:btnStop];
    [btnStop addTarget:self action:@selector(stopLAIViewRotation:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btnRestart = [[UIButton alloc] initWithFrame:CGRectMake(0, 200, kScreenWidth, 60)];
    btnRestart.backgroundColor = [UIColor lightGrayColor];
    [btnRestart setTitle:@"开始转动" forState:UIControlStateNormal];
    [self.view addSubview:btnRestart];
    [btnRestart addTarget:self action:@selector(restartLAIViewRotation:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btnDone = [[UIButton alloc] initWithFrame:CGRectMake(0, 300, kScreenWidth, 60)];
    btnDone.backgroundColor = [UIColor lightGrayColor];
    [btnDone setTitle:@"带有完成图标停止转动" forState:UIControlStateNormal];
    [self.view addSubview:btnDone];
    [btnDone addTarget:self action:@selector(doneLAIViewRotation:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btnFailed = [[UIButton alloc] initWithFrame:CGRectMake(0, 400, kScreenWidth, 60)];
    btnFailed.backgroundColor = [UIColor lightGrayColor];
    [btnFailed setTitle:@"加载失败" forState:UIControlStateNormal];
    [self.view addSubview:btnFailed];
    [btnFailed addTarget:self action:@selector(failedLAIViewRotation:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btnReload = [[UIButton alloc] initWithFrame:CGRectMake(0, 500, kScreenWidth, 60)];
    btnReload.backgroundColor = [UIColor lightGrayColor];
    [btnReload setTitle:@"重新加载" forState:UIControlStateNormal];
    [self.view addSubview:btnReload];
    [btnReload addTarget:self action:@selector(reloadLAIViewRotation:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)stopLAIViewRotation:(UIButton *)button {
    [_laiView setDescription:@"停止转动并隐藏" font:nil color:nil];
    [_laiView stopRotation];
    [self buttonStartLoading:button];
}

- (void)restartLAIViewRotation:(UIButton *)button {
    [_laiView setDescription:@"重新开始转动" font:nil color:nil];
    [_laiView startRotation];
    [self buttonStartLoading:button];
}

- (void)doneLAIViewRotation:(UIButton *)button {
    [_laiView setDescription:@"带图标状态完成" font:nil color:nil];
    [_laiView stopRotationWithDone];
    [self buttonStartLoading:button];
}

- (void)failedLAIViewRotation:(UIButton *)button {
    [_laiView stopRotationWithFaild];
    self.navigationItem.titleView = nil;
    self.navigationItem.title = @"加载失败";
    [self buttonStartLoading:button];
}

- (void)reloadLAIViewRotation:(UIButton *)button {
    self.navigationItem.title = nil;
    [_laiView setDescription:@"重新加载" font:nil color:nil];
    [_laiView startRotation];
    self.navigationItem.titleView = _laiView;
    [self buttonStartLoading:button];
}

- (void)buttonStartLoading:(UIButton *)button {
    if (button.subviews.count > 1) [button.subviews[1] removeFromSuperview];
    LabeledActivityIndicatorView *btnLAIView = [[LabeledActivityIndicatorView alloc] initWithActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    [button addSubview:btnLAIView];
    [btnLAIView setDescription:@"Loading..." font:nil color:[UIColor whiteColor]];
    [btnLAIView startRotation];
    [self performSelector:@selector(buttonStopLoading:) withObject:btnLAIView afterDelay:1.0];
}

- (void)buttonStopLoading:(LabeledActivityIndicatorView *)laiView {
    [laiView setDescription:@"Loaded" font:nil color:[UIColor whiteColor]];
    [laiView stopRotationWithDone];
    [self performSelector:@selector(resetButton:) withObject:laiView afterDelay:1.0];
}

- (void)resetButton:(LabeledActivityIndicatorView *)laiView {
    [laiView stopRotationWithFaild];
}

@end
