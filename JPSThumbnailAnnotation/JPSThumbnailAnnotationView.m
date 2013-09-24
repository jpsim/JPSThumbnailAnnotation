//
//  JPSThumbnailAnnotationView.m
//  JPSThumbnailAnnotationView
//
//  Created by Jean-Pierre Simard on 4/21/13.
//  Copyright (c) 2013 JP Simard. All rights reserved.
//

#import "JPSThumbnailAnnotationView.h"

#define JPSThumbnailAnnotationViewStandardWidth     75.0f
#define JPSThumbnailAnnotationViewStandardHeight    87.0f
#define JPSThumbnailAnnotationViewExpandOffset      200.0f
#define JPSThumbnailAnnotationViewVerticalOffset    34.0f
#define JPSThumbnailAnnotationViewAnimationDuration 0.25f
#define JPSThumbnailAnnotationViewShadowVisible     TRUE

@interface ShadowShapeLayer : CAShapeLayer
@end

@implementation ShadowShapeLayer

- (void)drawInContext:(CGContextRef)context {
    CGContextSaveGState(context);
    CGContextSetShadow(context, CGSizeMake(0, 6), 6);
    [super drawInContext:context];
    CGContextRestoreGState(context);
}

@end

@implementation JPSThumbnailAnnotationView

- (id)initWithAnnotation:(id<MKAnnotation>)annotation {
    self = [super initWithAnnotation:annotation reuseIdentifier:@"JPSThumbnailAnnotationView"];
    
    if (self) {
        self.canShowCallout = NO;
        self.frame = CGRectMake(0, 0, JPSThumbnailAnnotationViewStandardWidth, JPSThumbnailAnnotationViewStandardHeight);
        self.backgroundColor = [UIColor clearColor];
        self.centerOffset = CGPointMake(0, -JPSThumbnailAnnotationViewVerticalOffset);
        
        // Image View
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(12.5, 12, 50, 47)];
        _imageView.layer.cornerRadius = 4.0;
        _imageView.layer.masksToBounds = YES;
        _imageView.layer.borderColor = [[UIColor blackColor] CGColor];
        _imageView.layer.borderWidth = 1;
        [self addSubview:_imageView];
        
        // Name Label
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(-32, 20, 168, 20)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.shadowColor = [UIColor colorWithWhite:0 alpha:0.5];
        _titleLabel.shadowOffset = CGSizeMake(0, -1);
        _titleLabel.font = [UIFont boldSystemFontOfSize:17];
        _titleLabel.alpha = 0;
        _titleLabel.minimumScaleFactor = .8f;
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:_titleLabel];
        
        // Distance Label
        _subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(-32, 36, 168, 20)];
        _subtitleLabel.backgroundColor = [UIColor clearColor];
        _subtitleLabel.textColor = [UIColor whiteColor];
        _subtitleLabel.shadowColor = [UIColor colorWithWhite:0 alpha:0.5];
        _subtitleLabel.shadowOffset = CGSizeMake(0, -1);
        _subtitleLabel.font = [UIFont systemFontOfSize:12];
        _subtitleLabel.alpha = 0;
        [self addSubview:_subtitleLabel];
        
        // Disclosure button
        _disclosureButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        _disclosureButton.frame = CGRectMake(JPSThumbnailAnnotationViewExpandOffset/2 + self.frame.size.width/2 - 4.0f, 21, _disclosureButton.frame.size.width, _disclosureButton.frame.size.height);
        
        [_disclosureButton addTarget:self action:@selector(didTapDisclosureButton:) forControlEvents:UIControlEventTouchDown];
        _disclosureButton.alpha = 0;
        [self addSubview:_disclosureButton];
        
        _state = JPSThumbnailAnnotationViewStateCollapsed;
        
        [self setLayerProperties];
    }
    
    return self;
}

- (void)didTapDisclosureButton:(id)sender {
    if (_disclosureBlock) _disclosureBlock();
}

- (void)didSelectAnnotationViewInMap:(MKMapView *)mapView {
    // Center map at annotation point
    [mapView setCenterCoordinate:_coordinate animated:YES];
    [self expand];
}

- (void)didDeselectAnnotationViewInMap:(MKMapView *)mapView {
    [self shrink];
}

