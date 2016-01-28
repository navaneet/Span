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

#define TOP_SCORE @"Top Score"
#define LAST_SCORE @"Last Score"

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.lastScoreLabel.hidden = YES;
    self.highestScoreLabel.hidden = YES;
  
    if ([[NSUserDefaults standardUserDefaults] objectForKey:TOP_SCORE] != nil) {
        NSInteger y = [[NSUserDefaults standardUserDefaults] integerForKey:LAST_SCORE];
        self.lastScoreLabel.text = [NSString stringWithFormat:@"Last Score: %i", (int)y];
        self.lastScoreLabel.hidden = NO;
        NSInteger x = [[NSUserDefaults standardUserDefaults] integerForKey:TOP_SCORE];
        self.highestScoreLabel.text = [NSString stringWithFormat:@"Top Score: %i", (int)x];
        self.highestScoreLabel.hidden = NO;
    }
    
    [self showBackgroundAnimation];
}

-(void)lastScore:(int)score {
    //persist the last score and the top score
    [[NSUserDefaults standardUserDefaults]setInteger:score forKey:LAST_SCORE];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSInteger y = [[NSUserDefaults standardUserDefaults] integerForKey:LAST_SCORE];
    self.lastScoreLabel.text = [NSString stringWithFormat:@"Last Score: %i", (int)y];
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
    self.highestScoreLabel.text = [NSString stringWithFormat:@"Top Score: %i", (int)x];
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
