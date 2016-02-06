//
//  AnimationViewController.m
//  动画大全
//
//  Created by 邱少依 on 16/1/11.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import "AnimationViewController.h"

@interface AnimationViewController ()
{
    CALayer *_layer;
}
@end

@implementation AnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self setImage];//封装后的动画：无法控制暂停，也无法组合动画
//    [self basicAnimation];//CABasicAnimation的使用说明
    [self keyFrameAnimation];//CAKeyframeAnimation
}

- (void)keyFrameAnimation {
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"锚点和中心点position"]];
    
//    自定义层
    _layer = [CALayer layer];
    _layer.bounds = CGRectMake(0, 0, 100, 120);
    _layer.position = CGPointMake(10, 200);
    _layer.contents = (id)[UIImage imageNamed:@"锚点和中心点position"].CGImage;
    [self.view.layer addSublayer:_layer];
    //创建动画
//    [self translationAnimationFourPoint];//4点移动
//    [self translationAnimationPathMove];//贝塞尔曲线
}
//创建关键帧动画
- (void)translationAnimationFourPoint {
    //1.创建关键帧动画并设置动画属性
    CAKeyframeAnimation *keyFrameAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    //2.设置关键帧,这里有四个关键帧
    NSValue *value1 = [NSValue valueWithCGPoint:_layer.position];//对于关键帧动画初始值不能省略
    NSValue *value2 = [NSValue valueWithCGPoint:CGPointMake(80, 220)];
    NSValue *value3 = [NSValue valueWithCGPoint:CGPointMake(45, 300)];
    NSValue *value4 = [NSValue valueWithCGPoint:CGPointMake(55, 400)];
    
    NSArray *valuesArray = @[value1,value2,value3,value4];
    keyFrameAnimation.values = valuesArray;
//    3.其他属性
    keyFrameAnimation.duration = 5.0;
    //设置延迟2秒执行
    keyFrameAnimation.beginTime = CACurrentMediaTime() + 2;
// 设置各个帖的时间间隔
    [keyFrameAnimation setKeyTimes:[NSArray arrayWithObjects:[NSNumber numberWithFloat:0],[NSNumber numberWithFloat:0.5],[NSNumber numberWithFloat:0.8],[NSNumber numberWithFloat:1.0], nil]];
//  //3.添加动画到图层，添加动画后就会执行动画
    [_layer addAnimation:keyFrameAnimation forKey:@"KCKeyframeAnimation_Position"];
}

- (void)translationAnimationPathMove {
    //1.创建关键帧动画并设置动画属性
    CAKeyframeAnimation *keyFrameAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    //2.设置关键帧,这里有四个关键帧
    //绘制贝塞尔曲线
    CGMutablePathRef path = CGPathCreateMutable();
    //移动到起始点
    CGPathMoveToPoint(path, NULL, _layer.position.x, _layer.position.y);
    //绘制二次贝塞尔曲线
    CGPathAddCurveToPoint(path, NULL, 160, 280, -30, 300, 55, 400);
    keyFrameAnimation.path = path;//设置path属性
    CGPathRelease(path);//释放路径对象
    keyFrameAnimation.duration = 5.0f;
    keyFrameAnimation.beginTime = CACurrentMediaTime() +2;
    //3.添加动画到图层，添加动画后就会执行动画
    [_layer addAnimation:keyFrameAnimation forKey:@"KCKeyframeAnimation_Position"];
}

- (void)setImage {
    UIImageView *imageView=[[UIImageView alloc]init];
    imageView.image=[UIImage imageNamed:@"锚点和中心点position"];
    imageView.frame=CGRectMake(120, 140, 80, 80);
    [self.view addSubview:imageView];
    
    [UIView animateWithDuration:1 delay:2 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        imageView.frame = CGRectMake(80, 100, 160, 160);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)basicAnimation {
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"锚点和中心点position"]];
//   自定义图层
    _layer = [[CALayer alloc]init];
    _layer.bounds = CGRectMake(0, 0, 10, 20);
    _layer.position = CGPointMake(50, 150);
    _layer.anchorPoint = CGPointMake(0.5, 0.6);
    _layer.contents = (id)[UIImage imageNamed:@"锚点和中心点position"].CGImage;//设置layer层的内容
    [self.view.layer addSublayer:_layer];
}
#pragma mark 点击事件
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:self.view];
    CAAnimation *translationAnimation = [_layer animationForKey:@"KCBasicAnimation_Translation"];
    if (translationAnimation) {
        if (_layer.speed == 0) {
            
            [self animationResume];
        } else {
            [self animationPause];
        }
    } else {
//        创建动画
        [self translatonAnimation:touchLocation];
        [self rotationAnimation];
    }
    
}

