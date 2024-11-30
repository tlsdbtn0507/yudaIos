//
//  ViewController.swift
//  Yuda
//
//  Created by 신유수 on 11/30/24.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("ViewController: Loaded!")

        // 배경색 설정
        view.backgroundColor = .white

        // 간단한 UILabel 추가
        let label = UILabel()
        label.text = "Hello, World!"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(label)

        // Auto Layout 설정
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
