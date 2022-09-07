//
//  MeetingViewController.swift
//  HelloBlueJeans
//
//  Created by Ruairi Griffin on 8/09/21.
//

import UIKit
import BJNClientSDK

/// A class that shows the usage of the BlueJeans SDK Meeting and VideoDevice services.
///
/// `BlueJeansSDK.MeetingService` provides meeting specific actions with methods to:
/// - Join and leave meetings.
/// - Change video layout.
/// - Mute local audio/video.
///
/// `BlueJeansSDK.videoDeviceService` handles video related API’s, such as selecting a camera device, or getting the Remote/Self/Content video streams.
///
/// - Tag: MeetingViewController
class MeetingViewController: UIViewController {

    // MARK: - Properties

    var meetingService: MeetingServiceProtocol!
    var videoDeviceService: VideoDeviceServiceProtocol!

    @IBOutlet weak var selfViewContainer: UIView!
    @IBOutlet weak var joinButton: UIButton!
    @IBOutlet weak var leaveButton: UIButton!
    @IBOutlet weak var muteVideoButton: UIButton!
    @IBOutlet weak var muteAudioButton: UIButton!
    @IBOutlet weak var selfViewCoverImage: UIImageView!
    @IBOutlet weak var titleBarLabel: UILabel!
    @IBOutlet weak var activeSpeakerLabel: UILabel!

    var selfViewAspectRatioConstraint: NSLayoutConstraint?
    
    var subscriptions = [BJNSubscription]()
    
    var remoteVideoViewController: UIViewController!
    
    var selfView: UIView?

