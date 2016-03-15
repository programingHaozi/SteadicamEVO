#import "UILabel+dynamicSizeMe.h"

@implementation UILabel (dynamicSizeMe)

-(float)resizeToFit{
    float height = [self expectedHeight];
    CGRect newFrame = [self frame];
    newFrame.size.height = height;
    [self setFrame:newFrame];
    return newFrame.origin.y + newFrame.size.height;
}

-(float)expectedHeight{
    [self setNumberOfLines:0];
    [self setLineBreakMode:NSLineBreakByWordWrapping];

//    CGSize maximumLabelSize = CGSizeMake(self.frame.size.width,9999);
    
    CGSize expectedLabelSize = [[self text] boundingRectWithSize:self.frame.size options:NSStringDrawingUsesLineFragmentOrigin attributes:nil context:nil].size;
    return expectedLabelSize.height;
}

-(float)expectedAWidth{
    [self setNumberOfLines:1];
    [self setLineBreakMode:NSLineBreakByCharWrapping];
    
    CGSize maximumLabelSize = CGSizeMake(9999,self.frame.size.height);
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = self.lineBreakMode;
    CGSize expectedLabelSize = [[self text] boundingRectWithSize:maximumLabelSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[self font],NSParagraphStyleAttributeName : paragraphStyle} context:nil].size;
    
//    CGSize expectedLabelSize = [[self text] sizeWithFont:[self font]
//                                       constrainedToSize:maximumLabelSize
//                                           lineBreakMode:[self lineBreakMode]];
    return expectedLabelSize.height;
}

@end
