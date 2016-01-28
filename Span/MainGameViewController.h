//
//  MainGameViewController.h
//  Span
//
//  Created by Navaneet Sarma on 1/26/16.
//  Copyright © 2016 Navaneet Sarma. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MainGameViewControllerDelegate <NSObject>

-(void) lastScore:(int) score;

@end

@interface MainGameViewController : UIViewController

@property(weak, nonatomic) id delegate;

@end
