//
//  VideoViewContainer.swift
//  HelloBlueJeans
//
//  Created by Ruairi Griffin on 18/08/22.
//

import Foundation
import Combine
import UIKit
import BJNClientSDK

enum Video: Equatable {
    case video(id: String)
    case noVideo
}

/// A view which given a `Video` enum, will appropriately attach or detach the neccesary id's
/// To use just send each `Video` to the videoSubject
class VideoViewContainer: UIView {
    var cancellables = Set<AnyCancellable>()
    
    let videoSubject: CurrentValueSubject<Video, Never> = CurrentValueSubject(.noVideo)
    
    init() {
        super.init(frame: .zero)
        clipsToBounds = true
        
        videoSubject
            .removeDuplicates()
            .scan((.noVideo, .noVideo)) {($0.1, $1)}
            .receive(on: DispatchQueue.main)
            .sink { [ weak self ] previous, current in
                switch previous {
                case .video(id: _):
                    switch current {
                    case .video(id: _):
                        self?.detach(video: previous)
                        self?.attach(video: current)
                    case .noVideo:
                        self?.detach(video: previous)
                    }
                case .noVideo:
                    switch current {
                    case .video(id: _):
                        self?.attach(video: current)
                    case .noVideo:
                        break
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    func attach(video: Video) {
        if case .video(let id) = video {
            _ = BlueJeansSDK.videoStreamService.attachParticipantStreamToView(participantId: id, view: self)
        }
    }
    
    func detach(video: Video) {
        if case .video(let id) = video {
            if let container = BlueJeansSDK.videoStreamService.attachedViewsForParticipantIds.value?[id]?.containerView, container == self {
                _ = BlueJeansSDK.videoStreamService.detachParticipantStreamFromView(participantId: id)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
