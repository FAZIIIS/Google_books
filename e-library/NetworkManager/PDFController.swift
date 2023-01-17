//
//  PDFController.swift
//  Google Books
//
//  Created by Iskandar Fazliddinov on 06/01/23.
//

import Foundation
import UIKit
import SnapKit
import WebKit

class PDFController: UIViewController {
    
    let webView = WKWebView()
    
    func setupUIElements() {
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func loadRequest(url: String) {
        guard let url = URL(string: url) else { return }
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    init(requetURL: String) {
        super.init(nibName: nil, bundle: nil)
        setupUIElements()
        loadRequest(url: requetURL)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