    // MARK: Initialisation

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSDK()
        setupSelfView()
        setupSelfViewCover()
        setupMeetingUI()
        setupAudioMuteUI()
        setupVideoMuteUI()
        setupActiveSpeakerUI()
    }
    
     override func viewDidAppear(_ animated: Bool) {
       setupRemoteVideoView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        remoteVideoViewController.view.removeFromSuperview()
        remoteVideoViewController.removeFromParent()
        remoteVideoViewController.didMove(toParent: self)
    }

    /// Setting up the SDK is as simple as assigning the services.
    /// Note: It is important that we then retain these for as long as we wish to use the SDK.
    func setupSDK() {
        print("BlueJeansSDK version: \(BlueJeansSDK.sdkVersion)")
        // For more customisation, we could call the BlueJeansSDK.initialize method here before we access any services.
        meetingService = BlueJeansSDK.meetingService
        videoDeviceService = BlueJeansSDK.videoDeviceService
    }

    // MARK: Remote Video

    /// This method instantiates the remote video view controller and adds it to our view.
    /// The remote video controller handles the layout and organisation of all the locally composited views for all the participant video streams in the meeting.
    /// We add it to our view controller using VC containment.
    func setupRemoteVideoView() {
            remoteVideoViewController = videoDeviceService.getRemoteVideoController()
            addChild(remoteVideoViewController)
            view.addSubview(remoteVideoViewController.view)
            view.sendSubviewToBack(remoteVideoViewController.view)
            remoteVideoViewController.didMove(toParent: self)
    }

    // MARK: Self View

    /// This method sets up the self view and adds it to a view that we have added to our storyboard.
   func setupSelfView() {
       videoDeviceService.selectCameraDevice(.front)
       videoDeviceService.setEnableSelfVideoPreview(to: true)

       let selfView = videoDeviceService.getSelfView()

       selfViewContainer.insertSubview(selfView, belowSubview: selfViewCoverImage)

       selfView.translatesAutoresizingMaskIntoConstraints = false
       selfViewContainer.clipsToBounds = true

       selfView.leftAnchor.constraint(equalTo: selfViewContainer.leftAnchor).isActive = true
       selfView.rightAnchor.constraint(equalTo: selfViewContainer.rightAnchor).isActive = true
       selfView.topAnchor.constraint(equalTo: selfViewContainer.topAnchor).isActive = true
       selfView.bottomAnchor.constraint(equalTo: selfViewContainer.bottomAnchor).isActive = true
       
       self.selfView = selfView
   }
    
    /// This method sets up a view to cover the self view when capture is not active, to avoid showing the last captured frame
    func setupSelfViewCover() {
        videoDeviceService.captureIsActive.keepUpToDate { [ weak self] in
            if let isSelfViewVisible = self?.videoDeviceService.captureIsActive.value {
                DispatchQueue.main.async { [ weak self ] in
                    self?.selfViewCoverImage.isHidden = isSelfViewVisible
                }
            }
        }.store(in: &subscriptions)
    }

    // MARK: Meeting Join / Leave

    /// When we press the green join button, we call the join method.
    /// Once the API call completes the given closure that takes a MeetingJoinResult will be called with either .success, or another value.
    /// If the the call to join was successful the meetingState will move from validating to connecting.
    /// Otherwise the call may fail for a number of reasons, which will be also provided with the MeetingJoinResult enumeration.
    @IBAction func join() {
        // Add your own meeting ID and passcode here.
        meetingService.join(meetingID: "", passcode: "", displayName: "iOS Sample App") { meetingJoinResult in
            switch meetingJoinResult {
            case .success:
                print("Meeting joined succesfully!")
            default:
                print("Meeting join failed for reason \(meetingJoinResult)")
            }
        }
    }

    // To leave a meeting we simply call the leave() method of the meeting service.
    @IBAction func leave() {
        meetingService.leave()
    }

    func setupMeetingUI() {
        // Here we register a handler, which will be run every time the meetingState changes.
        meetingService.meetingState.keepUpToDate { [weak self] in
            self?.updateMeetingUI()
        }.store(in: &subscriptions)
        
        // Because the UI is also dependent on the meetingInformation, it should be updated when this changes as well.
        meetingService.meetingInformation.keepUpToDate { [weak self] in
            self?.updateMeetingUI()
        }.store(in: &subscriptions)
    }

    // This method sets the title text, and enablement of the buttons based on meetingState.
    func updateMeetingUI() {
        let meetingState = meetingService.meetingState.value

        let joinButtonEnabled = meetingState == .idle
        let leaveButtonEnabled = !joinButtonEnabled

        // Meeting info is an optional property because we do not have this information until we reach the connecting or waiting room state.
        let meetingTitle = meetingService.meetingInformation.value?.meetingTitle

        var title: String?

        switch meetingState {
        case .idle:
            title = "Try joining a meeting!"
        case .validating:
            title = "Validating"
        case .waitingRoom:
            if let meetingTitle = meetingTitle {
                title = "Waiting Room for \(meetingTitle )"
            } else {
                title = "Waiting Room"
            }
        case .connecting:
            if let meetingTitle = meetingTitle {
                title = "Connecting to \(meetingTitle)"
            } else {
                title = "Connecting"
            }
        case .reconnecting:
            title = "Reconnecting"
        case .connected:
            title = meetingTitle ?? "Connected"
        default:
            break
        }

        DispatchQueue.main.async { [ weak self ] in
            self?.titleBarLabel.text = title
            self?.joinButton.isEnabled = joinButtonEnabled
            self?.leaveButton.isEnabled = leaveButtonEnabled
        }
        
    }

    // MARK: Audio Mute

    /// To set audio mute we simply call the setAudioMute() method of the meeting service.
    @IBAction func muteAudioToggle() {
        let isAudioMuted = meetingService.audioMuted.value
        meetingService.setAudioMuted(to: !isAudioMuted)
    }

    func setupAudioMuteUI() {
        meetingService.audioMuteState.keepUpToDate { [weak self] in
            self?.updateAudioMuteUI()
        }.store(in: &subscriptions)
    }

    /// This method updates the UI to reflect the value of audioMuteState.
    /// It gets executed every time the audioMuted property changes as defined in the setupAudioMuteUI() method.
    func updateAudioMuteUI() {
        let audioMuted = meetingService.audioMuted.value
        let audioMutedBackgroundImage = UIImage(systemName: audioMuted ? "mic.slash.fill" : "mic.fill")!
        
        DispatchQueue.main.async { [ weak self ] in
            self?.muteAudioButton.setBackgroundImage(audioMutedBackgroundImage, for: .normal)
        }
    }

    // MARK: Video Mute

    /// To set video mute we simply call the setAudioMute() method of the meeting service.
    @IBAction func muteVideoToggle() {
        let isVideoMuted = meetingService.videoMuted.value
        meetingService.setVideoMuted(to: !isVideoMuted)
    }

    func setupVideoMuteUI() {
        meetingService.videoMuteState.keepUpToDate { [weak self] in
            self?.updateVideoMuteUI()
        }.store(in: &subscriptions)
    }

    /// This method updates the UI to reflect the value of videoMuteState.
    /// It gets executed every time the videoMuted property changes as defined in the setupVideoMuteUI() method.
    func updateVideoMuteUI() {
        let videoMuted = meetingService.videoMuted.value
        let videoMutedBackgroundImage = UIImage(systemName: videoMuted ? "video.slash.fill" : "video.fill")!

        DispatchQueue.main.async { [ weak self ] in
            self?.muteVideoButton.setBackgroundImage(videoMutedBackgroundImage, for: .normal)
        }
    }

    // MARK: Active Speaker

    func setupActiveSpeakerUI() {
        meetingService.participantsService.activeSpeaker.keepUpToDate { [weak self] in
            self?.updateActiveSpeakerUI()
        }.store(in: &subscriptions)
    }

    /// This method updates the active speaker label.
    /// It gets executed every time the activeSpeaker property changes as defined in the setupActiveSpeakerUI() method.
    func updateActiveSpeakerUI() {
        let activeSpeakerText: String?
        let activeSpeakerHidden: Bool

        if let speakerName = meetingService.participantsService.activeSpeaker.value??.name {
            activeSpeakerText = "\(speakerName) is speaking"
            activeSpeakerHidden = false
        } else {
            activeSpeakerText = nil
            activeSpeakerHidden = true
        }

        DispatchQueue.main.async { [ weak self ] in
            self?.activeSpeakerLabel.text = activeSpeakerText
            self?.activeSpeakerLabel.isHidden = activeSpeakerHidden
        }
    }
}
