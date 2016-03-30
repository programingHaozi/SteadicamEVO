
#import "TFLabelTextFieldCell.h"

@implementation TFLabelTextFieldCell


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
    
    _textField = [[UITextField alloc] initWithFrame:CGRectZero];
	_textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	_textField.backgroundColor = [UIColor clearColor];
    _textField.font = [UIFont boldSystemFontOfSize:16.0];
    _textField.delegate = self;
    [self.contentView addSubview:_textField];
		
    
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
	r.origin.x += wid + 6;
	r.size.width -= wid + 6;
	_textField.frame = r;
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
	[_textField resignFirstResponder];
	return NO;
}

- (void) setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
	if(animated)
    {
		[UIView beginAnimations:nil context:nil];
    }
	_textField.textColor = selected ? [UIColor whiteColor] : [UIColor blackColor];
	if(animated)
    {
		[UIView commitAnimations];
    }
}

- (void) setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
	[super setHighlighted:highlighted animated:animated];
	
	if(animated)
    {
		[UIView beginAnimations:nil context:nil];
    }
	_textField.textColor = highlighted ? [UIColor whiteColor] : [UIColor blackColor];
	if(animated)
    {
		[UIView commitAnimations];
    }
}

@end