- (void)setLayerProperties {
    _shapeLayer = [ShadowShapeLayer layer];
    CGPathRef shapeLayerPath = [self newBubbleWithRect:self.bounds andOffset:CGSizeMake(JPSThumbnailAnnotationViewExpandOffset/2, 0)];
    _shapeLayer.path = shapeLayerPath;
    CGPathRelease(shapeLayerPath);
    
    // Fill Callout Bubble & Add Shadow
    _shapeLayer.fillColor = [[UIColor blackColor] CGColor];
    
    _strokeAndShadowLayer = [CAShapeLayer layer];
    
    CGPathRef _strokeAndShadowLayerPath = [self newBubbleWithRect:self.bounds];
    _strokeAndShadowLayer.path = _strokeAndShadowLayerPath;
    CGPathRelease(_strokeAndShadowLayerPath);
    
    _strokeAndShadowLayer.fillColor = [UIColor clearColor].CGColor;
    
    if (JPSThumbnailAnnotationViewShadowVisible) {
        _strokeAndShadowLayer.shadowColor = [UIColor blackColor].CGColor;
        _strokeAndShadowLayer.shadowOffset = CGSizeMake (0, [[[UIDevice currentDevice] systemVersion] floatValue] >= 3.2 ? 3 : -3);
        _strokeAndShadowLayer.shadowRadius = 5.0;
        _strokeAndShadowLayer.shadowOpacity = 1.0;
    }
    
    _strokeAndShadowLayer.strokeColor = [UIColor colorWithWhite:0.22 alpha:1.0].CGColor;
    _strokeAndShadowLayer.lineWidth = 1.0;
    
    CAGradientLayer *bubbleGradient = [CAGradientLayer layer];
    bubbleGradient.frame = CGRectMake(self.bounds.origin.x-JPSThumbnailAnnotationViewExpandOffset/2, self.bounds.origin.y, JPSThumbnailAnnotationViewExpandOffset+self.bounds.size.width, self.bounds.size.height-7);
    bubbleGradient.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithWhite:0 alpha:.75].CGColor, (id)[UIColor colorWithWhite:0 alpha:.75].CGColor,(id)[UIColor colorWithWhite:0.13 alpha:.75].CGColor,(id)[UIColor colorWithWhite:0.33 alpha:.75].CGColor, nil];
    bubbleGradient.locations = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0],[NSNumber numberWithFloat:0.53],[NSNumber numberWithFloat:.54],[NSNumber numberWithFloat:1], nil];
    bubbleGradient.startPoint = CGPointMake(0.0f, 1.0f);
    bubbleGradient.endPoint = CGPointMake(0.0f, 0.0f);
    bubbleGradient.mask = _shapeLayer;
    
    _shapeLayer.masksToBounds = NO;
    bubbleGradient.masksToBounds = NO;
    _strokeAndShadowLayer.masksToBounds = NO;
    
    [_strokeAndShadowLayer addSublayer:bubbleGradient];
    [self.layer insertSublayer:_strokeAndShadowLayer atIndex:0];
}

- (CGPathRef)newBubbleWithRect:(CGRect)rect {
    CGFloat stroke = 1.0;
	CGFloat radius = 7.0;
	CGMutablePathRef path = CGPathCreateMutable();
	CGFloat parentX = rect.origin.x + rect.size.width/2;
	
	//Determine Size
	rect.size.width -= stroke + 14;
	rect.size.height -= stroke + 29;
	rect.origin.x += stroke / 2.0 + 7;
	rect.origin.y += stroke / 2.0 + 7;
    
	//Create Path For Callout Bubble
	CGPathMoveToPoint(path, NULL, rect.origin.x, rect.origin.y + radius);
	CGPathAddLineToPoint(path, NULL, rect.origin.x, rect.origin.y + rect.size.height - radius);
	CGPathAddArc(path, NULL, rect.origin.x + radius, rect.origin.y + rect.size.height - radius, radius, M_PI, M_PI_2, 1);
	CGPathAddLineToPoint(path, NULL, parentX - 14, rect.origin.y + rect.size.height);
	CGPathAddLineToPoint(path, NULL, parentX, rect.origin.y + rect.size.height + 14);
	CGPathAddLineToPoint(path, NULL, parentX + 14, rect.origin.y + rect.size.height);
	CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width - radius, rect.origin.y + rect.size.height);
	CGPathAddArc(path, NULL, rect.origin.x + rect.size.width - radius, rect.origin.y + rect.size.height - radius, radius, M_PI_2, 0.0f, 1);
	CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width, rect.origin.y + radius);
	CGPathAddArc(path, NULL, rect.origin.x + rect.size.width - radius, rect.origin.y + radius, radius, 0.0f, -M_PI_2, 1);
	CGPathAddLineToPoint(path, NULL, rect.origin.x + radius, rect.origin.y);
	CGPathAddArc(path, NULL, rect.origin.x + radius, rect.origin.y + radius, radius, -M_PI_2, M_PI, 1);
	CGPathCloseSubpath(path);
    return path;
}

- (CGPathRef)newBubbleWithRect:(CGRect)rect andOffset:(CGSize)offset {
    CGRect offsetRect = CGRectMake(rect.origin.x+offset.width, rect.origin.y+offset.height, rect.size.width, rect.size.height);
    return [self newBubbleWithRect:offsetRect];
}

