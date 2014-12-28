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

@property (nonatomic, strong) Line *currentLine;
@property (nonatomic, strong) NSMutableArray *finishedLines;

@end



@implementation DrawView

#pragma mark - Initializers

- (instancetype)initWithFrame:(CGRect)frame
{
   self = [super initWithFrame:frame];
   
   if (self) {
      _finishedLines = [[NSMutableArray alloc] init];
      self.backgroundColor = [UIColor grayColor];
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
   
   if (self.currentLine) {
      [[UIColor redColor] set];
      [self strokeLine:self.currentLine];
   }
}


#pragma mark - Touch handling

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
   UITouch *touch = [touches anyObject];
   
   CGPoint location = [touch locationInView:self];
   
   self.currentLine = [[Line alloc] init];
   
   self.currentLine.begin = location;
   self.currentLine.end = location;
   
   [self setNeedsDisplay];
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
   UITouch *touch = [touches anyObject];
   
   CGPoint location = [touch locationInView:self];
   
   self.currentLine.end = location;
   
   [self setNeedsDisplay];
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
   [self.finishedLines addObject:self.currentLine];
   
   self.currentLine = nil;
   
   [self setNeedsDisplay];
}

@end
