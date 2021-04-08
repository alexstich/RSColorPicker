//
//  RSOpacitySlider.m
//  RSColorPicker
//
//  Created by Jared Allen on 5/16/13.
//  Copyright (c) 2013 Red Cactus LLC. All rights reserved.
//

#import "RSOpacitySlider.h"

#import "RSColorFunctions.h"

@implementation RSOpacitySlider

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initRoutine];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initRoutine];
    }
    return self;
}

- (void)initRoutine {
    self.minimumValue = 0.0;
    self.maximumValue = 1.0;
    self.continuous = YES;

    self.enabled = YES;
    self.userInteractionEnabled = YES;

    [self addTarget:self action:@selector(myValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    self.layer.cornerRadius = 5;
    self.clipsToBounds = YES;
    
    _color = UIColor.blackColor;
}

-  (void)didMoveToWindow {
    if (!self.window) return;

    UIImage *backgroundImage = RSOpacityBackgroundImage(16.f, self.window.screen.scale, [UIColor colorWithWhite: 0.92 alpha: 1.0]);
    self.backgroundColor = [UIColor colorWithPatternImage: backgroundImage];
}

- (void)myValueChanged:(id)notif {
    _colorPicker.opacity = self.value;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();

    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    NSArray *colors = [[NSArray alloc] initWithObjects:
                       (id)[_color colorWithAlphaComponent: 0].CGColor,
                       (id)[_color colorWithAlphaComponent: 1].CGColor, nil];

    CGGradientRef myGradient = CGGradientCreateWithColors(space, (__bridge CFArrayRef)colors, NULL);

    CGContextDrawLinearGradient(ctx, myGradient, CGPointZero, CGPointMake(rect.size.width, 0), 0);
    CGGradientRelease(myGradient);
    CGColorSpaceRelease(space);
}

- (void)setColorPicker:(RSColorPickerView *)cp {
    _colorPicker = cp;
    if (!_colorPicker) { return; }
    self.value = [_colorPicker brightness];
}

- (void)setColor:(UIColor *)cr {
    _color = cr;
    [self setNeedsDisplay];
}

@end