- (void)expand {
    if (_state != JPSThumbnailAnnotationViewStateCollapsed) return;
    _state = JPSThumbnailAnnotationViewStateAnimating;
    
    [self animateBubbleWithDirection:JPSThumbnailAnnotationViewAnimationDirectionGrow];
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width+JPSThumbnailAnnotationViewExpandOffset, self.frame.size.height);
    self.centerOffset = CGPointMake(JPSThumbnailAnnotationViewExpandOffset/2, -JPSThumbnailAnnotationViewVerticalOffset);
    [UIView animateWithDuration:JPSThumbnailAnnotationViewAnimationDuration/2 delay:JPSThumbnailAnnotationViewAnimationDuration options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _disclosureButton.alpha = 1;
        _titleLabel.alpha = 1;
        _subtitleLabel.alpha = 1;
    } completion:^(BOOL finished) {
        _state = JPSThumbnailAnnotationViewStateExpanded;
    }];
}

- (void)shrink {
    if (_state != JPSThumbnailAnnotationViewStateExpanded) return;
    _state = JPSThumbnailAnnotationViewStateAnimating;

    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width-JPSThumbnailAnnotationViewExpandOffset, self.frame.size.height);
    [UIView animateWithDuration:JPSThumbnailAnnotationViewAnimationDuration/2 delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _disclosureButton.alpha = 0;
        _titleLabel.alpha = 0;
        _subtitleLabel.alpha = 0;
    } completion:^(BOOL finished) {
        [self animateBubbleWithDirection:JPSThumbnailAnnotationViewAnimationDirectionShrink];
        self.centerOffset = CGPointMake(0, -JPSThumbnailAnnotationViewVerticalOffset);
    }];
}

- (void)animateBubbleWithDirection:(JPSThumbnailAnnotationViewAnimationDirection)animationDirection {
    // Image
    [UIView animateWithDuration:JPSThumbnailAnnotationViewAnimationDuration animations:^{
        if (animationDirection == JPSThumbnailAnnotationViewAnimationDirectionGrow) {
            _imageView.frame = CGRectMake(_imageView.frame.origin.x-JPSThumbnailAnnotationViewExpandOffset/2, _imageView.frame.origin.y, _imageView.frame.size.width, _imageView.frame.size.height);
        } else if (animationDirection == JPSThumbnailAnnotationViewAnimationDirectionShrink) {
            _imageView.frame = CGRectMake(_imageView.frame.origin.x+JPSThumbnailAnnotationViewExpandOffset/2, _imageView.frame.origin.y, _imageView.frame.size.width, _imageView.frame.size.height);
        }
    } completion:^(BOOL finished) {
        if (animationDirection == JPSThumbnailAnnotationViewAnimationDirectionShrink) {
            _state = JPSThumbnailAnnotationViewStateCollapsed;
        }
    }];
    
    // Bubble
    CGRect largeRect = CGRectMake(self.bounds.origin.x-JPSThumbnailAnnotationViewExpandOffset/2, self.bounds.origin.y, self.bounds.size.width+JPSThumbnailAnnotationViewExpandOffset, self.bounds.size.height);
    CGRect standardRect = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, self.bounds.size.height);
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
    
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.repeatCount = 1;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.duration = JPSThumbnailAnnotationViewAnimationDuration;
    
    // Stroke & Shadow From/To Values
    CGPathRef fromPath = (animationDirection == JPSThumbnailAnnotationViewAnimationDirectionGrow) ? [self newBubbleWithRect:standardRect] : [self newBubbleWithRect:largeRect];
    animation.fromValue = (__bridge id)fromPath;
    CGPathRelease(fromPath);
    
    CGPathRef toPath = (animationDirection == JPSThumbnailAnnotationViewAnimationDirectionGrow) ? [self newBubbleWithRect:largeRect] : [self newBubbleWithRect:standardRect];
    animation.toValue = (__bridge id)toPath;
    CGPathRelease(toPath);
    
    [_strokeAndShadowLayer addAnimation:animation forKey:animation.keyPath];
    
    // ShapeLayer From/To Values
    fromPath = (animationDirection == JPSThumbnailAnnotationViewAnimationDirectionGrow) ?
    [self newBubbleWithRect:standardRect andOffset:CGSizeMake(JPSThumbnailAnnotationViewExpandOffset/2, 0)] : [self newBubbleWithRect:largeRect andOffset:CGSizeMake(JPSThumbnailAnnotationViewExpandOffset/2, 0)];
    animation.fromValue = (__bridge id)fromPath;
    CGPathRelease(fromPath);
    
    toPath = (animationDirection == JPSThumbnailAnnotationViewAnimationDirectionGrow) ? [self newBubbleWithRect:largeRect andOffset:CGSizeMake(JPSThumbnailAnnotationViewExpandOffset/2, 0)] : [self newBubbleWithRect:standardRect andOffset:CGSizeMake(JPSThumbnailAnnotationViewExpandOffset/2, 0)];
    animation.toValue = (__bridge id)toPath;
    CGPathRelease(toPath);
    [_shapeLayer addAnimation:animation forKey:animation.keyPath];
}

@end
