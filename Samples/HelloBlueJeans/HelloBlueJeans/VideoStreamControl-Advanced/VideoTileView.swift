//
//  VideoTileView.swift
//  HelloBlueJeans
//
//  Created by Ruairi Griffin on 16/08/22.
//

import Foundation
import UIKit
import Combine
import BJNClientSDK

/// A view which we can send a `VideoStreamProtocol` confrming object to
/// - will display the video for that stream
/// - will get the name and the isActiveSpeaker property of the participant associated with that stream
/// - will display the name in a bar at the bottom
/// - will display a green border when the participant is the active speaker
class VideoTileView: UIView {
    private var cancellables = Set<AnyCancellable>()
    private var currentParticipantCancellable: AnyCancellable?
    private var videoStreamService: VideoStreamServiceProtocol
    
    /// Primary interface for the view
    var videoStreamSubject: CurrentValueSubject<VideoStreamProtocol?, Never> = CurrentValueSubject(nil)
    
    var videoViewContainer: VideoViewContainer! // Resposible for actually attaching and detaching the video (if any)
    var nameLabel: UILabel!
    
    init() {
        self.videoStreamService = BlueJeansSDK.videoStreamService
        super.init(frame: .zero)
        
        setupUI()
        
        registerForChanges()
    }
    
    func setupUI() {
        // Choose a random background color for fun
        backgroundColor = UIColor.random()
        
        // Create the view that will handle attaching and detaching the video and send it to the back
        videoViewContainer = VideoViewContainer()
        addPinnedSubview(videoViewContainer)
        self.sendSubviewToBack(videoViewContainer)
        
        // Create a bar at the bottom and add a label to it for the name
        let bottomBarView = UIView()
        bottomBarView.translatesAutoresizingMaskIntoConstraints = false
        bottomBarView.backgroundColor = UIColor(named: "VideoTileBottomBarColor")
        self.addSubview(bottomBarView)
        
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: bottomBarView.leadingAnchor),
            trailingAnchor.constraint(equalTo: bottomBarView.trailingAnchor),
            bottomAnchor.constraint(equalTo: bottomBarView.bottomAnchor),
            bottomBarView.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.textColor = .white
        bottomBarView.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: bottomBarView.leadingAnchor, constant: 5),
            nameLabel.trailingAnchor.constraint(equalTo: bottomBarView.trailingAnchor, constant: 5),
            nameLabel.topAnchor.constraint(equalTo: bottomBarView.topAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: bottomBarView.bottomAnchor)
        ])
        
        self.nameLabel = nameLabel
    }
    
    func registerForChanges() {
        // Subscribe to the video stream subject
        videoStreamSubject
            .map { $0?.participantId } // Just get the id
            .scan((nil, nil)) { ($0.1, $1) } // Scan with the previous id (or nil if no previous stream)
            .sink { (oldId, newId) in
                if let oldId = oldId, oldId != newId ?? "" { // If there was previously an id attached to this view, and it is different
                    self.unsubscribeToParticipantChanges() // We should unsubscribe from changes to the last participant
                }

                if let newId = newId, newId != oldId { // If there is a new id, and it is different from the old id
                    self.subscribeToParticipantChanges(id: newId) // Subscribe to updates for that new participant
                }
            }
            .store(in: &cancellables)
        
        videoStreamSubject
            .map { stream in
                if let stream = stream {
                    return .video(id: stream.participantId)
                } else {
                    return .noVideo
                }
            }
            .sink { [ weak self ] video in
                self?.videoViewContainer.videoSubject.send(video)
            }
            .store(in: &cancellables)
    }
    
    // Subscribes to changes in the participants list, for only a particular id
    func subscribeToParticipantChanges(id: String) {
        currentParticipantCancellable = BlueJeansSDK.meetingService.participantsService
            .participants
            .publisher
            .compactMap { $0 }
            .map { $0.first(where: {$0.id == id}) }
            .receive(on: DispatchQueue.main)
            .sink { [ weak self ] participant in
                guard let self = self else { return }
                guard let participant = participant else {
                    self.clearUI()
                    return
                }
                self.setUIForParticipant(participant: participant)
            }
    }
    
    func unsubscribeToParticipantChanges() {
        currentParticipantCancellable = nil
        clearUI()
    }
    
    func setUIForParticipant(participant: BJNParticipant) {
        if participant.isActiveSpeaker {
            layer.borderWidth = 3
            layer.borderColor = UIColor.green.cgColor
        } else {
            layer.borderWidth = 0
            layer.borderColor = UIColor.clear.cgColor
        }
        
        self.nameLabel.text = participant.name ?? "Guest"
    }
    
    func clearUI() {
        nameLabel.text = ""
        layer.borderWidth = 0
        layer.borderColor = UIColor.clear.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


private extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

private extension UIColor {
    static func random() -> UIColor {
        return UIColor(
            red:   .random(),
            green: .random(),
            blue:  .random(),
            alpha: 1.0
        )
    }
}
