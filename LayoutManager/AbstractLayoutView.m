#import "AbstractLayoutView.h"

@implementation AbstractLayoutView

@synthesize spacing = _spacing;
@synthesize leftMargin = _leftMargin;
@synthesize rightMargin = _rightMargin;
@synthesize topMargin = _topMargin;
@synthesize bottomMargin = _bottomMargin;
@synthesize hAlignment = _hAlignment;
@synthesize vAlignment = _vAlignment;
@synthesize removeOnHide = _removeOnHide;

- (id)init
{
    return [self initWithFrame:CGRectZero spacing:0
            leftMargin:0 rightMargin:0 topMargin:0 bottomMargin:0
            hAlignment:UIControlContentHorizontalAlignmentCenter
            vAlignment:UIControlContentVerticalAlignmentCenter];
}

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame spacing:0
            leftMargin:0 rightMargin:0 topMargin:0 bottomMargin:0
            hAlignment:UIControlContentHorizontalAlignmentCenter
            vAlignment:UIControlContentVerticalAlignmentCenter];
}

- (id)initWithFrame:(CGRect)frame spacing:(int)s
{
    return [self initWithFrame:frame spacing:s
            leftMargin:0 rightMargin:0 topMargin:0 bottomMargin:0
            hAlignment:UIControlContentHorizontalAlignmentCenter
            vAlignment:UIControlContentVerticalAlignmentCenter];
}

- (id)initWithFrame:(CGRect)frame spacing:(int)s leftMargin:(int)lm
        rightMargin:(int)rm topMargin:(int)tm bottomMargin:(int)bm
{
    return [self initWithFrame:frame spacing:s
            leftMargin:lm rightMargin:rm topMargin:tm bottomMargin:bm
            hAlignment:UIControlContentHorizontalAlignmentCenter
            vAlignment:UIControlContentVerticalAlignmentCenter];    
}

- (id)initWithFrame:(CGRect)frame spacing:(int)s leftMargin:(int)lm
    rightMargin:(int)rm topMargin:(int)tm bottomMargin:(int)bm
    hAlignment:(UIControlContentHorizontalAlignment)ha
    vAlignment:(UIControlContentVerticalAlignment)va
{
    if ((self = [super initWithFrame:frame]))
    {
        self.spacing = s;
        self.leftMargin = lm;
        self.rightMargin = rm;
        self.topMargin = tm;
        self.bottomMargin = bm;
        self.hAlignment = ha;
        self.vAlignment = va;
        
        self.scrollEnabled = NO;
    }
    return self;
}

- (void)setSize
{
    BOOL autoresizesSubviews = self.autoresizesSubviews;
    self.autoresizesSubviews = NO;
    [self sizeToFit];
    self.autoresizesSubviews = autoresizesSubviews;
}

- (void)setSizeWithWidth:(int)w
{
    BOOL autoresizesSubviews = self.autoresizesSubviews;
    self.autoresizesSubviews = NO;
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, w,
                            [self sizeThatFits:self.frame.size].height);
    self.autoresizesSubviews = autoresizesSubviews;
}

- (void)setSizeWithHeight:(int)h
{
    BOOL autoresizesSubviews = self.autoresizesSubviews;
    self.autoresizesSubviews = NO;
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,
                            [self sizeThatFits:self.frame.size].width, h);
    self.autoresizesSubviews = autoresizesSubviews;
}

- (int)availableWidth
{
    return self.frame.size.width - self.leftMargin - self.rightMargin;
}

- (int)availableHeight
{
    return self.frame.size.height - self.topMargin - self.bottomMargin;
}

- (void)scrollToShow:(UIView *)subview animated:(BOOL)animated
{
    CGRect frame = [subview.superview convertRect:subview.frame toView:self];
    CGRect rect = CGRectMake(frame.origin.x + self.contentInset.left,
                             frame.origin.y + self.contentInset.top,
                             frame.size.width,
                             frame.size.height);
    [self scrollRectToVisible:rect animated:animated];
}

- (CGSize)layoutSubviewsEffectively:(BOOL)effectively
{
    return CGSizeZero;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    BOOL showsHorizontalScrollIndicator = self.showsHorizontalScrollIndicator;
    BOOL showsVerticalScrollIndicator = self.showsVerticalScrollIndicator;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    if(self.removeOnHide) {
        [self addSubviewsHiddenObserver];
    }
    CGSize contentSize = [self layoutSubviewsEffectively:YES];
    self.showsHorizontalScrollIndicator = showsHorizontalScrollIndicator;
    self.showsVerticalScrollIndicator = showsVerticalScrollIndicator;
    CGFloat overflowLeft = 0, overflowTop = 0;
    if (self.frame.size.width < contentSize.width
        && self.hAlignment != UIControlContentHorizontalAlignmentLeft)
    {
        if (self.hAlignment == UIControlContentHorizontalAlignmentRight)
            overflowLeft = contentSize.width - self.frame.size.width;
        else // center
            overflowLeft = (contentSize.width - self.frame.size.width) / 2;
    }
    if (self.frame.size.height < contentSize.height
        && self.vAlignment != UIControlContentVerticalAlignmentTop)
    {
        if (self.vAlignment == UIControlContentVerticalAlignmentBottom)
            overflowTop = contentSize.height - self.frame.size.height;
        else // center
            overflowTop = (contentSize.height - self.frame.size.height) / 2;
    }
    self.contentSize = contentSize;
    self.contentInset = UIEdgeInsetsMake(overflowTop, overflowLeft,
                                         -overflowTop, -overflowLeft);
}

- (CGSize)sizeThatFits:(CGSize)size
{
    BOOL showsHorizontalScrollIndicator = self.showsHorizontalScrollIndicator;
    BOOL showsVerticalScrollIndicator = self.showsVerticalScrollIndicator;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    CGSize contentSize = [self layoutSubviewsEffectively:NO];
    self.showsHorizontalScrollIndicator = showsHorizontalScrollIndicator;
    self.showsVerticalScrollIndicator = showsVerticalScrollIndicator;    
    return contentSize;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.scrollEnabled == NO)
        [[self nextResponder] touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.scrollEnabled == NO)
        [[self nextResponder] touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.scrollEnabled == NO)
        [[self nextResponder] touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.scrollEnabled == NO)
        [[self nextResponder] touchesCancelled:touches withEvent:event];
}

- (void)addSubviewsHiddenObserver
{
    for (UIView *view in self.subviews) {
        @try {
            [view removeObserver:self forKeyPath:@"hidden" context:nil];
        }
        @catch (NSException * __unused exception) {}
        [view addObserver:self forKeyPath:@"hidden" options:0 context:nil];
    }
}

- (void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void*)context
{
    if ([keyPath isEqualToString:@"hidden"]) {
        [self setNeedsLayout];
    }
}

- (void)dealloc
{
    if(self.removeOnHide) {
        for (UIView *view in self.subviews) {
            @try {
                [view removeObserver:self forKeyPath:@"hidden" context:nil];
            }
            @catch (NSException * __unused exception) {}
        }
    }
}


@end
