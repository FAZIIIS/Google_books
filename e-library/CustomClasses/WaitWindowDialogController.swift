//
//  WaitWindowDialogController.swift
//  Google Books
//
//  Created by Iskandar Fazliddinov on 17/01/23.
//

import Foundation
import UIKit
import Lottie
import SnapKit

class WaitWindowDialogController: UIViewController {
    
//MARK: - PROPERTIES
    
    var calls = 0
    
    
//MARK: - UI ELEMENTS
    
    private var animationView: AnimationView = {
        var view = AnimationView(name: "loadingAnimation")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.loopMode = .loop
        
        return view
    }()
    
    
//MARK: - METHODS
    
    private func activate() {
        calls = calls + 1
    }
    
    private func setupUIElements() {
        view.addSubview(animationView)
        
        animationView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.height.width.equalTo(400)
        }
    }
    

//MARK: - LYFE CYCLES
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUIElements()
        activate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        animationView.play(fromProgress: 0, toProgress: 3, loopMode: .loop, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.animationView.play(fromProgress: 0, toProgress: 3, loopMode: .loop, completion: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        animationView.stop()
    }
}

