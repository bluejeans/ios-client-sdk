//
//  VideoLayoutViewController.swift
//  HelloBlueJeans
//
//  Created by Thomas Roff on 3/05/22.
//

import UIKit
import BJNClientSDK

/// A class to show the usage of the `VideoLayout` methods on the BlueJeans SDK Meeting Service.
/// Use `meetingService.videoLayout.value` to get the video layout of the current meeting.
/// Use `meetingService.setVideoLayout()` to set the video layout of the current meeting.
/// - Tag: VideoLayoutViewController
class VideoLayoutViewController: UIViewController {
   
    // MARK: Outlets
    
    @IBOutlet weak var remoteViewContainer: UIView!
    @IBOutlet weak var speakerButton: UIButton!
    @IBOutlet weak var peopleButton: UIButton!
    @IBOutlet weak var galleryButton: UIButton!
    
    // MARK: Services
    
    var meetingService: MeetingServiceProtocol!
    var videoDeviceService: VideoDeviceServiceProtocol!
    
    var subscriptions = [BJNSubscription]()
    
    var remoteVideoViewController: UIViewController!
    
    // MARK: Setup
    
    override func viewDidLoad() {
        meetingService = BlueJeansSDK.meetingService
        videoDeviceService = BlueJeansSDK.videoDeviceService
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
       setupRemoteVideoView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        teardownRemoteVideoView()
    }
    
    func setupUI() {
        meetingService.videoLayout.keepUpToDate { [weak self] in
            self?.updateUI()
        }.store(in: &subscriptions)
    }
    
    // MARK: Set Video Layout
    
    @IBAction func selectVideoLayout(_ sender: UIButton) {
        var layout: VideoLayout
        switch sender {
        case speakerButton:
            layout = .speaker
        case peopleButton:
            layout = .people
        case galleryButton:
            layout = .gallery
        default:
            return
        }
        
        meetingService.setVideoLayout(to: layout)
    }
    
    // MARK: Update UI
    
    func updateUI() {
        guard let videoLayout = meetingService.videoLayout.value else { return }
        
        var speakerLayoutActivated = false
        var peopleLayoutActivated = false
        var galleryLayoutActivated = false
        
        switch videoLayout {
        case .speaker:
            speakerLayoutActivated = true
        case .people:
            peopleLayoutActivated = true
        case .gallery:
            galleryLayoutActivated = true
        default:
            break
        }
        
        DispatchQueue.main.async {
            self.speakerButton.setTitleColor(speakerLayoutActivated ? UIColor.green : UIColor.black, for: .normal)
            self.peopleButton.setTitleColor(peopleLayoutActivated ? UIColor.green : UIColor.black, for: .normal)
            self.galleryButton.setTitleColor(galleryLayoutActivated ? UIColor.green : UIColor.black, for: .normal)
        }
    }
    
    func teardownRemoteVideoView() {
        remoteVideoViewController.view.removeFromSuperview()
        remoteVideoViewController.removeFromParent()
        remoteVideoViewController.didMove(toParent: self)
    }
    
    func setupRemoteVideoView() {
        remoteVideoViewController = videoDeviceService.getRemoteVideoController()
        addChild(remoteVideoViewController)
        remoteViewContainer.addSubview(remoteVideoViewController.view)
        remoteVideoViewController.didMove(toParent: self)

        remoteVideoViewController.view.translatesAutoresizingMaskIntoConstraints = false
        remoteViewContainer.clipsToBounds = true

        remoteVideoViewController.view.leftAnchor.constraint(equalTo: remoteViewContainer.leftAnchor).isActive = true
        remoteVideoViewController.view.rightAnchor.constraint(equalTo: remoteViewContainer.rightAnchor).isActive = true
        remoteVideoViewController.view.topAnchor.constraint(equalTo: remoteViewContainer.topAnchor).isActive = true
        remoteVideoViewController.view.bottomAnchor.constraint(equalTo: remoteViewContainer.bottomAnchor).isActive = true
    }
}
