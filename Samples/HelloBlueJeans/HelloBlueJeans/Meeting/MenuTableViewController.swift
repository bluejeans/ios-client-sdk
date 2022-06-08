//
//  MenuTableViewController.swift
//  HelloBlueJeans
//
//  Created by Thomas Roff on 1/03/22.
//

import UIKit

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
        let viewController = selectedFeature.storyboard.instantiateViewController(withIdentifier: selectedFeature.name)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    enum Feature: String, CaseIterable {
        case logUpload
        case closedCaptioning
        case contentShareReceive
        case videoLayout
        
        var name: String {
            switch self {
            case .logUpload:
                return "Log Upload"
            case .closedCaptioning:
                return "Closed Captioning"
            case .contentShareReceive:
               return "Content Share Receive"
            case .videoLayout:
                return "Video Layout"
            }
        }
        
        var image: UIImage {
            switch self {
            case .logUpload:
                return UIImage(systemName: "square.and.arrow.up")!
            case .closedCaptioning:
                return UIImage(systemName: "captions.bubble")!
            case .contentShareReceive:
                return UIImage(systemName: "arrowtriangle.right.square")!
            case .videoLayout:
                return UIImage(systemName: "rectangle.3.offgrid")!
            }
        }
        
        var storyboard: UIStoryboard {
            switch self {
            case .logUpload:
                return UIStoryboard(name: "LogUploadStoryboard", bundle: nil)
            case .closedCaptioning:
                return UIStoryboard(name: "ClosedCaptioningStoryboard", bundle: nil)
            case .contentShareReceive:
                return UIStoryboard(name: "ContentShareReceiveStoryboard", bundle: nil)
            case .videoLayout:
                return UIStoryboard(name: "VideoLayoutStoryboard", bundle: nil)
            }
        }
    }
}
