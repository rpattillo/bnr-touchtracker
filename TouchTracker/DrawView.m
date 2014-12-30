//
//  DrawView.m
//  TouchTracker
//
//  Created by Ricky Pattillo on 12/28/14.
//  Copyright (c) 2014 Ricky Pattillo. All rights reserved.
//

#import "DrawView.h"
#import "Line.h"

@interface DrawView ()

@property (nonatomic, strong) NSMutableDictionary *linesInProgress;
@property (nonatomic, strong) NSMutableArray *finishedLines;

@end



@implementation DrawView

#pragma mark - Initializers

- (instancetype)initWithFrame:(CGRect)frame
{
   self = [super initWithFrame:frame];
   
   if (self) {
      _linesInProgress = [[NSMutableDictionary alloc] init];
      _finishedLines = [[NSMutableArray alloc] init];
      self.backgroundColor = [UIColor grayColor];
      self.multipleTouchEnabled = YES;
      
      UITapGestureRecognizer *doubleTapGR = [[UITapGestureRecognizer alloc]
                                             initWithTarget:self
                                             action:@selector(doubleTap:)];
      doubleTapGR.numberOfTapsRequired = 2;
      doubleTapGR.delaysTouchesBegan = YES;
      [self addGestureRecognizer:doubleTapGR];
   }
   
   return self;
}


#pragma mark - Drawing

- (void)strokeLine:(Line *)line
{
   UIBezierPath *path = [UIBezierPath bezierPath];
   
   path.lineWidth = 10.0;
   path.lineCapStyle = kCGLineCapRound;
   
   [path moveToPoint:line.begin];
   [path addLineToPoint:line.end];
   
   [path stroke];
}


- (void)drawRect:(CGRect)rect
{
   [[UIColor blackColor] set];
   
   for (Line *line in self.finishedLines) {
      [self strokeLine:line];
   }
   
   [[UIColor redColor] set];
   for (NSValue *key in self.linesInProgress) {
      [self strokeLine:self.linesInProgress[key]];
   }
}

#pragma mark - Gesture Handlers

- (void)doubleTap:(UIGestureRecognizer *)gr
{
   NSLog(@"Recognized Double Tap");
   
   [self.linesInProgress removeAllObjects];
   [self.finishedLines removeAllObjects];
   [self setNeedsDisplay];
}


#pragma mark - Touch handling

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
   NSLog(@"%@", NSStringFromSelector(_cmd));
   
   for (UITouch *touch in touches) {
      CGPoint location = [touch locationInView:self];
      
      Line *line = [[Line alloc] init];
      line.begin = location;
      line.end = location;
      
      NSValue *key = [NSValue valueWithNonretainedObject:touch];
      self.linesInProgress[key] = line;
   }
   
   [self setNeedsDisplay];
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
   NSLog(@"%@", NSStringFromSelector(_cmd));
   
   for (UITouch *touch in touches) {
      NSValue *key = [NSValue valueWithNonretainedObject:touch];
      
      Line *line = self.linesInProgress[key];
      
      line.end = [touch locationInView:self];
   }
   
   [self setNeedsDisplay];
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
   NSLog(@"%@", NSStringFromSelector(_cmd));
   
   for (UITouch *touch in touches) {
      NSValue *key = [NSValue valueWithNonretainedObject:touch];
      
      Line *line = self.linesInProgress[key];
      
      [self.finishedLines addObject:line];
      [self.linesInProgress removeObjectForKey:key];
   }
   
   [self setNeedsDisplay];
}


- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
   NSLog(@"%@", NSStringFromSelector(_cmd));
   
   for (UITouch *touch in touches) {
      NSValue *key = [NSValue valueWithNonretainedObject:touch];
      
      [self.linesInProgress removeObjectForKey:key];
   }
   
   [self setNeedsDisplay];
}

@end
