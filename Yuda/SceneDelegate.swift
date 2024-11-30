//
//  SceneDelegate.swift
//  Yuda
//
//  Created by 신유수 on 11/30/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        print("SceneDelegate: Running!")
        guard let windowScene = (scene as? UIWindowScene) else { return }

        // UIWindow 초기화
        let window = UIWindow(windowScene: windowScene)
        
        // ViewController를 루트로 설정
        window.rootViewController = ViewController()
        self.window = window
        window.makeKeyAndVisible()
    }
}
