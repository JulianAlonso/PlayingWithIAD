//
//  ViewController.m
//  PlayingWithIAD
//
//  Created by Julian Alonso on 2/3/15.
//  Copyright (c) 2015 IronHack. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () {
    
    int segundos;
    BOOL tiempo;
    
}

@property (strong, nonatomic) ADBannerView *bannerView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *centerLabel;
@property (strong, nonatomic) NSTimer *timer;


@end


@interface ViewController (BannerDelegate) <ADBannerViewDelegate>
@end


@implementation ViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        if ([ADBannerView instancesRespondToSelector:@selector(initWithAdType:)])
        {
            _bannerView = [[ADBannerView alloc] initWithAdType:ADAdTypeBanner];
        }
        else
        {
            _bannerView = [[ADBannerView alloc] init];
        }
        _bannerView.delegate = self;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.bannerView];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                  target:self
                                                selector:@selector(goTemp)
                                                userInfo:nil
                                                 repeats:YES];
    segundos = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self layoutAnimated:animated];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self layoutAnimated:[UIView areAnimationsEnabled]];
}

- (void)layoutAnimated:(BOOL)animated
{
    //Crear dos estructuras
    CGRect contentFrame = self.view.bounds;
    CGRect bannerFrame = self.bannerView.frame;
    
    if (self.bannerView.bannerLoaded)
    {
        contentFrame.size.height -= bannerFrame.size.height;
    }
    bannerFrame.origin.y = contentFrame.size.height;
    
    [UIView animateWithDuration:animated ? 0.25 : 0.0 animations:^{
        self.contentView.frame = contentFrame;
        
        [self.contentView layoutIfNeeded];
        
        self.bannerView.frame = bannerFrame;
        
        [self.bannerView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    }];
}

#pragma mark - Timer methods.
- (void)goTemp
{
    if (!tiempo)
    {
        segundos++;
        self.centerLabel.text = [NSString stringWithFormat:@"Time in view %d", segundos];
    }
    else
    {
        NSLog(@"en pausea");
    }
    
}

@end

@implementation ViewController (BannerDelegate)

- (void)bannerViewWillLoadAd:(ADBannerView *)banner  NS_AVAILABLE_IOS(5_0)
{
    
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    [self layoutAnimated:YES];
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
    tiempo = YES;
    return YES;
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner
{
    tiempo = NO;
}


@end
