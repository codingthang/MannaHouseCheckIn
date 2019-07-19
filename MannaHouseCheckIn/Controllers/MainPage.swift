//
//  MainPage.swift
//  MannaHouseCheckIn
//
//  Created by JubalThang on 7/18/19.
//  Copyright © 2019 Jubal. All rights reserved.
//

import UIKit
import WebKit
import Firebase

class MainPage: UIViewController {
    
    // Variables
    var currentCampus = [Campus]()
    var segmentedTitles = [String]()
    let fireStore = FireStoreFetch()
    var web = WKWebView()
    var hrefs = [String]()
    let webViewContainer = UIView()
    let backBtn = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(goBack))
    var campusLocation = "rockey_butte"
    
    // Hide status bar
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set background white color
        view.backgroundColor = .white
        
        navigationController?.hidesBarsOnSwipe = true
        navigationController?.navigationBar.isTranslucent = false
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        // Fetch FireStore Data
        fetchFireStoreData()
    }
    
    private func setupCustomNavBar(buttonsTitles: [String]) {
        let frame = CGRect(x: 0, y: 44, width: view.frame.width, height: 44)
        let segmentedButtons = CustomSegmentedControl(frame: frame, buttonTitles: buttonsTitles)
        segmentedButtons.mainPage = self
        navigationItem.titleView = segmentedButtons
    }
    
    @objc func updateIndex(index: Int) {
        setupWebBroswser(index: index)
    }
    
    private func fetchFireStoreData() {
        fireStore.fetchFireStore(location: campusLocation) { campus in
            self.currentCampus = campus
            self.setupViews()
        }
    }
    
    private func setupViews() {
        // Views come here
        currentCampus.forEach { (campus) in
            if let title = campus.campusInfo.title?.uppercased(){
                self.segmentedTitles.append(title)
                guard let url = campus.campusInfo.href else {return}
                self.hrefs.append(url)
            }
        }
        setupCustomNavBar(buttonsTitles: segmentedTitles)
        
        setupWebBrowserContainer()
        
        setupWebBroswser(index: 0)
    }
    
    private func setupWebBrowserContainer() {
        webViewContainer.backgroundColor = .yellow
        view.addSubview(webViewContainer)
        webViewContainer.anchor(top: view.safeAreaLayoutGuide.topAnchor, right: view.trailingAnchor, bottom: view.bottomAnchor, left: view.leadingAnchor, centerX: nil, centerY: nil, size: .zero, padding: .zero)
        createWebToolbar()
    }
    
    private func createWebToolbar() {
        let toolbar = UIToolbar()
        toolbar.tintColor = .black
        let campusName = UIBarButtonItem(title: "Campus: \(campusLocation)", style: .plain, target: self, action: #selector(handleCampusLocationChange))
        
        let flexi = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.items = [backBtn,flexi,campusName,flexi,backBtn]
        webViewContainer.addSubview(toolbar)
        
        toolbar.anchor(top: nil, right: webViewContainer.trailingAnchor, bottom: webViewContainer.bottomAnchor, left: webViewContainer.leadingAnchor, centerX: nil, centerY: nil, size: .init(width: 0, height: 44), padding: .init(top: 0, left: 0, bottom: 0, right: 0))
    }
    
    func setupWebBroswser(index: Int) {
        
        guard let url = URL(string: hrefs[index]) else {return}
        let reuquest = URLRequest(url: url)

        webViewContainer.addSubview(web)
        web.load(reuquest)
        web.anchor(top: webViewContainer.topAnchor, right: webViewContainer.trailingAnchor, bottom: webViewContainer.bottomAnchor, left: webViewContainer.leadingAnchor, centerX: nil, centerY: nil, size: .zero, padding: .init(top: 2, left: 0, bottom: 44, right: 0))
    }
    
    // MARK: Handle campus location change
    @objc func handleCampusLocationChange() {
        print("Want to change campus?")
    }
    
    // Goback function for Broswer
    @objc func goBack() {
        if web.canGoBack {
            web.goBack()
        }
    }
}
