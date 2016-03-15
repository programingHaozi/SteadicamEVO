
#import <objc/runtime.h>
#import "UITextView+Placeholder.h"

@implementation UITextView (Placeholder)

#pragma mark - Swizzle Dealloc

+ (void)load
{
    [super load];

    // is this the best solution?
    method_exchangeImplementations(class_getInstanceMethod(self.class, NSSelectorFromString(@"dealloc")),
                                   class_getInstanceMethod(self.class, @selector(swizzledDealloc)));
}

- (void)swizzledDealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    UILabel *label = objc_getAssociatedObject(self, @selector(placeholderLabel));
    
    if (label)
    {
        for (NSString *key in self.class.observingKeys)
        {
            @try
            {
                [self removeObserver:self forKeyPath:key];
            }
            @catch (NSException *exception)
            {
                // Do nothing
            }
        }
    }
    
    [self swizzledDealloc];
}

#pragma mark - `observingKeys`

+ (NSArray *)observingKeys {
    
    return @[
             @"attributedText",
             @"bounds",
             @"font",
             @"frame",
             @"text",
             @"textAlignment",
             @"textContainerInset"
             ];
}


#pragma mark - Properties
#pragma mark `placeholderLabel`

- (UILabel *)placeholderLabel
{
    UILabel *label = objc_getAssociatedObject(self, @selector(placeholderLabel));
    
    if (!label)
    {
        NSAttributedString *originalText = self.attributedText;
        self.text = @" "; 
        self.attributedText = originalText;

        label = [[UILabel alloc] init];
        label.textColor = [UIColor lightGrayColor];
        label.font=[UIFont systemFontOfSize:14];
        label.numberOfLines = 0;
        label.userInteractionEnabled = NO;
        
        objc_setAssociatedObject(self, @selector(placeholderLabel), label, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(updatePlaceholderLabel)
                                                     name:UITextViewTextDidChangeNotification
                                                   object:self];

        for (NSString *key in self.class.observingKeys)
        {
            [self addObserver:self
                   forKeyPath:key
                      options:NSKeyValueObservingOptionNew
                      context:nil];
        }
    }
    
    return label;
}

#pragma mark `placeholder`

- (NSString *)placeholder
{
    return self.placeholderLabel.text;
}

- (void)setPlaceholder:(NSString *)placeholder
{
    self.placeholderLabel.text = placeholder;
    
    [self updatePlaceholderLabel];
}

#pragma mark `placeholderColor`

- (UIColor *)placeholderColor
{
    return self.placeholderLabel.textColor;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    self.placeholderLabel.textColor = placeholderColor;
}

#pragma mark `placeholderFont`

- (UIFont *)placeholderFont
{
    return self.placeholderLabel.font;
}

- (void)setPlaceholderFont:(UIFont *)placeholderFont
{
    self.placeholderLabel.font = placeholderFont;
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    [self updatePlaceholderLabel];
}

#pragma mark - Update

- (void)updatePlaceholderLabel
{
    if (self.text.length)
    {
        [self.placeholderLabel removeFromSuperview];
        
        return;
    }

    [self insertSubview:self.placeholderLabel atIndex:0];

    self.placeholderLabel.font          = self.font;
    self.placeholderLabel.textAlignment = self.textAlignment;

    CGFloat lineFragmentPadding = self.textContainer.lineFragmentPadding;;
    UIEdgeInsets textContainerInset = self.textContainerInset;;


    CGFloat x = lineFragmentPadding + textContainerInset.left;
    CGFloat y = textContainerInset.top;
    
    CGFloat width = CGRectGetWidth(self.bounds) - x - lineFragmentPadding - textContainerInset.right;
    CGFloat height = [self.placeholderLabel sizeThatFits:CGSizeMake(width, 0)].height;
    
    self.placeholderLabel.frame = CGRectMake(x, y, width, height);
}

@end
