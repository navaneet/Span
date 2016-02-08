//
//  ViewController.m
//  Span
//
//  Created by Navaneet Sarma on 1/24/16.
//  Copyright © 2016 Navaneet Sarma. All rights reserved.
//

#import "MainGameViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "UIView+Toast.h"
#import "ViewController.h"

#define IS_IPAD (( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) ? YES : NO)
#define IS_IPHONE_5 (([UIScreen mainScreen].scale == 2.f && [UIScreen mainScreen].bounds.size.height == 568)?YES:NO)
#define IS_RETINA_DISPLAY_DEVICE (([UIScreen mainScreen].scale == 2.f)?YES:NO)

#define SEPARATION 20
#define INITIAL_DIFFICULTY 3
#define RETRIES 3
#define SEPARATION_FROM_TOP 100

@interface MainGameViewController (){
    __block BOOL layout;
    UIView *parentView;
    NSMutableDictionary *dictionary;
    NSMutableArray *resultsArray;
    int initialDifficulty;
    __block BOOL processInputs;
    __block int score;
    UITextView *scoreTextView;
    __block int movesLeft;
    UITextView *movesLeftTextView;
    int widthOfCell;
    int heightOfCell;
}

@end

@implementation MainGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    initialDifficulty = INITIAL_DIFFICULTY;
    score = 0;
    self.view.backgroundColor = [UIColor colorWithRed:0.078 green:0.157 blue:0.259 alpha:1.00];
    //[UIColor colorWithRed:0.239 green:0.298 blue:0.325 alpha:1.00];
    parentView = [[UIView alloc]initWithFrame:self.view.bounds];
    scoreTextView = [[UITextView alloc] init];
    NSString *scoreText = [NSString stringWithFormat:NSLocalizedString(@"Score: %i",nil),score];
    scoreTextView.translatesAutoresizingMaskIntoConstraints = NO;
    scoreTextView.scrollEnabled = NO;
    scoreTextView.text = scoreText;
    scoreTextView.textColor = [UIColor whiteColor];
    scoreTextView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:scoreTextView];
    
    movesLeftTextView = [[UITextView alloc] init];
    NSString *movesLeftText = NSLocalizedString([NSString stringWithFormat:@"Calculating Sequence..."],nil);
    movesLeftTextView.text = movesLeftText;
    movesLeftTextView.textColor = [UIColor whiteColor];
    movesLeftTextView.backgroundColor = [UIColor clearColor];
    movesLeftTextView.translatesAutoresizingMaskIntoConstraints = NO;
    movesLeftTextView.scrollEnabled = NO;
    [self.view addSubview:movesLeftTextView];
    
    [self.view addSubview:parentView];
    NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:movesLeftTextView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:-3];
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:scoreTextView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:3];
    [self.view addConstraint:rightConstraint];
    [self.view addConstraint:leftConstraint];
    
    if (IS_IPAD)
    {
        [movesLeftTextView setFont:[UIFont systemFontOfSize:20]];
        [scoreTextView setFont:[UIFont systemFontOfSize:20]];
        //do stuff for iPad
    }
    else
    {
        if(IS_IPHONE_5)
        {
            [movesLeftTextView setFont:[UIFont systemFontOfSize:16]];
            [scoreTextView setFont:[UIFont systemFontOfSize:16]];
            //do stuff for 4 inch iPhone screen
        }
        else
        {
            [movesLeftTextView setFont:[UIFont systemFontOfSize:15]];
            [scoreTextView setFont:[UIFont systemFontOfSize:15]];
            //do stuff for 3.5 inch iPhone screen
        }
        
    }
    
    [movesLeftTextView setNeedsLayout];
    [scoreTextView setNeedsLayout];

}

