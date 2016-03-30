
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TFLabelTextFieldCell : UITableViewCell<UITextFieldDelegate>

@property (nonatomic,strong) UILabel *label;
@property (nonatomic,strong) UITextField *textField;

@end