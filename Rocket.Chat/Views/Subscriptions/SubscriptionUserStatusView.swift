//
//  SubscriptionUserStatusView.swift
//  Rocket.Chat
//
//  Created by Rafael Kellermann Streit on 13/02/17.
//  Copyright © 2017 Rocket.Chat. All rights reserved.
//

import UIKit
import SideMenu

protocol SubscriptionUserStatusViewProtocol: class {
    func userDidPressedOption()
}

final class SubscriptionUserStatusView: UIView {

    weak var delegate: SubscriptionUserStatusViewProtocol?
    weak var parentController: UIViewController?

    @IBOutlet weak var buttonOnline: UIButton!
    @IBOutlet weak var labelOnline: UILabel! {
        didSet {
            labelOnline.text = localizedString("user_menu.online")
        }
    }

    @IBOutlet weak var buttonAway: UIView!
    @IBOutlet weak var labelAway: UILabel! {
        didSet {
            labelAway.text = localizedString("user_menu.away")
        }
    }

    @IBOutlet weak var buttonBusy: UIView!
    @IBOutlet weak var labelBusy: UILabel! {
        didSet {
            labelBusy.text = localizedString("user_menu.busy")
        }
    }

    @IBOutlet weak var buttonInvisible: UIView!
    @IBOutlet weak var labelInvisible: UILabel! {
        didSet {
            labelInvisible.text = localizedString("user_menu.invisible")
        }
    }

    @IBOutlet weak var buttonSettings: UIView!
    @IBOutlet weak var labelSettings: UILabel! {
        didSet {
            labelSettings.text = localizedString("user_menu.settings")
        }
    }

    @IBOutlet weak var imageViewSettings: UIImageView! {
        didSet {
            imageViewSettings.image = imageViewSettings.image?.imageWithTint(.RCLightBlue())
        }
    }

    @IBOutlet weak var buttonLogout: UIView!
    @IBOutlet weak var labelLogout: UILabel! {
        didSet {
            labelLogout.text = localizedString("user_menu.logout")
        }
    }

    @IBOutlet weak var imageViewLogout: UIImageView! {
        didSet {
            imageViewLogout.image = imageViewLogout.image?.imageWithTint(.RCLightBlue())
        }
    }

    // MARK: IBAction

    @IBAction func buttonOnlineDidPressed(_ sender: Any) {
        UserManager.setUserStatus(status: .online) { [weak self] (_) in
            self?.delegate?.userDidPressedOption()
        }
    }

    @IBAction func buttonAwayDidPressed(_ sender: Any) {
        UserManager.setUserStatus(status: .away) { [weak self] (_) in
            self?.delegate?.userDidPressedOption()
        }
    }

    @IBAction func buttonBusyDidPressed(_ sender: Any) {
        UserManager.setUserStatus(status: .busy) { [weak self] (_) in
            self?.delegate?.userDidPressedOption()
        }
    }

    @IBAction func buttonInvisibleDidPressed(_ sender: Any) {
        UserManager.setUserStatus(status: .offline) { [weak self] (_) in
            self?.delegate?.userDidPressedOption()
        }
    }

    @IBAction func buttonSettingsDidPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Settings", bundle: Bundle.main)

        if let controller = storyboard.instantiateInitialViewController() {
            controller.modalPresentationStyle = .formSheet
            parentController?.present(controller, animated: true, completion: nil)
        }

        self.delegate?.userDidPressedOption()
    }

    @IBAction func buttonLogoutDidPressed(_ sender: Any) {
        AuthManager.logout {
            let storyboardChat = UIStoryboard(name: "Main", bundle: Bundle.main)
            let controller = storyboardChat.instantiateInitialViewController()
            let application = UIApplication.shared

            if let window = application.keyWindow {
                window.rootViewController = controller
                window.makeKeyAndVisible()
            }
        }
    }

}
