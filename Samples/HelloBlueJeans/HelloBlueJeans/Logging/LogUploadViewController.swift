//
//  LogViewController.swift
//  HelloBlueJeans
//
//  Created by Thomas Roff on 1/03/22.
//

import UIKit
import BJNClientSDK

/// A class that shows the usage of the BlueJeans SDK Logging Service.
///
/// - The desired logging level can be set with `uploadActivityIndicator` and calls `setLoggingMode()` on `loggingService`.
/// - Can toggle the capturing of audio logs with `audioDumpEnableSwitch` and calls `enableAudioCaptureDump()`
/// - Retreives user input from `username` and `comments` text fields and calls `uploadLogs()` on `loggingService`.
/// - Shows an alert view controller containing a `LogUploadResult` of the log upload.
///
/// - Tag: LogUploadViewController
class LogUploadViewController: UIViewController {

    // MARK: - Properties

    @IBOutlet weak var uploadActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var uploadLogButton: UIButton!
    @IBOutlet weak var logModePicker: UIPickerView!
    @IBOutlet weak var audioDumpEnableSwitch: UISwitch!

    var loggingService: LoggingServiceProtocol!

    var logStates: [LoggingMode] = []

    /// This property holds the internal audio log state.
    /// Enabling Audio Capture dumps generates a lot of debug information, and should only be turned on for short periods when debugging audio issues.
    /// It is not intended for regular usage and may cause performance issues.
    var audioDumpEnabled = false {
        didSet {
            loggingService.enableAudioCaptureDump(audioDumpEnabled)
        }
    }

    // MARK: Initialisation
    override func viewDidLoad() {
        loggingService = BlueJeansSDK.loggingService
        logStates = LoggingMode.allCases
        setupUI()
    }

    @IBAction func enableAudioDumpToggle() {
        audioDumpEnabled = audioDumpEnableSwitch.isOn
    }
    
    /// Provide a username to loggingService with an optional comment to describe logs.
    @IBAction func uploadLogs() {
        guard let username = usernameTextField.text else { return }
        if username.isEmpty { return }
        
        guard let comment = commentTextField.text else { return }

        setButtonEnabledUI(to: false)

        loggingService.uploadLogs(comments: comment, username: username) { [weak self] logUploadResult in
            self?.showUploadResult(for: logUploadResult)
        }
    }
    
    func setButtonEnabledUI(to enabled: Bool) {
        if enabled {
            uploadLogButton.isEnabled = true
            uploadLogButton.alpha = 1
            uploadActivityIndicator.isHidden = true
        } else {
            uploadLogButton.isEnabled = false
            uploadLogButton.alpha = 0.5
            uploadActivityIndicator.isHidden = false
        }
    }

    // MARK: Setup onChange handlers
    
    func setupUI() {
        // Set delegate to handle keyboard events
        usernameTextField.delegate = self
        commentTextField.delegate = self
        
        logModePicker.dataSource = self
        logModePicker.delegate = self
        
        selectCurrentLogModeInPickerView(pickerView: logModePicker)
    }
    
    func selectCurrentLogModeInPickerView(pickerView: UIPickerView) {
        let logState = loggingService.loggingMode.value
        let indexOfLogState = logStates.firstIndex(of: logState)!
        pickerView.selectRow(indexOfLogState, inComponent: 0, animated: false)
    }

    /// This method presents an alert to notify the user of the upload result.
    func showUploadResult(for logUpload: LogUploadResult) {
        let title: String

        switch logUpload {
        case .success:
            title = "Log Upload Success!"
        case .failure:
            title = "Log Upload Failed"
        default:
            return
        }

        let resultAlert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        resultAlert.addAction(UIAlertAction(title: "Ok", style: .default))

        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.setButtonEnabledUI(to: true)
            self.present(resultAlert, animated: true)
        }
    }
}

// MARK: - Picker view data source

extension LogUploadViewController: UIPickerViewDelegate, UIPickerViewDataSource {

    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return logStates.count
    }

    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return logStates[row].description
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let state = logStates[row]
        loggingService.setLoggingMode(to: state)
    }
}

// MARK: - Extensions

extension LoggingMode: CustomStringConvertible, CaseIterable {
    
    public static var allCases: [LoggingMode] {
        return [.error, .warning, .info, .debug, .verbose]
    }

    /// Allows us to get a string representation of the LoggingMode.
    public var description: String {
            switch self {
            case .error:
                return "error"
            case .warning:
                return "warning"
            case .info:
                return "info"
            case .debug:
                return "debug"
            case .verbose:
                return "verbose"
            default:
                return "default"
            }
    }
}

extension UIViewController: UITextFieldDelegate {

    /// Dismiss the keyboard when the user taps the "Return" key while editing a text field.
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      textField.resignFirstResponder()
      return true
    }
}
