//
//  ViewController.swift
//  HelloBlueJeans
//
//  Created by Ruairi Griffin on 8/09/21.
//

import UIKit
import BJNClientSDK

class ViewController: UIViewController {
    
    // Services
    var meetingService: MeetingService!
    var videoDeviceService: VideoDeviceServiceProtocol!
        
    // Outlets
    @IBOutlet weak var selfViewContainer: UIView!
    @IBOutlet weak var joinButton: UIButton!
    @IBOutlet weak var leaveButton: UIButton!
    @IBOutlet weak var titleBarLabel: UILabel!
    
    var selfViewAspectRatioConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSDK()
        
        setupMeetingUI()
            
        setupRemoteVideoView()
        
        setupSelfView()
    }
    
    /*
     Setting up the SDK is as simple as assigning the services.
     Note: It is important that we then retain these for as long as we wish to use the SDK.
     */
    func setupSDK() {
        print("BlueJeansSDK version: \(BlueJeansSDK.sdkVersion)")
        // For more customisation, we could call the BlueJeansSDK.initialize method here before we access any services.
        meetingService = BlueJeansSDK.meetingService
        videoDeviceService = BlueJeansSDK.videoDeviceService
    }
    
    /*
     When we press the green join button, we call the join method.
     Once the API call completes the given closure that takes a MeetingJoinResult will be called with either .success, or another value.
     If the the call to join was successful the meetingState will move from validating to connecting.
     Otherwise the call may fail for a number of reasons, which will be also provided with the MeetingJoinResult enumeration.
     */
    @IBAction func join(_ sender: Any) {
        // Add your own meeting ID and passcode here
        meetingService.join(meetingID: "", passcode: "", displayName: "iOS Sample App") { [ weak self ] meetingJoinResult in
            switch meetingJoinResult {
            case .success:
                print("Meeting joined succesfully!")
                self?.leaveButton.isEnabled = true
            default:
                self?.joinButton.isEnabled = true
                print("Meeting join failed for reason \(meetingJoinResult)")
            }
        }
        joinButton.isEnabled = false
    }
    
    // To leave a meeting we simply call the leave() method of the meeting service.
    @IBAction func leave(_ sender: Any) {
        meetingService.leave()
        leaveButton.isEnabled = false
        joinButton.isEnabled = true
    }
    
    func setupMeetingUI() {
        // Here we set the initial value of our UI based on the meetingState.
        self.setMeetingUI()
        // Here we use the onChange handler, to pass a closure that will be run every time the meetingState changes thereafter.
        meetingService.meetingState.onChange { [ weak self ] in
            self?.setMeetingUI()
        }
    }
    
    // This method sets the title text, and enablement of the buttons based on the meetingState.
    func setMeetingUI() {
        let meetingState = meetingService.meetingState.value
        let meetingTitle = meetingService.meetingInfo.value?.meetingTitle // Meeting info is an optional property because we do not have this information until reach the connecting state.
        
        // The onChange closures may not be always called from the main thread, therefore if we want to modify the UI we must call this from the main thread explicitly.
        DispatchQueue.main.async {
            var title = ""
            switch meetingState {
            case .idle:
                self.joinButton.isEnabled = true
                self.leaveButton.isEnabled = false
                title = "Try joining a meeting!"
            case .validating:
                self.joinButton.isEnabled = false
                title = "Validating"
            case .connecting:
                self.leaveButton.isEnabled = true
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
            self.titleBarLabel.text = title
        }
    }
    
    /*
     This method instantiates the remote video view controller and adds it to our view.
     The remote video controller handles the layout and organisation of all the locally composited views for all the participant video streams in the meeting.
     We add it to our view controller using VC containment.
     */
    func setupRemoteVideoView() {
        let remoteVideoViewController = videoDeviceService.getRemoteVideoController()
        addChild(remoteVideoViewController)
        view.addSubview(remoteVideoViewController.view)
        view.sendSubviewToBack(remoteVideoViewController.view)
        remoteVideoViewController.didMove(toParent: self)
    }
    
    /*
     This method sets up the self view and adds it to a view that we have added to our storyboard.
     Because the aspect ratio of our self view may change (when we rotate the device) we have to listen to the
     videoDeviceService.selfViewSize property, and recreate the aspect ratio constraint of the self view appropriately.
     */
    func setupSelfView() {
        videoDeviceService.selectCameraDevice(.front)
        guard let selfView = videoDeviceService.getSelfViewInstance() else { return }
        
        videoDeviceService.setEnableSelfVideoPreview(to: true)
        selfViewContainer.addSubview(selfView)
        selfViewContainer.clipsToBounds = true
        
        selfView.translatesAutoresizingMaskIntoConstraints = false
        selfView.leftAnchor.constraint(equalTo: selfViewContainer.leftAnchor).isActive = true
        selfView.rightAnchor.constraint(equalTo: selfViewContainer.rightAnchor).isActive = true
        selfView.topAnchor.constraint(equalTo: selfViewContainer.topAnchor).isActive = true
        selfView.bottomAnchor.constraint(equalTo: selfViewContainer.bottomAnchor).isActive = true
        
        setSelfViewContainerConstraint()
        videoDeviceService.selfViewSize.onChange { [ weak self ] in
            self?.setSelfViewContainerConstraint()
        }
    }
    
    /*
     This method removes the aspect ratio constraint for the self view container, if there is one.
     Then sets this again based on the self view size.
     */
    private func setSelfViewContainerConstraint() {
        let size = videoDeviceService.selfViewSize.value
        guard size.width > 0.0, size.height > 0.0 else {
            return
        }
        DispatchQueue.main.async {
            if let currentConstraint = self.selfViewAspectRatioConstraint {
                currentConstraint.isActive = false
                self.selfViewContainer.removeConstraint(currentConstraint)
            }
            let newConstraint = NSLayoutConstraint(item: self.selfViewContainer!,
                                                      attribute: .height,
                                                      relatedBy: .equal,
                                                      toItem: self.selfViewContainer,
                                                      attribute: .width,
                                                      multiplier: size.height / size.width,
                                                      constant: 0)
            self.selfViewContainer.addConstraint(newConstraint)
            newConstraint.isActive = true
            self.selfViewAspectRatioConstraint = newConstraint
        }
    }
}

