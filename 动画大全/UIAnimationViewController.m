//
//  UIAnimationViewController.m
//  动画大全
//
//  Created by 邱少依 on 16/1/12.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import "UIAnimationViewController.h"

@interface UIAnimationViewController ()
{
    UIImageView *_imageView;
}
@end

@implementation UIAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.jpg"]];
    _imageView.center = CGPointMake(160, 50);
    [self.view addSubview:_imageView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.anyObject;
    CGPoint touchLocation = [touch locationInView:self.view];
//    /*创建弹性动画
//     damping:阻尼，范围0-1，阻尼越接近于0，弹性效果越明显
//     velocity:弹性复位的速度
//     */
//    [UIView animateWithDuration:2.0f delay:0 usingSpringWithDamping:0.1 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveLinear animations:^{
//        _imageView.center = touchLocation;
//    } completion:^(BOOL finished) {
//        
//    }];
    
    
    /* 普通 移动动画
     //     */
//    [UIView beginAnimations:@"KCBasicAnimation" context:nil];
//    [UIView setAnimationDelay:0];
//    [UIView setAnimationDuration:5];
//    _imageView.center = touchLocation;
//    //开始动画
//    [UIView commitAnimations];
    
    
    /*关键帧动画：属性值动画
     options:
     */
    [UIView animateKeyframesWithDuration:5.0f delay:0 options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionCurveLinear animations:^{
         //第二关键帧（准确的说第一个关键帧是开始位置）:从0秒开始持续50%的时间，也就是5.0*0.5=2.5秒
        [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.5 animations:^{
            _imageView.center = CGPointMake(80, 220);
        }];
        //第三个关键帧，从0.5*5.0秒开始，持续5.0*0.25=1.25秒
        [UIView addKeyframeWithRelativeStartTime:0.5 relativeDuration:0.25 animations:^{
            _imageView.center = CGPointMake(45.0, 300.0);
        }];
        //第四个关键帧：从0.75*5.0秒开始，持所需5.0*0.25=1.25秒
        [UIView addKeyframeWithRelativeStartTime:0.75 relativeDuration:0.25 animations:^{
            _imageView.center=CGPointMake(55.0, 400.0);
        }];

    } completion:^(BOOL finished) {
        NSLog(@"Animation end.");
    }];
    
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
