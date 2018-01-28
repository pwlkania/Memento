//
//  WormholeMessage.swift
//  Memento
//
//  Created by Pawel Kania on 28/01/2018.
//  Copyright © 2018 Pawel Kania. All rights reserved.
//

import Foundation

// MARK: - WormholeOption

public enum WormholeOption: Int {
    case trackLocation, forceUpdate, sendToCloud, ping
}

// MARK: - WormholeMessage

@objc(WormholeMessage)
public class WormholeMessage: NSObject, NSCoding {
    
    // MARK: Static properties
    
    public static let hostIdentifier = "wormhole.host.identifier"
    public static let widgetIdentifier = "wormhole.widget.identifier"
    
    // MARK: Properties
    
    public var option: WormholeOption
    public var enabled: Bool
    
    // MARK: Initializers
    
    public init(option: WormholeOption, enabled: Bool) {
        self.option = option
        self.enabled = enabled
        super.init()
    }
    
    // MARK: - Encode/decode
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(option.rawValue, forKey: "option")
        aCoder.encode(enabled, forKey: "enabled")
    }
    
    public required init?(coder aDecoder: NSCoder) {
        guard let aOption = WormholeOption(rawValue: aDecoder.decodeInteger(forKey: "option")) else {
            fatalError()
        }
        option = aOption
        enabled = aDecoder.decodeBool(forKey: "enabled")
    }
    
}
