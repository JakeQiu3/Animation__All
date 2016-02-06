//
//  CalayerGraphicViewController.m
//  动画大全
//
//  Created by 邱少依 on 16/1/5.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import "CalayerGraphicViewController.h"

/*
 * 不能再将某个UIView设置为CALayer的delegate，因为UIView对象已经是它内部根层的delegate，再次设置为其他层的delegate就会出问题
 */
#define PHOTO_WH 150
@interface CalayerGraphicViewController ()
{
//    CALayer *myLayer;
    CALayer *layer;
}
@end

@implementation CalayerGraphicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self setLayer];//设置子layer
    [self setLayerShadow];//设置含有阴影的子layer
    
}

- (void)setLayerShadow {
     //阴影图层
    CALayer *layerShadow = [CALayer layer];
    layerShadow.bounds = CGRectMake(0, 0, PHOTO_WH, PHOTO_WH);
    layerShadow.position = CGPointMake(160, 200);
    layerShadow.cornerRadius = PHOTO_WH/2;
    layerShadow.shadowColor = [UIColor grayColor].CGColor;
    layerShadow.shadowOffset = CGSizeMake(2, 1);
    layerShadow.shadowOpacity = 1.0f;
    layerShadow.borderColor = [UIColor whiteColor].CGColor;
    layerShadow.borderWidth = 2;
    [self.view.layer addSublayer:layerShadow];
    
      //容器图层
    layer = [CALayer layer];
    layer.bounds = layerShadow.bounds;
    layer.position = layerShadow.position;
    layer.backgroundColor = [UIColor redColor].CGColor;
    layer.cornerRadius = layerShadow.cornerRadius;
    layer.masksToBounds = YES;
    layer.borderWidth = layerShadow.borderWidth;
    layer.borderColor = [UIColor whiteColor].CGColor;
    
    layer.transform =CATransform3DMakeRotation(M_PI_2, 1, 0, 0);
#warning 少 警告，该代理设置后，执行下面方法会提前释放控制器
    layer.delegate = self;//设置代理
    [self.view.layer addSublayer:layer];
    [layer setNeedsDisplay];//调用图层的setNeedsDisplay，执行代理方法
    
}

- (void)setLayer {
    CALayer *myLayer = [CALayer layer];
    myLayer.bounds = CGRectMake(0, 0, PHOTO_WH, PHOTO_WH);
    myLayer.position = CGPointMake(160, 200);
    myLayer.contents = (id)[UIImage imageNamed:@"锚点和中心点position"].CGImage;
//    myLayer.backgroundColor = [UIColor redColor].CGColor;
    myLayer.cornerRadius = PHOTO_WH*0.5;//对于图层中绘制的图片无法正确显示,故需要剪切子图层，如下
    myLayer.masksToBounds = YES;
    myLayer.borderColor = [UIColor blackColor].CGColor;
    myLayer.borderWidth = 2;
   #warning 少 警告，该代理设置后，执行下面方法会提前释放控制器
    //设置图层代理
        myLayer.delegate = self;
    //添加图层到根图层
    [self.view.layer addSublayer:myLayer];
//    调用图层setNeedDisplay,否则代理方法不会被调用
        [myLayer setNeedsDisplay];
    
}

#pragma mark 绘制图形、图像到图层，注意参数中的ctx是图层的图形上下文，其中绘图位置也是相对图层而言的
- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
//    方法1
    CGContextSaveGState(ctx);
    //图形上下文形变，解决图片倒立的问题
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -PHOTO_WH);//形变第一步：向下平移40
    UIImage *image = [UIImage imageNamed:@"锚点和中心点position"];
      //注意这个位置是相对于图层而言的不是屏幕
    CGContextDrawImage(ctx, CGRectMake(0, 0, PHOTO_WH, PHOTO_WH), image.CGImage);
    
    CGContextRestoreGState(ctx);
////   方法2
//    UIImage *image = [UIImage imageNamed:@"锚点和中心点position"];
//    CGContextDrawImage(ctx, CGRectMake(0, 0, PHOTO_WH, PHOTO_WH), image.CGImage);
}
//防止控制器被移除栈时，有未释放的图层，调用其中的retain方法而出错
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [layer removeFromSuperlayer];
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
