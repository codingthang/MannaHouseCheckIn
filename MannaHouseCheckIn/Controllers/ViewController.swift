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
    
    var dummyCampus = [Campus]()
    var buttons = [UIButton]()
    let fireStore = FireStoreFetch()
    var stack = UIStackView()
    var web = WKWebView()
    var hrefs = [String]()
    let webViewContainer = UIView()
    let backBtn = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(goBack))
    var campusLocation = "rockey_butte"
   
    
    
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
            self.dummyCampus = campus
            self.setupViews()
        }
    }
    
    private func setupViews() {
    
        var index = 0
        
        dummyCampus.forEach { (campus) in
            let b = UIButton(type: .system)
            b.setTitle(campus.campusInfo.title?.uppercased(), for: .normal)
            b.setTitleColor(UIColor.white, for: .normal)
            b.tag = index
            b.backgroundColor = index%2 == 0 ? UIColor.primaryColor : UIColor.secondaryColor
            b.addTarget(self, action: #selector(handleWebView), for: .touchUpInside)
            index += 1
            self.buttons.append(b)
            
            if let url = campus.campusInfo.href {
                hrefs.append(url)
            }
            
        }
       
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
        }
    }
    private func createWebToolbar() {
       
        let toolbar = UIToolbar()
        toolbar.tintColor = .black
        let campusName = UIBarButtonItem(title: campusLocation, style: .plain, target: self, action: #selector(handleCampus))
        
        let flexi = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.items = [backBtn,flexi,campusName,flexi,backBtn]
        webViewContainer.addSubview(toolbar)
        
        toolbar.anchor(top: nil, right: webViewContainer.trailingAnchor, bottom: webViewContainer.bottomAnchor, left: webViewContainer.leadingAnchor, centerX: nil, centerY: nil, size: .init(width: 0, height: 44), padding: .init(top: 0, left: 0, bottom: 0, right: 0))
    }
    
    @objc func handleCampus() {
        print("change location")
    }
    
    @objc func handleWebView(b: UIButton) {
        web.backForwardList.perform(Selector(("_removeAllItems")))
//        web.load(URLRequest(url: URL(string:"about:blank")!))
        loadingWebPage(urlString: hrefs[b.tag])
    }
    
    @objc func goBack() {
        if web.canGoBack {
            web.goBack()
           
        }
    }
    
    private func loadingWebPage(urlString: String?) {
        if let url = urlString {
            guard let url = URL(string: url) else {return}
            let reuquest = URLRequest(url: url)
            
            web.load(reuquest)
            
            web.anchor(top: webViewContainer.topAnchor, right: webViewContainer.trailingAnchor, bottom: webViewContainer.bottomAnchor, left: webViewContainer.leadingAnchor, centerX: nil, centerY: nil, size: .zero, padding: .init(top: 2, left: 0, bottom: 44, right: 0))
        }
    }
    
    private var activityContainer = UIView()
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        checkIfcanGoback()
       activityContainer.removeFromSuperview()
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
       
//        webViewDidStartLoad(webView_Pages: webView)
        checkIfcanGoback()
        
    }
    
    private func checkIfcanGoback() {
        if web.canGoBack {
            backBtn.tintColor = .black
        }else {
            backBtn.tintColor = .lightGray
        }
    }
    
    
    private func webViewDidStartLoad(webView_Pages: WKWebView) {
        // Box config:
       
        let activitityIndicatorView = UIActivityIndicatorView()
        
        activityContainer = UIView(frame: CGRect(x: 115, y: 110, width: 80, height: 80))
        activityContainer.backgroundColor = UIColor(white: 0, alpha: 0.08)
        activityContainer.layer.cornerRadius = 10
        
        // Spin config:
        activitityIndicatorView.color = .black
        activitityIndicatorView.frame = CGRect(x: 20, y: 12, width: 40, height: 40)
        activitityIndicatorView.startAnimating()
        
        
        // Text config:
        let textLabel = UILabel(frame: CGRect(x: 0, y: 50, width: 80, height: 30))
        textLabel.textColor = .black
        textLabel.textAlignment = .center
        textLabel.font = UIFont(name: textLabel.font.fontName, size: 13)
        textLabel.text = "Loading..."
        
        // Activate:
        activityContainer.addSubview(activitityIndicatorView)
        activityContainer.addSubview(textLabel)
        view.addSubview(activityContainer)
        activityContainer.anchor(top: nil, right: nil, bottom: nil, left: nil, centerX: view.centerXAnchor, centerY: view.centerYAnchor, size: .zero, padding: .zero)
    }
}

