
#import "TFLabelTextViewCell.h"

@implementation TFLabelTextViewCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	if(!(self=[super initWithStyle:style reuseIdentifier:reuseIdentifier])) return nil;
    
    _label = [[UILabel alloc] initWithFrame:CGRectZero];
    _label.backgroundColor = [UIColor clearColor];
    _label.textAlignment = NSTextAlignmentRight;
    _label.textColor = [UIColor blackColor];
    _label.highlightedTextColor = [UIColor whiteColor];
    _label.font = [UIFont boldSystemFontOfSize:12.0];
    _label.adjustsFontSizeToFitWidth = YES;
    _label.baselineAdjustment = UIBaselineAdjustmentNone;
    _label.numberOfLines = 20;
    [self.contentView addSubview:_label];
    
    _textView = [[UITextView alloc] initWithFrame:CGRectZero];
	_textView.contentInset = UIEdgeInsetsZero;
	_textView.backgroundColor = [UIColor clearColor];

    [self.contentView addSubview:_textView];
	
    return self;
}

- (id) initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier
{
	self = [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
	return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
	
    CGRect r = CGRectInset(self.contentView.bounds, 8, 8);
    r.size = CGSizeMake(72,27);
    _label.frame = r;
    
    r = CGRectInset(self.contentView.bounds, 8, 8);
	CGFloat wid = CGRectGetWidth(self.label.frame);
	r.origin.x += wid;
	r.size.width -= wid;
	_textView.frame = r;

}

- (void) setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
	[self _colorText:selected animated:animated];
}

- (void) setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
	[super setHighlighted:highlighted animated:animated];
	[self _colorText:highlighted animated:animated];
}

#pragma mark- private method

- (void) _colorText:(BOOL)active animated:(BOOL)animated
{
    if(animated)
    {
        [UIView beginAnimations:nil context:nil];
    }
    _textView.textColor = active ? [UIColor whiteColor] : [UIColor grayColor];
    if(animated)
    {
        [UIView commitAnimations];
    }
}

@end
