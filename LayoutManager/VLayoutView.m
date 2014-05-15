#import "VLayoutView.h"

@implementation VLayoutView

- (CGSize)layoutSubviewsEffectively:(BOOL)effectively
{
    int total_height = self.topMargin, max_width = 0, nbSubViews = 0;
    for (UIView *child in self.subviews)
    {
        if((self.removeOnHide == YES && child.hidden == NO)  || self.removeOnHide == NO) {
            nbSubViews++;
            total_height += child.frame.size.height;
            if (max_width < child.frame.size.width)
                max_width = child.frame.size.width;
        }
    }
    total_height += (nbSubViews - 1) * self.spacing + self.bottomMargin;
    if (effectively == YES)
    {
        int left, top, baseline = (self.frame.size.width - self.leftMargin
                                   - self.rightMargin) / 2 + self.leftMargin;
        switch (self.vAlignment)
        {
            case UIControlContentVerticalAlignmentTop:
                top = self.topMargin;
                break;
            case UIControlContentVerticalAlignmentBottom:
                top = self.frame.size.height - total_height + self.topMargin;
                break;
            default: // center
                top = self.frame.size.height / 2 - total_height / 2 + self.topMargin;
                break;
        }
        top -= self.spacing;
        for (UIView *child in self.subviews)
        {
            if((self.removeOnHide == YES && child.hidden == NO)  || self.removeOnHide == NO) {
                top += self.spacing;
                switch (self.hAlignment)
                {
                    case UIControlContentHorizontalAlignmentLeft:
                        left = self.leftMargin;
                        break;
                    case UIControlContentHorizontalAlignmentRight:
                        left = self.frame.size.width - self.rightMargin
                        - child.frame.size.width;
                        break;
                    default: // center
                        left = baseline - child.frame.size.width / 2;
                        break;
                }
                child.frame = CGRectMake(left, top, child.frame.size.width,
                                         child.frame.size.height);
                top += child.frame.size.height;
            }
        }
    }
    return CGSizeMake(self.leftMargin + max_width + self.rightMargin, total_height);
}

@end
