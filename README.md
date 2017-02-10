# LabeledActivityIndicatorView
UIActivityIndicatorView with a label which can be added to UIButton and UINavigationBar.UINavigationItem

## 给导航栏添加类似于微信的小菊花

先上一张微信聊天界面导航栏表示网络请求的效果图

![Wechat](https://github.com/camoufleur/LabeledActivityIndicatorView/blob/master/Images/weChat.png?raw=true)

再放一张最终的效果图

![UIActivityIndicatorView](https://github.com/camoufleur/LabeledActivityIndicatorView/blob/master/Images/Demo.gif?raw=true)

以下要做的就是给`UIActivityIndicatorView`添加一个注释，来实现微信`NavigationBar`上的效果，不多说，撸代码：

- **LabeledActivityIndicatorView.h**文件

        @interface LabeledActivityIndicatorView : UIView
        /**
        指定activityIndicatorView的style的初始化方式，也可直接[LabeledActivityIndicatorView new]创建
    
        @param style 只有 UIActivityIndicatorViewStyleWhite或者 UIActivityIndicatorViewStyleGray 可选，默认为UIActivityIndicatorViewStyleGray
        */
    	- (instancetype)initWithActivityIndicatorViewStyle:(UIActivityIndicatorViewStyle)style;

    	/**
    	设置小菊花后边的文字

    	@param description 需要显示的文字
    	@param font 字体大小样式（为nil时默认为第一次设置的大小，未设置过则为默认的17号字体）
    	@param color 字体颜色（为nil时默认为第一次设置的颜色，未设置过则为黑色）
    	*/
        - (void)setDescription:(NSString *)description font:(UIFont *)font color:(UIColor *)color;

    	/**
    	开始旋转
    	*/
   		 - (void)startRotation;

    	/**
    	停止旋转并隐藏小菊花
    	*/
    	- (void)stopRotation;

    	/**
    	停止旋转，隐藏小菊花并显示完成图标“success.png”
    	*/
    	- (void)stopRotationWithDone;

    	/**
    	将该view移除，如果父视图为button，则自动恢复button的原title
    	*/
    	- (void)stopRotationWithFaild;

    	@end
    
- LabeledActivityIndicatorView.m

		@interface LabeledActivityIndicatorView()

		@property (nonatomic, strong) UIActivityIndicatorView *aiView;
		@property (nonatomic, strong) UILabel *label;
		@property (nonatomic, assign) CGFloat labelWidth;

		@property (nonatomic, weak) UIImageView *suc;

		@property (nonatomic, strong) NSString *buttonTitle;

		@end

		@implementation LabeledActivityIndicatorView

		- (instancetype)initWithFrame:(CGRect)frame {
    	if (self = [super initWithFrame:frame]) {
        [self addSubViewsWithStyle:UIActivityIndicatorViewStyleGray];
    	}
    	return self;
		}

		- (instancetype)initWithActivityIndicatorViewStyle:(UIActivityIndicatorViewStyle)style {
   		   if (self = [super init]) {
        	  [self addSubViewsWithStyle:style];
    	   }
   		   return self;
	    }

		- (void)addSubViewsWithStyle:(UIActivityIndicatorViewStyle)style {
    
    	self.userInteractionEnabled = NO;
    	if (style == UIActivityIndicatorViewStyleWhiteLarge) style = UIActivityIndicatorViewStyleGray;
    	_aiView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:style];
    	_aiView.frame = CGRectMake(0, 0, 20, 20);
    	_aiView.hidesWhenStopped = YES;
    	[self addSubview:_aiView];
    
    	_label = [UILabel new];
    	_label.backgroundColor = [UIColor clearColor];
    	[self addSubview:_label];
		}

		- (void)setDescription:(NSString *)description font:(UIFont *)font color:(UIColor *)color {
    	if ([self.superview isKindOfClass:[UIButton class]]) {
        self.buttonTitle = [((UIButton *)(self.superview)).titleLabel.text copy];
        [((UIButton *)(self.superview)) setTitle:nil forState:UIControlStateNormal];
    	}
		//    else if ([self.superview isKindOfClass:[UINavigationBar class]]) {
		//        self.buttonTitle = ((UINavigationBar *)(self.superview)).items.firstObject.title;
		//    } // 暂时不适配导航栏 需要手动回复title
   		_label.text = description;
    	if (font) _label.font = font;
    	if (color) _label.textColor = color;
    	[self updateLayout];
		}

		- (void)updateLayout{
   		    CGFloat superViewWidth = self.superview.frame.size.width;
    	    CGRect rect = self.frame;
    		rect.size.height = _aiView.frame.size.height;
    		CGFloat aiViewWidth = _aiView.hidden ? 0 : 			_aiView.frame.size.width + 3;
    		CGFloat sucWidth = _suc ? 23 : 0;
    		rect.size.width = aiViewWidth + self.labelWidth + sucWidth;
    		if (rect.size.width > superViewWidth && superViewWidth > 0) {
       		 rect.size.width = superViewWidth;
    		}
    		self.frame = rect;
    		self.center = CGPointMake(superViewWidth * 0.5, self.superview.frame.size.height * 0.5);
    		_label.frame = CGRectMake(aiViewWidth + sucWidth, 0, rect.size.width - aiViewWidth - sucWidth, _aiView.frame.size.height);
    		[self setNeedsLayout];
		}

		- (CGFloat)labelWidth {
    		NSString *str = _label.text;
    		NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    		attrs[NSFontAttributeName] = _label.font;
    		CGFloat width =  [str boundingRectWithSize:CGSizeMake(0, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size.width;
    		return width;
		}

		- (void)startRotation {
   		 	_aiView.hidden = NO;
    		[_suc removeFromSuperview];
    		_suc = nil;
    		[self.aiView startAnimating];
    		[self updateLayout];
		}

		- (void)stopRotation {
    		[_aiView stopAnimating];
    		[self updateLayout];
		}

		- (void)stopRotationWithDone {
    		[_suc removeFromSuperview];
    		UIImageView *suc = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    		suc.image = [UIImage imageNamed:@"success.png"];
    		self.aiView.hidden = YES;
    		[self addSubview:suc];
    		_suc = suc;
    		[self updateLayout];
		}

		- (void)stopRotationWithFaild {
    		if ([self.superview isKindOfClass:[UIButton class]]) {
        		[(UIButton *)self.superview setTitle:self.buttonTitle forState:UIControlStateNormal];
    		}
		//    else if ([self.superview isKindOfClass:[UINavigationBar class]]) {
		//        ((UINavigationBar *)(self.superview)).items.firstObject.title = 		self.buttonTitle;
		//    } // 暂时不适配导航栏
    		[self removeFromSuperview];
		}

		@end
		
- 喜欢的给个Star吧.
- 简书个人主页[Camoufleur](http://www.jianshu.com/u/5eb32816c254)