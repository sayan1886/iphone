#import <Foundation/Foundation.h>

@interface SpinnerWithText : UIView {
  UIActivityIndicatorView *spinner;
  UILabel *displayText;
}

@property (nonatomic, retain) UIActivityIndicatorView *spinner;
@property (nonatomic, retain) UILabel *displayText;

- (void)showTheSpinner:(NSString *)text;
- (void)hideTheSpinner:(NSString *)text;
- (void)displayMore;
- (void)displayCheckNew;

@end