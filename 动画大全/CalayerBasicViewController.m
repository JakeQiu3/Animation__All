//
//  CalayerBasicViewController.m
//  动画大全
//
//  Created by 邱少依 on 16/1/5.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import "CalayerBasicViewController.h"
#define WidthH 50
#define ScreenSize [UIScreen mainScreen].bounds.size
@interface CalayerBasicViewController ()

@end

@implementation CalayerBasicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self drawMyLayer];
    // Do any additional setup after loading the view.
}
//绘制图层
- (void)drawMyLayer {
//   创建一个图层
    CALayer *layer = [[CALayer alloc] init];
    //设置背景颜色,由于QuartzCore是跨平台框架，无法直接使用UIColor
    layer.backgroundColor = [UIColor colorWithRed:0/255.0 green:146/255.0 blue:255.0/255.0 alpha:1.0f].CGColor;
    //设置:中心点和锚点
    layer.position = CGPointMake(ScreenSize.width*0.5, ScreenSize.height*0.5);
    layer.anchorPoint = CGPointMake(.5, .5);
    //设置大小
    layer.bounds = CGRectMake(0, 0, WidthH, WidthH);
    //设置圆角,当圆角半径等于矩形的一半时看起来就是一个圆形
    layer.cornerRadius = WidthH*0.5;
    layer.masksToBounds = YES;
    //设置阴影
    layer.shadowColor =[UIColor grayColor].CGColor;
    layer.shadowOffset = CGSizeMake(2, 2);
    layer.shadowOpacity = .9;
    //设置边框
    layer.borderColor = [UIColor whiteColor].CGColor;
    layer.borderWidth = 1;
//    设置不透明度
    layer.opacity = 0.8;
//    将子图层添加到UIview 的根layer层
    [self.view.layer addSublayer:layer];
    
}
//触摸放大
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
//    获取之前创建的layer
    CALayer *layer = self.view.layer.sublayers[0];
    CGFloat width = layer.bounds.size.width;
    if (width == WidthH) {
        width = WidthH*4;
    } else {
        width = WidthH;
    }
    layer.bounds = CGRectMake(0, 0, width, width);
//    获取点击的位置
    layer.position = [touch locationInView:self.view];
    layer.cornerRadius=width/2;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
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

@end
