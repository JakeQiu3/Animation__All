//
//  DisplayViewController.m
//  动画大全
//
//  Created by 邱少依 on 16/1/12.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import "DisplayViewController.h"

@interface DisplayViewController ()
{
    CALayer*_layer;
    int index;
    NSMutableArray *_imageArray;
}
@end

@implementation DisplayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.layer.contents = (id)[UIImage imageNamed:@"bg"].CGImage;
    _layer = [CALayer layer];
    _layer.bounds = CGRectMake(0, 0, 87, 32);
    _layer.position = CGPointMake(160, 284);
    [self.view.layer addSublayer:_layer];
    
    _imageArray = [[NSMutableArray alloc] init];
    for (int i = 0; i<10; ++i) {
        NSString *imageName = [NSString stringWithFormat:@"fish%d",i];
        UIImage *image = [UIImage imageNamed:imageName];
        [_imageArray addObject:image];
    }
      //定义时钟对象
    CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(step)];
     //添加时钟对象到主运行循环
    [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}
#pragma mark 每次屏幕刷新就会执行一次此方法(每秒接近60次)
- (void)step {
    //定义一个变量记录执行次数
    static int a = 0;
    //每秒执行6次
    if (++a%10 == 0) {
        UIImage *image = _imageArray[index];
        _layer.contents = (id)image.CGImage;
        index = (index+1)%(_imageArray.count);
    }
}

@end
