//
//  ViewController.m
//  Watermark
//
//  Created by xianjunwang on 2017/12/11.
//  Copyright © 2017年 xianjunwang. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>


#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width

@interface ViewController ()
@property (nonatomic,strong) UIImageView * imageView;
//图片添加图片水印按钮
@property (nonatomic,strong) UIButton * imageAddWatermarkBtn;
//图片添加文字水印按钮
@property (nonatomic,strong) UIButton * imageAddWatermarkTwoBtn;
//添加水印层按钮
@property (nonatomic,strong) UIButton * addWatermarkLayerBtn;
@property (nonatomic,strong) NSURL * videoUrl;
//水印层
@property (nonatomic,strong) CATextLayer *textLayer;
@end

@implementation ViewController

#pragma mark  ----  生命周期函数

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.imageAddWatermarkBtn];
    [self.view addSubview:self.imageAddWatermarkTwoBtn];
    [self.view addSubview:self.addWatermarkLayerBtn];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark  ----  自定义函数
//图片添加水印
-(void)imageAddWatermarkBtnClicked{
    
    UIImage *bgImage = self.imageView.image;
    //创建一个位图上下文
    UIGraphicsBeginImageContextWithOptions(bgImage.size, NO, 0.0);
    //将背景图片画入位图中
    [bgImage drawInRect:CGRectMake(0, 0, bgImage.size.width, bgImage.size.height)];
    //将水印Logo画入背景图中
    UIImage *waterIma = [UIImage imageNamed:@"A_1@2x"];
    [waterIma drawInRect:CGRectMake(bgImage.size.width - 20 - 5, bgImage.size.height - 20 - 5, 20, 20)];
    //取得位图上下文中创建的新的图片
    UIImage *newimage = UIGraphicsGetImageFromCurrentImageContext();
    //结束上下文
    UIGraphicsEndImageContext();
    //在创建的ImageView上显示出新图片
    self.imageView.image = newimage;
}

//图片添加文字水印
-(void)imageAddWatermarkTwoBtnClicked{
    
    //1.开启上下文
    UIGraphicsBeginImageContextWithOptions(self.imageView.image.size, NO, 0);
    //2.绘制图片
    [self.imageView.image drawInRect:CGRectMake(0, 0, self.imageView.image.size.width, self.imageView.image.size.height)];
    //添加水印文字
    [@"文字水印测试" drawAtPoint:CGPointMake(0, 40) withAttributes:@{NSForegroundColorAttributeName:[UIColor yellowColor]}];
    //3.从上下文中获取新图片
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    //4.关闭图形上下文
    UIGraphicsEndImageContext();
    //返回图片
    self.imageView.image = newImage;
}

//添加水印层按钮的响应
-(void)addWatermarkLayerBtnClicked{
    
    [self.view.layer addSublayer:self.textLayer];
}

#pragma mark  ----  懒加载
-(UIImageView *)imageView{
    
    if (!_imageView) {
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 64, SCREENWIDTH - 40, 100)];
        _imageView.image = [UIImage imageNamed:@"videoplaceholdersmall@2x"];
    }
    return _imageView;
}

-(UIButton *)imageAddWatermarkBtn{
    
    if (!_imageAddWatermarkBtn) {
    
        _imageAddWatermarkBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _imageAddWatermarkBtn.frame = CGRectMake(20, CGRectGetMaxY(self.imageView.frame) + 20, 140, 40);
        [_imageAddWatermarkBtn setTitle:@"图片添加图片水印" forState:UIControlStateNormal];
        [_imageAddWatermarkBtn addTarget:self action:@selector(imageAddWatermarkBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _imageAddWatermarkBtn;
}

-(UIButton *)imageAddWatermarkTwoBtn{
    
    if (!_imageAddWatermarkTwoBtn) {
        
        _imageAddWatermarkTwoBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _imageAddWatermarkTwoBtn.frame = CGRectMake(CGRectGetMaxX(self.imageAddWatermarkBtn.frame) + 20, CGRectGetMaxY(self.imageView.frame) + 20, 140, 40);
        [_imageAddWatermarkTwoBtn setTitle:@"图片添加文字水印" forState:UIControlStateNormal];
        [_imageAddWatermarkTwoBtn addTarget:self action:@selector(imageAddWatermarkTwoBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _imageAddWatermarkTwoBtn;
}

-(UIButton *)addWatermarkLayerBtn{
    
    if (!_addWatermarkLayerBtn) {
        
        _addWatermarkLayerBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _addWatermarkLayerBtn.frame = CGRectMake(20, CGRectGetMaxY(self.imageAddWatermarkBtn.frame) + 20, 140, 40);
        [_addWatermarkLayerBtn setTitle:@"添加水印层按钮" forState:UIControlStateNormal];
        [_addWatermarkLayerBtn addTarget:self action:@selector(addWatermarkLayerBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addWatermarkLayerBtn;
}

-(CATextLayer *)textLayer{
    
    if (!_textLayer) {
        
        _textLayer = [[CATextLayer alloc] init];
        _textLayer.frame = CGRectMake(0, 200, SCREENWIDTH, 36);
        _textLayer.string = [[NSAttributedString alloc] initWithString:@"1234567890" attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:36.0],NSForegroundColorAttributeName:[UIColor greenColor]}];
        _textLayer.alignmentMode = @"center";
        _textLayer.opacity = 0.2;
        _textLayer.wrapped = YES;
        _textLayer.anchorPoint = CGPointMake(0.5, 0.5);
        [_textLayer setAffineTransform:CGAffineTransformMakeRotation(-M_PI / 4)];
        //水印层，如果添加到keyWindow上，则整个app都有水印。适合用于视频播放的水印添加
    }
    return _textLayer;
}

@end
