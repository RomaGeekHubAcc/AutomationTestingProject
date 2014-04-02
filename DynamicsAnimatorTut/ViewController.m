//
//  ViewController.m
//  DynamicsAnimatorTut
//
//  Created by Roman Rybachenko on 3/31/14.
//  Copyright (c) 2014 Roman Rybachenko. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () {
    UIDynamicAnimator *animator;
    
    UICollisionBehavior *collisionBehavior;
    
    UIGravityBehavior *gravBehavior;
    
    
    UIView *squareView;
    UIView* barrier;
}

@end

@implementation ViewController

-(void) viewDidLoad {
    [super viewDidLoad];
    
    [self createAddSquareView];
	
    animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    gravBehavior = [[UIGravityBehavior alloc] initWithItems:@[squareView]];
    gravBehavior.magnitude = 0.5;
    [animator addBehavior:gravBehavior];
    
    barrier = [[UIView alloc] initWithFrame:CGRectMake(0, 300, 130, 20)];
    barrier.backgroundColor = [UIColor blackColor];
    [self.view addSubview:barrier];
    
    CGPoint rightEdge = CGPointMake(barrier.frame.origin.x +
                                    barrier.frame.size.width, barrier.frame.origin.y);
    CGPoint rightLowEdge = CGPointMake(barrier.frame.origin.x +barrier.frame.size.width, barrier.frame.origin.y + barrier.frame.size.height);
    
    collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[squareView, barrier]];
    collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    
    [collisionBehavior addBoundaryWithIdentifier:@"barier" fromPoint:barrier.frame.origin toPoint:rightEdge];
    [collisionBehavior addBoundaryWithIdentifier:@"barier"fromPoint:CGPointMake(barrier.frame.origin.x, barrier.frame.origin.y + barrier.frame.size.height) toPoint:rightLowEdge];
    collisionBehavior.collisionDelegate = self;
    
    [animator addBehavior:collisionBehavior];
    
    collisionBehavior.action =  ^{
//        NSLog(@"%@, %@",
//              NSStringFromCGAffineTransform(squareView.transform),
//              NSStringFromCGPoint(squareView.center));
    };
    UIDynamicItemBehavior* itemBehaviour = [[UIDynamicItemBehavior alloc] initWithItems:@[squareView]];
    itemBehaviour.elasticity = 0.9;
    itemBehaviour.angularResistance = 0.6;
    [animator addBehavior:itemBehaviour];
}

-(void) createAddSquareView {
    squareView = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    squareView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:squareView];
}

#pragma mark UICollisionBehaviorDelegate

- (void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id)item
   withBoundaryIdentifier:(id)identifier atPoint:(CGPoint)p {
    NSLog(@"Boundary contact occurred - %@", identifier);
    UIView* view = (UIView*)item;
    view.backgroundColor = [UIColor yellowColor];
    [UIView animateWithDuration:0.3 animations:^{
        view.backgroundColor = [UIColor grayColor];
    }];
}

@end
