//
//  ChatControllerSocketConnectionHandler.swift
//  Rocket.Chat
//
//  Created by Rafael Kellermann Streit on 17/12/16.
//  Copyright © 2016 Rocket.Chat. All rights reserved.
//

import UIKit

extension ChatViewController: SocketConnectionHandler {

    func socketDidConnect(socket: SocketManager) {
        chatHeaderViewOffline?.removeFromSuperview()

        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.reconnect), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        SocketManager.addConnectionHandler(token: socketHandlerToken, handler: self)
        
        DispatchQueue.main.async { [weak self] in
            if let subscription = self?.subscription {
                self?.subscription = subscription
                
                guard let auth = AuthManager.isAuthenticated() else { return }
                let subscriptions = auth.subscriptions.sorted(byKeyPath: "lastSeen", ascending: false)
                //
                let rid = UserDefaults.standard.string(forKey: "ridString")
                let value = UserDefaults.standard.bool(forKey: "notification")
                
                if (value)
                {
                    for var test in subscriptions
                    {
                        if (test.rid == rid)
                        {
                            self?.subscription = test
                            UserDefaults.standard.set(false, forKey: "notification")
                            UserDefaults.standard.synchronize()
                        }
                    }
                }
            }
        }

        rightButton.isEnabled = true
    }

    func socketDidDisconnect(socket: SocketManager) {
        chatHeaderViewOffline?.removeFromSuperview()

        if let headerView = ChatHeaderViewOffline.instantiateFromNib() {
            headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: headerView.frame.height)
            view.addSubview(headerView)
            chatHeaderViewOffline = headerView
        }
    }

}
