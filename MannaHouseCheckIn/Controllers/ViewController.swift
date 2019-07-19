//
//  ViewController.swift
//  MannaHouseCheckIn
//
//  Created by JubalThang on 7/16/19.
//  Copyright © 2019 Jubal. All rights reserved.
//

import UIKit
import Firebase
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {
    
    var currentCampus = [Campus]()
    var buttons = [UIButton]()
    let fireStore = FireStoreFetch()
    var stack = UIStackView()
    var web = WKWebView()
    var hrefs = [String]()
    let webViewContainer = UIView()
    let backBtn = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(goBack))
    let forwardBtn = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(goNext))
    var campusLocation = "rockey_butte"
    private var activityContainer = UIView()
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        
        initializeData()
       
    }

    private func initializeData(){
        fireStore.fetchFireStore(location: campusLocation) { (campus) in
            self.currentCampus = campus
            self.setupViews()
        }
    }
    
    private func setupViews() {
    
        var index = 0
        
        currentCampus.forEach { (campus) in
            let b = UIButton(type: .system)
            b.setTitle(campus.campusInfo.title?.uppercased(), for: .normal)
            b.tag = index
            b.backgroundColor = index%2 == 0 ? UIColor.primaryColor : UIColor.secondaryColor
            b.addTarget(self, action: #selector(handleWebView), for: .touchUpInside)
            b.alpha = 0.5
            b.setTitleColor(UIColor.init(white: 0, alpha: 0.5), for: .normal)
            index += 1
            self.buttons.append(b)
            
            if let url = campus.campusInfo.href {
                hrefs.append(url)
            }
            
        }
       
        buttons[0].setTitleColor(.white, for: .normal)
        buttons[0].alpha = 1
        
        addSubViews()
        loadingWebPage(urlString: hrefs[0])
    }
    
    private func addSubViews() {
        
        createWebToolbar()
        
        stack = UIStackView(arrangedSubviews: buttons)
        stack.distribution = .fillEqually
        
        view.addSubview(webViewContainer)
        webViewContainer.addSubview(web)
        view.addSubview(stack)
        
        web.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
        web.navigationDelegate = self
        
        web.allowsBackForwardNavigationGestures = true
        
        stack.anchor(top: view.safeAreaLayoutGuide.topAnchor, right: view.safeAreaLayoutGuide.trailingAnchor, bottom: nil, left: view.safeAreaLayoutGuide.leadingAnchor, centerX: nil, centerY: nil, size: .init(width: 0, height: 44), padding: .zero)
        
        webViewContainer.anchor(top: stack.bottomAnchor, right: view.safeAreaLayoutGuide.trailingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, left: view.safeAreaLayoutGuide.leadingAnchor)
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            web.alpha = CGFloat(web.estimatedProgress)
//            activityContainer.alpha = 1 - CGFloat(web.estimatedProgress)
        }
    }
    private func createWebToolbar() {
       
        let toolbar = UIToolbar()
        toolbar.tintColor = .black
        let campusName = UIBarButtonItem(title: campusLocation, style: .plain, target: self, action: #selector(handleCampus))
        
        let flexi = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.items = [backBtn,flexi,campusName,flexi,forwardBtn]
        webViewContainer.addSubview(toolbar)
        
        toolbar.anchor(top: nil, right: webViewContainer.trailingAnchor, bottom: webViewContainer.bottomAnchor, left: webViewContainer.leadingAnchor, centerX: nil, centerY: nil, size: .init(width: 0, height: 44), padding: .init(top: 0, left: 0, bottom: 0, right: 0))
    }
    
    @objc func handleCampus() {
        print("change location")
    }
    
    @objc func handleWebView(b: UIButton) {
        for button in buttons {
            button.alpha = 0.5
            button.setTitleColor(UIColor.init(white: 0, alpha: 0.5), for: .normal)
        }
        b.setTitleColor(.white, for: .normal)
        b.alpha = 1
        web.backForwardList.perform(Selector(("_removeAllItems")))
//        web.load(URLRequest(url: URL(string:"about:blank")!))
        loadingWebPage(urlString: hrefs[b.tag])
    }
    
    @objc func goBack() {
        if web.canGoBack {
            activityContainer.removeFromSuperview()
            web.goBack()
        }
    }
    
    @objc func goNext() {
        if web.canGoForward {
            activityContainer.removeFromSuperview()
            web.goForward()
        }
    }
    
    private func loadingWebPage(urlString: String?) {
        
        web.evaluateJavaScript("document.documentElement.remove()") { (_, err) in
            if let err = err {
                print("Problem clearing contents", err.localizedDescription)
                return
            }
        }
        if let url = urlString {
            guard let url = URL(string: url) else {return}
            let reuquest = URLRequest(url: url)
            
            web.load(reuquest)
            
            web.anchor(top: webViewContainer.topAnchor, right: webViewContainer.trailingAnchor, bottom: webViewContainer.bottomAnchor, left: webViewContainer.leadingAnchor, centerX: nil, centerY: nil, size: .zero, padding: .init(top: 2, left: 0, bottom: 44, right: 0))
        }
    }
    
   
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityContainer.removeFromSuperview()
        checkIfcanGoback()
        checkIfcanGoForward()
       
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        webViewDidStartLoad(webView_Pages: webView)
        checkIfcanGoback()
        checkIfcanGoForward()
    }
    
    private func checkIfcanGoback() {
        if web.canGoBack {
            backBtn.tintColor = .black
            activityContainer.removeFromSuperview()
        }else {
            backBtn.tintColor = .lightGray
        }
    }
    
    private func checkIfcanGoForward() {
        if web.canGoForward {
            forwardBtn.tintColor = .black
            activityContainer.removeFromSuperview()
        }else {
            forwardBtn.tintColor = .lightGray
        }
    }

    
    private func webViewDidStartLoad(webView_Pages: WKWebView) {
        // Box config:
        let activitityIndicatorView = UIActivityIndicatorView()
        
        activityContainer = UIView()
        activityContainer.backgroundColor =  UIColor.init(white: 0, alpha: 0.08)
        activityContainer.layer.cornerRadius = 10
        
        // Spin config:
        activitityIndicatorView.color = .gray
        activitityIndicatorView.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        activitityIndicatorView.startAnimating()
        
        
        // Text config:
        let textLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 30))
        textLabel.textColor = .black
        textLabel.textAlignment = .center
        textLabel.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        textLabel.text = "Loading..."
        
        let stack = UIStackView(arrangedSubviews: [activitityIndicatorView,textLabel])
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .fillEqually
        
        // Activate:
        activityContainer.addSubview(stack)
        stack.anchor(top: activityContainer.topAnchor, right: activityContainer.trailingAnchor, bottom: activityContainer.bottomAnchor, left: activityContainer.leadingAnchor)
        view.addSubview(activityContainer)
        activityContainer.anchor(top: nil, right: nil, bottom: nil, left: nil, centerX: webView_Pages.centerXAnchor, centerY: webView_Pages.centerYAnchor, size: .init(width: 80, height: 80), padding: .zero)
    }
}

