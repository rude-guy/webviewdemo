#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    printf("hello world\n");
    [self createButton];
    [self initWebView];
}

- (void)createButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(100, 100, 200, 40);
    button.layer.borderWidth = 1;
    [button setTitle:@"向webview发送消息" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

-(void)buttonClicked {
    [self._webview evaluateJavaScript:@"receiveNativeMessage('我是来自native的消息')" completionHandler:nil];
}

-(void)initWebView {
    [self createWebView];
    [self loadLocalHtml];
}

-(void)createWebView {
    // webview的配置
    WKWebViewConfiguration *webviewConfig = [[WKWebViewConfiguration alloc] init];
    // 监听webview发送到message
    [webviewConfig.userContentController addScriptMessageHandler:self name:@"JSBridge"];
    
    // 视图大小
    CGRect positionInfo = CGRectMake(10, 200, 350, 400);
    // 创建webview
    self._webview = [[WKWebView alloc] initWithFrame:positionInfo configuration:webviewConfig];
 
    self._webview.layer.borderWidth = 1;
    self._webview.layer.borderColor = [UIColor blackColor].CGColor;
    [self.view addSubview:self._webview];
}

// 接收用户发送到消息
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    if ([message.name isEqualToString:@"JSBridge"]) {
        NSString *body = message.body;
        printf("原生层接收到消息: %s\n", [body UTF8String]);
    }
}


-(void)loadGoogle {
    // 定义URL
    NSURL * url = [NSURL URLWithString:@"https://google.com"];
    // 请求地址
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    // 加载到webview中
    [self._webview loadRequest:request];
}

-(void)loadLocalHtml{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"pageFrame" ofType:@"html"];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self._webview loadRequest:request];
}

@end
