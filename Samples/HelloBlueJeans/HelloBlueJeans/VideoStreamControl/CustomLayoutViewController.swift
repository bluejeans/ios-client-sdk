//
//  CustomLayoutViewController.swift
//  HelloBlueJeans
//
//  Created by Ruairi Griffin on 9/08/22.
//

import Foundation
import UIKit
import BJNClientSDK
import Combine

/// A minimal example of the Video Stream Control API
/// Shows how to:
/// - Set the layout to .custom
/// - Set a configuration containing one video
/// - Listen for changes to the `videoStreams` array
/// - Attach and detach video views
/// - Change the content mode of an attached view
///
/// - Tag: CustomLayoutViewController
class CustomLayoutViewController: UIViewController {
    var cancellables = Set<AnyCancellable>()
    
    var videoDeviceService: VideoDeviceServiceProtocol!
    var meetingService: MeetingServiceProtocol!
    var videoStreamService: VideoStreamServiceProtocol!
    
    var firstStreamPublisher: AnyPublisher<VideoStreamProtocol?, Never>!
    
    weak var currentVideoView: UIView?
    
    @IBOutlet weak var resolutionLabel: UILabel!
    @IBOutlet weak var videoContainer: UIView!
    
    override func viewDidLoad() {
        videoDeviceService = BlueJeansSDK.videoDeviceService
        meetingService = BlueJeansSDK.meetingService
        videoStreamService = BlueJeansSDK.videoStreamService
        
        // In order to receive 720p video we have to enable it
        videoDeviceService.set720pVideoReceiveEnabled(true)
        
        subscribeToChanges()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // We must set the videoLayout to .custom before we can call `setConfiguration`
        meetingService.setVideoLayout(to: .custom)
        
        // Sends our request for videos
        setConfiguration()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        meetingService.setVideoLayout(to: .people)
    }
    
    func subscribeToChanges() {
        // Because the number, quality and participants in the streams of video we recieve from the server may change over time
        // We need to observe these changes and attach or detach the streams to our UI.
        // In this example we only request one video, and have one video view so we filter to
        // include just the first element of the videoStream array.
        firstStreamPublisher = videoStreamService.videoStreams.publisher
            .compactMap {$0} // This array will be nil when we are not in a meeting, ignore this case
            .map { streams in
                return streams.first
            }
            .eraseToAnyPublisher()
        
        // When the first video stream changes we need to modify our UI
        firstStreamPublisher
            .scan((nil, nil)) { ($0.1, $1) } // Scan with the previous stream (or nil if no previous stream)
            .sink { [ weak self ] oldStream, newStream in
                guard let self = self else { return }
                
                // If there was an old stream, and the id is different to our new stream we should first detach (remove) the old video
                if let oldStream = oldStream, oldStream.participantId != newStream?.participantId {
                    _ = self.videoStreamService.detachParticipantStreamFromView(participantId: oldStream.participantId)
                }
                
                // If there is a new stream, and the id is different to our old stream we should attach the new video
                if let newStream = newStream, newStream.participantId != oldStream?.participantId {
                    let attachmentResult = self.videoStreamService.attachParticipantStreamToView(participantId: newStream.participantId, view: self.videoContainer)
                    // If we succesfully attach the new video, we will keep a ~weak~ reference to it
                    // So we can change the content mode later.
                    if case .success(let videoView) = attachmentResult {
                        self.currentVideoView = videoView
                    }
                }
                
                self.setResolutionLabel(resolution: newStream?.videoResolution)
            }
            .store(in: &cancellables)
    }
    
    private func setConfiguration(quality: StreamQuality = .r720p_30fps) {
        // Creates a configuration array with one item
        // This will request one stream of video at the specified quality
        // You could optionally include a participantId to request the video of a particular person
        // But because we don't, the server will choose which video to provide
        // The server will prioritise the current speaker, then the most recently spoken participants
        let configuration = [VideoStreamConfiguration(
            requestedStreamQuality: quality,
            streamPriority: .high
        )]
        // In this example we ignore the result of setVideoConfiguration,
        // However this API will provide useful feedback to ensure a valid configuration
        _ = videoStreamService.setVideoStreamConfiguration(configuration: configuration)
    }
    
    private func setResolutionLabel(resolution: CGSize?) {
        let displayValue: String = resolution?.getHumanReadableResolution() ?? "No stream"
        DispatchQueue.main.async { [ weak self ] in
            self?.resolutionLabel.text = displayValue
        }
    }
    
    // If we double tap on the video we can change the .contentMode between .scaleAspectFit and .scaleAspectFill
    // You should consider your layout and decide whether cropping or letterboxing is more appropriate for your use case
    // You can also observe the resolution of the stream and resize the container instead
    @IBAction func videoDoubleTapped(_ sender: Any) {
        if let currentVideoView = currentVideoView, currentVideoView.contentMode == .scaleAspectFit {
            currentVideoView.contentMode = .scaleAspectFill
        } else {
            currentVideoView?.contentMode = .scaleAspectFit
        }
    }
    
    @IBAction func tapped720p() {
        setConfiguration(quality: .r720p_30fps)
    }
    
    @IBAction func tapped360p() {
        setConfiguration(quality: .r360p_30fps)
    }
    
    @IBAction func tapped180p() {
        setConfiguration(quality: .r180p_30fps)
    }
    
    @IBAction func tapped90p() {
        setConfiguration(quality: .r90p_15fps)
    }
}

extension CGSize {
    // Formats CGSize(width: 640.0, height: 480.0) as "640x480"
    func getHumanReadableResolution() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        
        let width = NSNumber(value: Double(width))
        let height = NSNumber(value: Double((height)))
        let formattedWidth = formatter.string(from: width)!
        let formattedHeight = formatter.string(from: height)!
        return "\(formattedWidth)x\(formattedHeight)"
    }
}
