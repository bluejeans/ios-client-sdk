//
//  MenuTableViewController.swift
//  HelloBlueJeans
//
//  Created by Thomas Roff on 1/03/22.
//

import UIKit
import SwiftUI

/// A class used to navigate between different sample features of the BlueJeans SDK.
///
/// - Tag: MenuTableViewController
class MenuTableViewController: UITableViewController {
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Feature.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeatureCell", for: indexPath)
        
        let menuItem = Feature.allCases[indexPath.row]
        cell.textLabel?.text = menuItem.name
        cell.imageView?.image = menuItem.image
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Features"
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedFeature = Feature.allCases[indexPath.row]
        navigationController?.pushViewController(selectedFeature.viewController, animated: true)
    }
    
    enum Feature: String, CaseIterable {
        case swiftUILogUpload
        case uikitLogUpload
        case closedCaptioning
        case contentShareReceive
        case videoLayout
        case customLayout
        case advancedCustomLayout
        
        var name: String {
            switch self {
            case .swiftUILogUpload:
                return "SwiftUI Log Upload"
            case .uikitLogUpload:
                return "UIKit Log Upload"
            case .closedCaptioning:
                return "Closed Captioning"
            case .contentShareReceive:
                return "Content Share Receive"
            case .videoLayout:
                return "Video Layout"
            case .customLayout:
                return "Custom Layout"
            case .advancedCustomLayout:
                return "Advanced Custom Layout"
            }
        }
        
        var image: UIImage {
            switch self {
            case .swiftUILogUpload:
                return UIImage(systemName: "square.and.arrow.up")!
            case .uikitLogUpload:
                return UIImage(systemName: "square.and.arrow.up")!
            case .closedCaptioning:
                return UIImage(systemName: "captions.bubble")!
            case .contentShareReceive:
                return UIImage(systemName: "arrowtriangle.right.square")!
            case .videoLayout:
                return UIImage(systemName: "rectangle.3.offgrid")!
            case .customLayout:
                return UIImage(systemName: "rectangle.dashed")!
            case .advancedCustomLayout:
                return UIImage(systemName: "rectangle.grid.3x2")!
            }
        }
        
        var viewController: UIViewController {
            switch self {
            case .swiftUILogUpload:
                return UIHostingController(rootView: SwiftUILogUploadView())
            case .uikitLogUpload:
                return UIStoryboard(name: "UIKitLogUploadStoryboard", bundle: nil).instantiateViewController(withIdentifier: self.name)
            case .closedCaptioning:
                return UIStoryboard(name: "ClosedCaptioningStoryboard", bundle: nil).instantiateViewController(withIdentifier: self.name)
            case .contentShareReceive:
                return UIStoryboard(name: "ContentShareReceiveStoryboard", bundle: nil).instantiateViewController(withIdentifier: self.name)
            case .videoLayout:
                return UIStoryboard(name: "VideoLayoutStoryboard", bundle: nil).instantiateViewController(withIdentifier: self.name)
            case .customLayout:
                return UIStoryboard(name: "CustomLayoutStoryboard", bundle: nil).instantiateViewController(withIdentifier: self.name)
            case .advancedCustomLayout:
                return UIStoryboard(name: "AdvancedCustomLayoutStoryboard", bundle: nil).instantiateViewController(withIdentifier: self.name)
            }
        }
    }
}
