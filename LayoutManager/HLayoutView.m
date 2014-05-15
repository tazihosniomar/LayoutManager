#import "HLayoutView.h"

@implementation HLayoutView

- (CGSize)layoutSubviewsEffectively:(BOOL)effectively
{
    int total_width = self.leftMargin, max_height = 0, nbSubViews = 0;
    for (UIView *child in self.subviews)
    {
        if((self.removeOnHide == YES && child.hidden == NO)  || self.removeOnHide == NO) {
            nbSubViews++;
            total_width += child.frame.size.width;
            if (max_height < child.frame.size.height)
                max_height = child.frame.size.height;
        }
    }
    total_width += (nbSubViews - 1) * self.spacing + self.rightMargin;
    if (effectively == YES)
    {
        int left, top, baseline = (self.frame.size.height - self.topMargin
                                   - self.bottomMargin) / 2 + self.topMargin;
        switch (self.hAlignment)
        {
            case UIControlContentHorizontalAlignmentLeft:
                left = self.leftMargin;
                break;
            case UIControlContentHorizontalAlignmentRight:
                left = self.frame.size.width - total_width + self.leftMargin;
                break;
            default: // center
                left = self.frame.size.width / 2 - total_width / 2 + self.leftMargin;
                break;
        }
        left -= self.spacing;
        for (UIView *child in self.subviews)
        {
            if((self.removeOnHide == YES && child.hidden == NO)  || self.removeOnHide == NO) {
                left += self.spacing;
                switch (self.vAlignment)
                {
                    case UIControlContentVerticalAlignmentTop:
                        top = self.topMargin;
                        break;
                    case UIControlContentVerticalAlignmentBottom:
                        top = self.frame.size.height - self.bottomMargin
                        - child.frame.size.height;
                        break;
                    default: // center
                        top = baseline - child.frame.size.height / 2;
                        break;
                }
                child.frame = CGRectMake(left, top, child.frame.size.width,
                                         child.frame.size.height);
                left += child.frame.size.width;
            }
        }
    }
    return CGSizeMake(total_width, self.topMargin + max_height + self.bottomMargin);
}

@end
