//
//  AdvancedCustomLayoutViewController.swift
//  HelloBlueJeans
//
//  Created by Ruairi Griffin on 17/08/22.
//

import Foundation
import UIKit
import BJNClientSDK
import Combine

/// A more complicated example of using the VideoStreamsService to create a custom layout
/// Shows how to:
/// - Request videoStreams with specific participant at a higher quality (the moderator)
/// - Request for multiple streams at a lower quality
/// - Change the default content mode so videos crop to fit
/// - Listen for changes to the `videoStreams` array, and re-order it so the moderator's stream is at the start
/// - Create multiple video views, each in charge of displaying on participants video
///
/// - Tag: AdvancedCustomLayoutViewController
class AdvancedCustomLayoutViewController: UIViewController {
    var cancellables = Set<AnyCancellable>()
    
    var videoDeviceService: VideoDeviceServiceProtocol!
    var meetingService: MeetingServiceProtocol!
    var videoStreamService: VideoStreamServiceProtocol!
    var participantsService: ParticipantsServiceProtocol!
    
    @IBOutlet weak var mainSpeakerViewContainer: UIView!
    @IBOutlet weak var firstRowStackView: UIStackView!
    @IBOutlet weak var secondRowStackView: UIStackView!
    @IBOutlet weak var thirdRowStackView: UIStackView!
    
    var videoStreamPublishers: [AnyPublisher<VideoStreamProtocol?, Never>]!
    
    var orderedVideoStreams: AnyPublisher<[VideoStreamProtocol], Never>!
    
    var viewDidAppearSubject: PassthroughSubject<Void, Never> = PassthroughSubject()
    
    var videoTiles: [VideoTileView]!
    
    override func viewDidLoad() {
        videoDeviceService = BlueJeansSDK.videoDeviceService
        meetingService = BlueJeansSDK.meetingService
        videoStreamService = BlueJeansSDK.videoStreamService
        participantsService = BlueJeansSDK.meetingService.participantsService
        
        // In order to receive 720p video we have to enable it
        videoDeviceService.set720pVideoReceiveEnabled(true)
        // In this example we will crop the videos and have them fill the entire view
        videoStreamService.setDefaultVideoContentMode(.scaleAspectFill)
        
        setupVideoTiles()
        
        subscribeToChangesForConfiguration()
        
        subscribeToChangesForDisplayingVideos()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // We must set the videoLayout to .custom before we can call `setConfiguration`
        meetingService.setVideoLayout(to: .custom)
        
        // Sends our request for videos
        viewDidAppearSubject.send()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        meetingService.setVideoLayout(to: .people)
    }
    
    func setupVideoTiles() {
        videoTiles = (0...9).map{ _ in VideoTileView() }
        
        let mainVideoTile = videoTiles[0]
        mainSpeakerViewContainer.addPinnedSubview(mainVideoTile)
        
        for i in 1...3 {
            firstRowStackView.addArrangedSubview(videoTiles[i])
        }
        for i in 4...6 {
            secondRowStackView.addArrangedSubview(videoTiles[i])
        }
        for i in 7...9 {
            thirdRowStackView.addArrangedSubview(videoTiles[i])
        }
    }
    
    func subscribeToChangesForConfiguration() {
        let moderatorPublisher = participantsService.participants.publisher
            .compactMap { $0 }
            .map { $0.first(where: {$0.isModerator }) }
            .removeDuplicates()
            .eraseToAnyPublisher()
        
        viewDidAppearSubject
            .delay(for: 1.0, scheduler: DispatchQueue.global())
            .combineLatest(moderatorPublisher)
            .sink { [ weak self ] _, moderator in
                guard let self = self else { return }
                let configuration: [VideoStreamConfiguration]
                if let moderator = moderator {
                    let moderatorConfiguration = VideoStreamConfiguration(requestedStreamQuality: .r720p_30fps, participantId: moderator.id, streamPriority: .high)
                    let studentsConfiguration = self.getStudentsConfiguration()
                    configuration = [moderatorConfiguration] + studentsConfiguration
                } else {
                    configuration = self.getStudentsConfiguration()
                }
                print("Setting configuration \(configuration)")
                _ = self.videoStreamService.setVideoStreamConfiguration(configuration: configuration)
            }
            .store(in: &cancellables)
    }
    
    func subscribeToChangesForDisplayingVideos() {
        orderedVideoStreams = videoStreamService.videoStreams.publisher
            .compactMap {$0}
            .map { [ weak self ] unsortedStreams in
                var mutableUnsortedStreams = unsortedStreams
                
                let moderatorIndex = mutableUnsortedStreams.firstIndex { stream in
                    self?.participantsService
                        .participants
                        .value?
                        .first(where: {$0.isModerator && ($0.id == stream.participantId)}) != nil
                }
                
                if let moderatorIndex = moderatorIndex {
                    let moderatorStream = mutableUnsortedStreams[moderatorIndex]
                    mutableUnsortedStreams.remove(at: moderatorIndex)
                    return [moderatorStream] + mutableUnsortedStreams
                } else {
                    return mutableUnsortedStreams
                }
            }
            .eraseToAnyPublisher()
        
        videoStreamPublishers = (0...9).map { i in
            orderedVideoStreams
                .receive(on: DispatchQueue.main)
                .map { videoStreams in
                    videoStreams[safeIndex: i]
                }
                .eraseToAnyPublisher()
        }
        
        videoStreamPublishers.enumerated().forEach{ index, videoStreamPublisher in
            videoStreamPublisher.sink { [ weak self ] stream in
                self?.videoTiles[index].videoStreamSubject.send(stream)
            }
            .store(in: &cancellables)
        }
    }
    
    private func getStudentsConfiguration(numberOfVideos: Int = 9) -> [VideoStreamConfiguration] {
        let oneVideo = VideoStreamConfiguration(requestedStreamQuality: .r90p_7fps, streamPriority: .medium)
        let allVideos = [VideoStreamConfiguration](repeating: oneVideo, count: numberOfVideos)
        return allVideos
    }
}

extension Array {
    public subscript(safeIndex index: Int) -> Element? {
        guard index >= 0, index < endIndex else {
            return nil
        }
        return self[index]
    }
}

extension UIView {
    func addPinnedSubview(_ innerView: UIView) {
        innerView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(innerView)
        
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: innerView.topAnchor),
            self.bottomAnchor.constraint(equalTo: innerView.bottomAnchor),
            self.leadingAnchor.constraint(equalTo: innerView.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: innerView.trailingAnchor)
        ])
    }
}