-(void) startGame {
    if (layout) {
        //NSLog(@"%@",[NSThread callStackSymbols]);
        for (UIView *temp in parentView.subviews) {
            [UIView animateWithDuration:0.5
                                  delay:0.1
                                options: UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 temp.alpha = 0;
                             }completion:^(BOOL finished){
                                 [temp removeFromSuperview];
                                 [temp layoutIfNeeded];
                             }];
            
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.8* NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            dictionary = [[NSMutableDictionary alloc]init];
            resultsArray = [[NSMutableArray alloc]init];
            int width = self.view.bounds.size.width;
            int height = self.view.bounds.size.height;
            height = height - SEPARATION_FROM_TOP;
            
            if (IS_IPAD)
            {
                heightOfCell = widthOfCell = 100;
                //do stuff for iPad
            }
            else
            {
                if(IS_IPHONE_5)
                {
                    heightOfCell = widthOfCell = 70;
                    //do stuff for 4 inch iPhone screen
                }
                else
                {
                    heightOfCell = widthOfCell = 58;
                    //do stuff for 3.5 inch iPhone screen
                }
                
            }
            
            //actual width after clearing separation width
            width = width - SEPARATION*(width/widthOfCell);
            height = height - SEPARATION*(height/heightOfCell);
            
            int number=0;
            UIView *view;
            CGRect frame = CGRectMake(0, 0, widthOfCell, heightOfCell);
            for (int j =0; j<height/heightOfCell; j++) {
                if (j==0) {
                    frame = CGRectMake(0, ((self.view.bounds.size.height-(heightOfCell+SEPARATION)*(height/heightOfCell))/2)+SEPARATION/2, widthOfCell, heightOfCell);
                } else {
                    frame = CGRectMake(0, frame.origin.y+SEPARATION+heightOfCell, widthOfCell, heightOfCell);
                }
                for (int i =0; i<width/widthOfCell; i++) {
                    if (i==0) {
                        frame = CGRectMake(((self.view.bounds.size.width-(widthOfCell+SEPARATION)*(width/widthOfCell))/2)+SEPARATION/2, frame.origin.y, widthOfCell, heightOfCell);
                    }else{
                        //NSLog(@"XXXX %d %d", j,i);
                        frame = CGRectMake(frame.origin.x+widthOfCell+SEPARATION, frame.origin.y, widthOfCell, heightOfCell);
                    }
                    //NSLog(@"%i", number);
                    view = [[UIView alloc]initWithFrame:frame];
                    view.tag = number;
                    view.layer.cornerRadius = view.frame.size.width/2;
                    view.layer.borderColor = [[UIColor grayColor] CGColor];
                    view.layer.borderWidth = 0.5;
                    view.backgroundColor = [UIColor whiteColor];
                    view.alpha = 0.0;
                    [parentView addSubview:view];
                    [dictionary setObject:view forKey:[[NSNumber alloc]initWithInt:number]];
                    number++;
                }
            }
            
            
            NSMutableArray* animationBlocks = [NSMutableArray new];
            
            typedef void(^animationBlock)(BOOL);
            
            // getNextAnimation
            // removes the first block in the queue and returns it
            animationBlock (^getNextAnimation)() = ^{
                animationBlock block = animationBlocks.count ? (animationBlock)[animationBlocks objectAtIndex:0] : nil;
                if (block){
                    [animationBlocks removeObjectAtIndex:0];
                    return block;
                }else{
                    return ^(BOOL finished){};
                }
            };
            
            NSMutableArray *temp = [self shuffle:[[dictionary allKeys] mutableCopy]];
            temp = [self shuffle:temp];
            temp = [self shuffle:temp];
            for (int i=0; i<initialDifficulty/*[dictionary count]*/; i++) {
                int random;
                if (initialDifficulty>[dictionary count]) {
                    random = [self generateRandomNumberWithlowerBound:0 upperBound:number-1];
                }else{
                    random = (int)[(NSNumber *)[temp objectAtIndex:i] integerValue];
                }
                //NSString *randomString = [NSString stringWithFormat:@"%i",random];
                [resultsArray addObject:[NSNumber numberWithInt:i+1]];
                UIView *view = [dictionary objectForKey:[[NSNumber alloc]initWithInt:random]];
                //            NSLog(@"%@ >>>>>> %i",view, random);
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.frame = view.bounds;
                button.tag = i+1;
                [button addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
                //            button.center = CGPointMake(view.frame.size.width/2,
                //                                  view.frame.size.height/2);
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                button.titleLabel.textAlignment = NSTextAlignmentCenter;
                [button setTitle:[[NSNumber numberWithInt:i+1] stringValue] forState:UIControlStateNormal];
                if (IS_IPAD)
                {
                    [button.titleLabel setFont:[UIFont boldSystemFontOfSize:37]];
                    //do stuff for iPad
                }
                else
                {
                    if(IS_IPHONE_5)
                    {
                        [button.titleLabel setFont:[UIFont boldSystemFontOfSize:27]];
                        //do stuff for 4 inch iPhone screen
                    }
                    else
                    {
                        [button.titleLabel setFont:[UIFont boldSystemFontOfSize:23]];
                        //do stuff for 3.5 inch iPhone screen
                    }
                    
                }
                button.alpha = 0.0;
                view.backgroundColor = [UIColor whiteColor];
                [view addSubview:button];
                
                
                [animationBlocks addObject:^(BOOL finished){
                    [UIView animateWithDuration:0.8 delay:0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                        view.alpha = 1.0;
                        view.transform =CGAffineTransformMakeScale(1.2,1.2);
                        UIColor *color = [UIColor colorWithRed:0.329 green:0.749 blue:0.710 alpha:1.00];//[UIColor colorWithRed:0.302 green:0.702 blue:0.702 alpha:1.00];
                        view.backgroundColor = color;
                        button.alpha = 1.0;
                        
                    } completion:^(BOOL finished) {
                        [UIView animateWithDuration:0.8 delay:0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                            view.transform =CGAffineTransformMakeScale(1,1);
                            //view.backgroundColor = [UIColor whiteColor];
                            button.alpha = 0.0;
                        } completion:^(BOOL finished) {
                            [button setTitle:@"" forState:UIControlStateNormal];
                            button.alpha = 1.0;
                            getNextAnimation()(NO);
                            
                        }];
                        
                    }];
                }];
                
            }//for
            
            //add a block to our queue
            [animationBlocks addObject:^(BOOL finished){
                NSLog(@"Multi-step Animation Complete!");
                processInputs = YES;
                layout = NO;
                movesLeft = initialDifficulty;
                NSString *movesLeftText = [NSString stringWithFormat:NSLocalizedString(@"Moves Left: %i",nil),movesLeft];
                movesLeftTextView.text = movesLeftText;
                [self.view makeToast:NSLocalizedString(@"Tap The Sequence",nil)
                            duration:0.9
                            position:CSToastPositionTop];
            }];
            // execute the first block in the queue
            getNextAnimation()(YES);
            
        });
        
    }
}

