//
//  ViewController.m
//  Span
//
//  Created by Navaneet Sarma on 1/24/16.
//  Copyright © 2016 Navaneet Sarma. All rights reserved.
//

#import "ViewController.h"
#import "MainGameViewController.h"

@interface ViewController (){
}
@property (weak, nonatomic) IBOutlet UILabel *lastScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *highestScoreLabel;
@property (weak, nonatomic) IBOutlet UIButton *startGameButton;

#define TOP_SCORE @"Top Score"
#define LAST_SCORE @"Last Score"
#define ios7BlueColor [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0]
#define IS_IPAD (( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) ? YES : NO)
#define IS_IPHONE_5 (([UIScreen mainScreen].scale == 2.f && [UIScreen mainScreen].bounds.size.height == 568)?YES:NO)
#define IS_RETINA_DISPLAY_DEVICE (([UIScreen mainScreen].scale == 2.f)?YES:NO)

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.lastScoreLabel.hidden = YES;
    self.highestScoreLabel.hidden = YES;
    [self.startGameButton setTitle:NSLocalizedString(@"Start Game",nil) forState:UIControlStateNormal];
  
    if ([[NSUserDefaults standardUserDefaults] objectForKey:TOP_SCORE] != nil) {
        NSInteger y = [[NSUserDefaults standardUserDefaults] integerForKey:LAST_SCORE];
        self.lastScoreLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Last Score: %i",nil), (int)y];
        self.lastScoreLabel.hidden = NO;
        NSInteger x = [[NSUserDefaults standardUserDefaults] integerForKey:TOP_SCORE];
        self.highestScoreLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Top Score: %i",nil), (int)x];
        self.highestScoreLabel.hidden = NO;
    }
    
    [self.startGameButton setTintColor:ios7BlueColor];
    if (IS_IPAD)
    {
        [self.lastScoreLabel setFont:[UIFont systemFontOfSize:20]];
        [self.highestScoreLabel setFont:[UIFont systemFontOfSize:20]];
        [self.startGameButton.titleLabel setFont:[UIFont fontWithName:@"Calligraffiti" size:75]];
        //do stuff for iPad
    }
    else
    {
        if(IS_IPHONE_5)
        {
            [self.lastScoreLabel setFont:[UIFont systemFontOfSize:16]];
            [self.highestScoreLabel setFont:[UIFont systemFontOfSize:16]];
            [self.startGameButton.titleLabel setFont:[UIFont fontWithName:@"Calligraffiti" size:40]];
            //do stuff for 4 inch iPhone screen
        }
        else
        {
            [self.lastScoreLabel setFont:[UIFont systemFontOfSize:15]];
            [self.highestScoreLabel setFont:[UIFont systemFontOfSize:15]];
            [self.startGameButton.titleLabel setFont:[UIFont fontWithName:@"Calligraffiti" size:38]];
            //do stuff for 3.5 inch iPhone screen
        }
        
    }
    
    [self showBackgroundAnimation];
}

-(void)lastScore:(int)score {
    //persist the last score and the top score
    [[NSUserDefaults standardUserDefaults]setInteger:score forKey:LAST_SCORE];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSInteger y = [[NSUserDefaults standardUserDefaults] integerForKey:LAST_SCORE];
    self.lastScoreLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Last Score: %i",nil), (int)y];
    self.lastScoreLabel.hidden = NO;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:TOP_SCORE] != nil) {
        NSInteger x = [[NSUserDefaults standardUserDefaults] integerForKey:TOP_SCORE];
        if (score > (int)x ) {
            [[NSUserDefaults standardUserDefaults]setInteger:score forKey:TOP_SCORE];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }else{
    [[NSUserDefaults standardUserDefaults]setInteger:score forKey:TOP_SCORE];
    [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    NSInteger x = [[NSUserDefaults standardUserDefaults] integerForKey:TOP_SCORE];
    self.highestScoreLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Top Score: %i",nil), (int)x];
    self.highestScoreLabel.hidden = NO;
}

-(void) showBackgroundAnimation {

}

-(BOOL)prefersStatusBarHidden {
    return YES;
}

//-(UIStatusBarStyle)preferredStatusBarStyle {
//    return UIStatusBarStyleLightContent;
//}

- (IBAction)startGame:(id)sender {
    MainGameViewController *game = [[MainGameViewController alloc]init];
    game.delegate = self;
    [self.navigationController pushViewController:game animated:YES];
}

@end