#pragma mark 移动动画
- (void)translatonAnimation:(CGPoint)touchLocation {
    //1.创建动画并指定动画属性为中心点position
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    
//    basicAnimation.fromValue= [NSValue valueWithCGPoint:_layer.position];//可以不设置，默认为图层初始状态
    basicAnimation.toValue=[NSValue valueWithCGPoint:touchLocation];
    basicAnimation.removedOnCompletion = NO;//运行一次是否移除动画
    basicAnimation.delegate = self;
    basicAnimation.duration = 5.0f;
//    basicAnimation.repeatCount = HUGE_VALF;//设置无限循环
    //存储当前位置在动画结束后使用
    [basicAnimation setValue:[NSValue valueWithCGPoint:touchLocation] forKey:@"KCBasicAnimationLocation"];
    //3.添加动画到图层，注意key相当于给动画进行命名，以后获得该动画时可以使用此名称获取
    [_layer addAnimation:basicAnimation forKey:@"KCBasicAnimation_Translation"];
}

#pragma mark 动画暂停
-(void)animationPause{
    //取得指定图层动画的媒体时间，后面参数用于指定子图层，这里不需要
    CFTimeInterval interval = [_layer convertTime:CACurrentMediaTime() fromLayer:nil];
    //设置时间偏移量，保证暂停时停留在旋转的位置
    _layer.timeOffset = interval;
    //速度设置为0，暂停动画
    _layer.speed=0;
}

#pragma mark 动画恢复
-(void)animationResume{
    //获得暂停的时间
    CFTimeInterval beginTime = CACurrentMediaTime() - _layer.timeOffset;
    //设置偏移量
    _layer.timeOffset = 0;
    //设置开始时间
    _layer.beginTime = beginTime;
    //设置动画速度，开始运动
    _layer.speed = 1.0f;
}

#pragma mark 旋转动画
-(void)rotationAnimation{
    //1.创建动画并指定动画属性
    CABasicAnimation *basicAnimation=[CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    //2.设置动画属性初始值、结束值
    //    basicAnimation.fromValue=[NSNumber numberWithInt:M_PI_2];
    basicAnimation.toValue=[NSNumber numberWithFloat:M_PI_2*3];
    
    //设置其他动画属性
    basicAnimation.duration=6.0;
    basicAnimation.autoreverses=YES;//旋转后在旋转到原来的位置
    basicAnimation.repeatCount= HUGE_VALF;//设置无限循环
    basicAnimation.removedOnCompletion=NO;
        basicAnimation.delegate=self;
    //4.添加动画到图层，注意key相当于给动画进行命名，以后获得该动画时可以使用此名称获取
    [_layer addAnimation:basicAnimation forKey:@"KCBasicAnimation_Rotation"];
}


#pragma mark - 动画代理方法
#pragma mark 动画开始
- (void)animationDidStart:(CAAnimation *)anim {
    NSLog(@"animation(%@) start.\r_layer.frame=%@",anim,NSStringFromCGRect(_layer.frame));
    NSLog(@"%@",[_layer animationForKey:@"KCBasicAnimation_Translation"]);//通过前面的设置的key获得动画
}

#pragma mark 动画结束

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
     NSLog(@"animation(%@) stop.\r_layer.frame=%@",anim,NSStringFromCGRect(_layer.frame));
    //开启事务
    [CATransaction begin];
    //禁用隐式动画
    
    [CATransaction setDisableActions:YES];
    _layer.position=[[anim valueForKey:@"KCBasicAnimationLocation"] CGPointValue];
    
    //提交事务
    [CATransaction commit];
    
    //暂停动画
    [self animationPause];
}
@end
