//
//  MPCManager.swift
//  BBConfigurator
//
//  Created by Vinod on 03/09/17.
//  Copyright © 2017 BBI-M USER1033. All rights reserved.
//

import Cocoa
import MultipeerConnectivity

protocol MPCManagerDelegate {
    
    func didConnectedPeersListUpdated()
}

class MPCManager: NSObject {
    
    static let shared = MPCManager()
    
    var delegate: MPCManagerDelegate?
    
    var session: MCSession!
    
    var peer: MCPeerID!
    
    var browser: MCNearbyServiceBrowser!
    
    var advertiser: MCNearbyServiceAdvertiser!
    
    override init() {
        super.init()
        
        peer = MCPeerID(displayName:Host.current().localizedName!)
        
        session = MCSession(peer: peer)
        session.delegate = self
        
        browser = MCNearbyServiceBrowser(peer: peer, serviceType: "insignia")
        browser.delegate = self
        browser.startBrowsingForPeers()
    }
    
    func sendDataToConnectedPeers(_ dictionary: [String: Any]) {
        
        if session.connectedPeers.count > 0
        {
            let dataToSend = NSKeyedArchiver.archivedData(withRootObject: dictionary)
            
            do {
                
                try session.send(dataToSend, toPeers: session.connectedPeers, with: .reliable)
            }
            catch {
                
                print("Error")
            }
        }
    }
    
    
    func sendResourcesToPeers(_ filePath: String, withName: String) {
        
        let resourceURL = URL(fileURLWithPath: filePath)
        
        for peer in session.connectedPeers {
            
            session.sendResource(at: resourceURL, withName: withName, toPeer: peer, withCompletionHandler: { (error) -> Void in
                if error != nil{
                    NSLog("Error in sending resource send resource: \(String(describing: error?.localizedDescription))")
                }
            })
        }
    }
}

extension MPCManager: MCSessionDelegate {

    // Remote peer changed state.
    public func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        
        switch state{
        case .connected:
            print("Connected to session: \(session)")
            
        case .connecting:
            print("Connecting to session: \(session)")
            
        default:
            print("Did not connect to session: \(session)")
        }
        
        delegate?.didConnectedPeersListUpdated()
    }
    
    
    // Received data from remote peer.
    public func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        
    }
    
    
    // Received a byte stream from remote peer.
    public func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    
    // Start receiving a resource from remote peer.
    public func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    public func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {

    }
}

extension MPCManager: MCNearbyServiceBrowserDelegate {
    
    // Found a nearby advertising peer.
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        
        print("foundPeer: \(peerID)")
        
        browser.invitePeer(peerID, to: session, withContext: nil, timeout: 30)
        
        delegate?.didConnectedPeersListUpdated()
    }
    
    // A nearby peer has stopped advertising.
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        
        print("lostPeer: \(peerID)")
        
        delegate?.didConnectedPeersListUpdated()
    }
    
    // Browsing did not start due to an error.
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        
    }
}

extension MPCManager: MCNearbyServiceAdvertiserDelegate {
    
    // Incoming invitation request.  Call the invitationHandler block with YES
    // and a valid session to connect the inviting peer to the session.
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Swift.Void) {
        
        invitationHandler(true, session)
    }

}

