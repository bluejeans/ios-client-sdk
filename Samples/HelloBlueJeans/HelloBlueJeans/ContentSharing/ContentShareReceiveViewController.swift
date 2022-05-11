//
//  ContentShareReceiveViewController.swift
//  HelloBlueJeans
//
//  Created by Thomas Roff on 9/03/22.
//

import UIKit
import BJNClientSDK

/// A class to show the usage of the `getContentShareView` method on the BlueJeans SDK Video Device Service.
/// Use `getContentShareView` to get the shared collaboration view comming from the BlueJeans cloud.
/// This implementation allows zooming of the collaboration view by embeding it inside a scrollview. A common use case, not required.
///
/// - Tag: ContentShareReceiveViewController
class ContentShareReceiveViewController: UIViewController {
    
    @IBOutlet weak var contentShareViewContainer: UIScrollView!
    
    var contentView = UIView()
    var videoDeviceService: VideoDeviceServiceProtocol!

    var subscriptions = [BJNSubscription]()

    override func viewDidLoad() {
        super.viewDidLoad()
        videoDeviceService = BlueJeansSDK.videoDeviceService
        setupUI()
    }
   
    func setupUI() {
        // Register callback to trigger when the colloboration view changes. On change set the contentView dimensions.
        // Needed if using a scrollview.
        videoDeviceService.contentShareSize.keepUpToDate { [weak self] in
            guard let self = self else { return }
            let size = self.videoDeviceService.contentShareSize.value
            self.contentView.fixWidth(size.width)
            self.contentView.fixHeight(size.height)
        }.store(in: &subscriptions)
        
        // Set scrollview specific properties.
        contentShareViewContainer.delegate = self
        contentShareViewContainer.maximumZoomScale = 2
        contentShareViewContainer.minimumZoomScale = 0.1
        
        // Insert the retreived UIView into the container views.
        contentView = videoDeviceService.getContentShareView()
        contentShareViewContainer.insertSubview(contentView, aboveSubview: contentShareViewContainer)
        
        // Set contraints.
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentShareViewContainer.clipsToBounds = true
        contentView.leftAnchor.constraint(equalTo: contentShareViewContainer.leftAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo: contentShareViewContainer.rightAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: contentShareViewContainer.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: contentShareViewContainer.bottomAnchor).isActive = true
    }
}

/// This extension implements methods for UIScrollViewDelegate.
extension ContentShareReceiveViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return contentView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let offsetX = max((scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5, 0)
        let offsetY = max((scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5, 0)

        scrollView.contentInset = UIEdgeInsets(top: offsetY, left: offsetX, bottom: 0, right: 0)
    }
}

