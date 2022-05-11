//
//  ClosedCaptioningViewController.swift
//  HelloBlueJeans
//
//  Created by Thomas Roff on 1/03/22.
//

import UIKit
import BJNClientSDK

/// A class that demonstrates the usage of the BlueJeans SDK Closed Captioning Service.
///
/// `BlueJeansSDK.closedCaptioningService` provides functions and properties to:
/// - Check if automatic captions are available for the current meeting.
/// - Start and stop the captions on the client.
/// - Access the most recent caption.
///
/// - Tag: ClosedCaptioningViewController

class ClosedCaptioningViewController: UIViewController {

    @IBOutlet weak var closedCaptionPreviewLabel: UILabel!
    @IBOutlet weak var closedCaptioningStatusLabel: UILabel!
    @IBOutlet weak var closedCaptioningButton: UIButton!

    var closedCaptioningService: ClosedCaptioningServiceProtocol!

    var hideCaptionTimer: Timer? {
        willSet {
            hideCaptionTimer?.invalidate()
        }
    }
    
    var subscriptions = [BJNSubscription]()

    override func viewDidLoad() {
        super.viewDidLoad()
        closedCaptioningService = BlueJeansSDK.meetingService.closedCaptioningService
        setupUI()
    }

    // MARK: Closed captioning on/off
    
    @IBAction func toggleClosedCaptions() {
        guard let closedCaptionsOn = closedCaptioningService.isClosedCaptioningOn.value else { return }
        closedCaptionsOn ? closedCaptioningService.stopClosedCaptioning() : closedCaptioningService.startClosedCaptioning()
    }

    // MARK: Setup onChange handlers
    
    func setupUI() {
        closedCaptioningService.isClosedCaptioningOn.keepUpToDate { [weak self] in
            self?.updateUI()
        }.store(in: &subscriptions)
        
        closedCaptioningService.closedCaptionText.keepUpToDate { [weak self] in
            self?.updateCaptionView()
        }.store(in: &subscriptions)
        
        closedCaptioningService.isClosedCaptioningAvailable.keepUpToDate { [weak self] in
            self?.updateUI()
        }.store(in: &subscriptions)
    }

    // MARK: Update UI

    func updateCaptionView() {
        let caption = String(closedCaptioningService.closedCaptionText.value ?? "")
        
        DispatchQueue.main.async {
            self.closedCaptionPreviewLabel.text = caption
            self.closedCaptionPreviewLabel.isHidden = false
        }

        startCaptionTimeout()
    }

    func startCaptionTimeout() {
        let captionTimeout = 6.0
        hideCaptionTimer = Timer.scheduledTimer(withTimeInterval: captionTimeout, repeats: true) { _ in
            DispatchQueue.main.async { [weak self] in
                self?.closedCaptionPreviewLabel.isHidden = true
            }
        }
    }
    
    func updateUI() {
        let isClosedCaptioningAvailable = closedCaptioningService.isClosedCaptioningAvailable.value ?? false
        let isClosedCaptioningOn = closedCaptioningService.isClosedCaptioningOn.value ?? false

        // Set status label text and button text according to closed caption state.
        let closedCaptioningButtonText: String
        let statusText: String

        if isClosedCaptioningOn {
            closedCaptioningButtonText = "Disable Closed Captioning"
            statusText = "enabled"
        } else {
            closedCaptioningButtonText = "Enable Closed Captioning"
            statusText = "disabled"
        }

        let closedCaptioningStatus = "Available: \(String(isClosedCaptioningAvailable)) \nStatus: \(String(statusText))"

        let closedCaptioningButtonAlpha = isClosedCaptioningAvailable ? 1.0 : 0.5

        DispatchQueue.main.async {
            self.closedCaptioningButton.isEnabled = isClosedCaptioningAvailable
            self.closedCaptioningButton.setTitle(closedCaptioningButtonText, for: .normal)
            self.closedCaptioningButton.alpha = closedCaptioningButtonAlpha
            self.closedCaptioningStatusLabel.text = closedCaptioningStatus
        }
    }
}
