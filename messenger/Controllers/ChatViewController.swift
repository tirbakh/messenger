//
//  ChatViewController.swift
//  messenger
//
//  Created by Лада Тирбах on 16.05.2021.
//

import UIKit
import MessageKit

struct Message: MessageType {
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
}

struct Sender: SenderType {
    var photoURL: String
    var senderId: String
    var displayName: String
}

class ChatViewController: MessagesViewController {
    
    private var messages = [Message]()
    private let sender = Sender(photoURL: "", senderId: "1", displayName: "Tony Stark")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messages.append(Message(sender: sender,
                                messageId: "1",
                                sentDate: Date(),
                                kind: .text("Hello")))
        
        messages.append(Message(sender: sender,
                                messageId: "1",
                                sentDate: Date(),
                                kind: .text("Hello Hello Hello Hello Hello Hello Hello")))
        
        view.backgroundColor = .systemPink
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
    }
}

extension ChatViewController: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    func currentSender() -> SenderType {
        sender
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
}
