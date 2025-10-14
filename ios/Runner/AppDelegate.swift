import UIKit
import Flutter
import NaverThirdPartyLogin  // 네이버 로그인 import 추가

@main
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    // 네이버 로그인을 위한 URL 처리 메서드 추가
    override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        var applicationResult = false

        // 네이버 로그인 처리
        if (!applicationResult) {
            applicationResult = NaverThirdPartyLoginConnection.getSharedInstance().application(app, open: url, options: options)
        }

        // 다른 URL 처리가 필요한 경우를 위한 기본 처리
        if (!applicationResult) {
            applicationResult = super.application(app, open: url, options: options)
        }
        return applicationResult
    }
}