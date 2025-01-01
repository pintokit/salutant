//
//  MessageContext.swift
//
//
//  Created by David Solis on 7/6/24.
//

import Foundation

struct MessageContext: Encodable {
    let title: String
    let message: MessageData
    
    struct MessageData: Encodable {
        let id: String
        let sender: String
        let content: String
    }
}