- (NSMutableArray *)shuffle:(NSMutableArray *) array
{
    NSUInteger count = [array count];
    for (NSUInteger i = 0; i < count; ++i) {
        // Select a random element between i and end of array to swap with.
        NSInteger nElements = count - i;
        NSInteger n = (arc4random() % nElements) + i;
        [array exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
    return array;
}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
   
    
}

-(void)BtnClick:(id)sender
{
    if (processInputs) {
    static int retries = RETRIES;
    int subviewViewCount = 0;
    UIButton *button = (UIButton *) sender;
    for (UIView *subview in [[button.superview subviews] reverseObjectEnumerator]) {
        if ([subview isKindOfClass:[UIButton class]]) {
            button = (UIButton *) subview;
            subviewViewCount++;
        }
    }
        
    //NSLog(@"BtnClick %li", (long)button.tag);
    if ([[resultsArray firstObject] longValue] != button.tag) {
        //shake effect
        button.superview.transform = CGAffineTransformMakeTranslation(10, 0);
        [button.superview layoutIfNeeded];
        [UIView animateWithDuration:0.4 delay:0.0 usingSpringWithDamping:0.2 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            button.superview.transform = CGAffineTransformIdentity;
            [button.superview layoutIfNeeded];
        } completion:nil];
        retries--;
        NSLog(@"Wrong value entered");
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        layout = NO;
        if (retries==0) {
            processInputs = NO;
            retries = RETRIES;
            [self.view makeToast:NSLocalizedString(@"Game Lost",nil)
                        duration:0.5
                        position:CSToastPositionTop];
            NSLog(@"Game Lost");
            initialDifficulty = INITIAL_DIFFICULTY;
            [self.delegate lastScore:score];//XXXXXXXX
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.2* NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else {
            [self.view makeToast:[NSString stringWithFormat:NSLocalizedString(@"Retries Left: %i",nil),retries]
                        duration:0.5
                        position:CSToastPositionTop];
            NSLog(@"Retry");
        }
    }else {
        //zoom effect
        [UIView animateWithDuration: 0.5
                              delay: 0
             usingSpringWithDamping: 1
              initialSpringVelocity: .8
                            options: 0
                         animations: ^
         {
             button.superview.transform =CGAffineTransformMakeScale(1.2,1.2);
         }
                         completion: ^(BOOL finished) {
                             [UIView animateWithDuration: 0.5
                                                   delay: 0
                                  usingSpringWithDamping: 1
                                   initialSpringVelocity: .8
                                                 options: 0
                                              animations: ^
                              {
                                  button.superview.transform =CGAffineTransformMakeScale(1,1);
                              }
                                              completion: ^(BOOL finished) {
                                              }];
                         }];
        movesLeft--;
        NSString *movesLeftText = [NSString stringWithFormat:NSLocalizedString(@"Moves Left: %i",nil),movesLeft];
        movesLeftTextView.text = movesLeftText;
        [resultsArray removeObject:[resultsArray firstObject]];
        if (subviewViewCount > 1) {
            [button removeFromSuperview];
        }
        if ([resultsArray count] == 0) {
            NSLog(@"Game Won, Congratulations");
            processInputs = NO;
            initialDifficulty++;
            score++;
            NSString *scoreText = [NSString stringWithFormat:NSLocalizedString(@"Score: %i",nil),score];
            scoreTextView.text = scoreText;
            retries = RETRIES;
            layout = NO;
            [self.view makeToast:NSLocalizedString(@"Sequence Completed",nil) duration:0.9 position:CSToastPositionTop title:nil image:nil style:nil completion:^(BOOL didTap) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3* NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                    NSString *movesLeftText = [NSString stringWithFormat:NSLocalizedString(@"Calculating Sequence...",nil)];
                    movesLeftTextView.text = movesLeftText;
                    layout = YES;
                    [self.view setNeedsLayout];
                    [self.view layoutIfNeeded];
                    [self startGame];
                });
                
            }];
            
        }
    }
  }
}

-(BOOL)prefersStatusBarHidden {
    return YES;
}

-(int) generateRandomNumberWithlowerBound:(int)lowerBound
                               upperBound:(int)upperBound
{
    return lowerBound + arc4random_uniform(upperBound - lowerBound + 1);
}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
//    layout = YES;
//    [self.view setNeedsLayout];
//    [self.view layoutIfNeeded];
//    [self startGame];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    layout = YES;
    [self startGame];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
