#import <UIKit/UIKit.h>
#import "WebKit/WebKit.h"
#import <JavaScriptCore/JavaScriptCore.h>

// 实现WKScriptMessageHandler方法
@interface ViewController : UIViewController<WKScriptMessageHandler>
// 存储webview 对象
@property (strong, nonatomic) WKWebView * _webview;

@end

