//
//  TransitionViewController.m
//  动画大全
//
//  Created by 邱少依 on 16/1/12.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import "TransitionViewController.h"

@interface TransitionViewController ()
{
    UIImageView *_imageView;
    int currentIndex;
}
@end

@implementation TransitionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _imageView = [[UIImageView alloc] init];
    _imageView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    _imageView.image = [UIImage imageNamed:@"0.jpg"];
    [self.view addSubview:_imageView];
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipe:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeLeft];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipe:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRight];
}
#pragma mark 轻扫方法
- (void)leftSwipe:(UISwipeGestureRecognizer *)leftGesture {
    [self transitionAnimation:YES];
}

- (void)rightSwipe:(UISwipeGestureRecognizer *)rightGesture {
    [self transitionAnimation:NO];
}
//创建专场动画，并添加对应的图片
- (void)transitionAnimation:(BOOL)isNext {
     //1.创建转场动画对象
    CATransition *transition = [[CATransition alloc] init];
//    苹果官方没公开的动画类型只能使用字符串，并没有对应的常量定义
    transition.type = @"cube";
    transition.duration = 1.0f;
//    
    if (isNext) {
        transition.subtype = kCATransitionFromRight;
    } else {
        transition.subtype = kCATransitionFromLeft;
    }
//3.设置转场后的新视图添加转场动画
    _imageView.image = [self getImage:isNext];
    [_imageView.layer addAnimation:transition forKey:@"KCATransition"];
}
#pragma mark 取得当前图片
- (UIImage *)getImage:(BOOL)isNext {
    if (isNext) {
        currentIndex = (currentIndex+1)%5;//#define IMAGE_COUNT 5
    } else {
        currentIndex = (currentIndex - 1 + 5)%5;//#define IMAGE_COUNT 5
    }
    NSString *imageName = [NSString stringWithFormat:@"%i.jpg",currentIndex];
    return [UIImage imageNamed:imageName];
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
