import UIKit
import WebKit

class ViewController: UIViewController {
    var scrollView: UIScrollView!
    var topView: UIView!
    var webView: WKWebView!
    var bottomView: UIView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.scrollView = UIScrollView(frame: self.view.bounds)
        self.view.addSubview(self.scrollView)
        
        self.topView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 100))
        self.topView.backgroundColor = .gray
        self.webView = WKWebView(frame: CGRect(x: 0, y: topView.frame.height, width: self.view.bounds.width, height: 500))
        self.webView.navigationDelegate = self
        self.webView.scrollView.transfersVerticalScrollingToParent = true
        
        self.bottomView = UIView(frame: CGRect(
            x: 0,
            y: webView.frame.maxY,
            width: self.view.bounds.width,
            height: 100))
        self.bottomView.backgroundColor = .purple
        
        self.scrollView.addSubview(self.topView)
        self.scrollView.addSubview(self.webView)
        self.scrollView.addSubview(self.bottomView)
                
        self.scrollView.contentSize = CGSize(width: self.view.bounds.width, height: self.bottomView.frame.maxY)
        self.webView.loadHTMLString(lipsum, baseURL: nil)
    }
    
    private func updateViews(webViewHeight: Double) {
        self.webView.frame.size.height = webViewHeight
        self.bottomView.frame.origin.y = self.webView.frame.maxY
        self.scrollView.contentSize = CGSize(width: self.view.bounds.width, height: self.bottomView.frame.maxY)
    }
}
    
extension ViewController: WKNavigationDelegate
{
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        guard !webView.isLoading else { return }
        webView.evaluateJavaScript("document.body.scrollHeight", completionHandler: { height, error in
                if let height = height as? Double {
                    let scrollViewHeight = height / 2
                    self.updateViews(webViewHeight: scrollViewHeight)
                } else {
                    debugPrint("Can't read size")
                }
        })
    }
}
let lipsum = """
<div style="font-size:48px">
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse eu lobortis dui. Nullam tempor varius erat vel hendrerit. Fusce ac scelerisque nisl. Aenean congue, lectus quis molestie tristique, velit enim posuere massa, imperdiet congue purus metus non justo. Suspendisse vitae accumsan dui, at efficitur augue. Quisque ut leo ut libero egestas auctor. Aliquam ultrices eleifend molestie. Cras quis sapien ac velit aliquet gravida. Duis porta orci sit amet tortor tristique, at volutpat urna elementum. In tristique ut urna sed laoreet. Mauris et turpis laoreet, congue leo eu, tempus ante.

Donec fringilla varius libero ac elementum. Suspendisse dignissim est sed sagittis iaculis. Ut a feugiat nibh. Etiam dictum commodo tellus, vitae laoreet justo blandit ac. Proin tincidunt dapibus ornare. Aenean sagittis, erat id vestibulum iaculis, quam erat luctus augue, non vestibulum tellus mi vitae metus. Ut sollicitudin vulputate bibendum. Integer id scelerisque turpis. Nam vestibulum augue erat. Vestibulum commodo gravida est vitae ultricies. Morbi vel consequat ligula. Pellentesque cursus hendrerit sollicitudin. Suspendisse ac volutpat justo. Donec justo elit, posuere a quam sit amet, condimentum sodales sapien.

Proin sollicitudin efficitur laoreet. Nulla vulputate ex ac elit vestibulum, in laoreet est accumsan. Suspendisse eget arcu at arcu venenatis tristique. Ut est dolor, vulputate ut scelerisque quis, tempus nec velit. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer eleifend euismod augue, malesuada molestie massa tristique a. Duis diam nisi, ultrices vitae tortor eu, gravida dignissim nisl. Aliquam in elementum orci.

Aliquam libero justo, vulputate in convallis a, feugiat fringilla arcu. Phasellus scelerisque ligula metus, id bibendum nunc ultrices tincidunt. Duis eget molestie magna.
</div>
"""
