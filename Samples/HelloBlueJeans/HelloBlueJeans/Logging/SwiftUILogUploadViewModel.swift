//
//  SwiftUILogUploadViewModel.swift
//  HelloBlueJeans
//
//  Created by Hayden McDowall on 18/01/23.
//

import Foundation
import BJNClientSDK

class SwiftUILogUploadViewModel: ObservableObject {
    let loggingService: LoggingServiceProtocol
    
    @Published var userNameInput = ""
    @Published var commentInput = ""
    @Published var uploadResult = ""
    @Published var audioDumpEnabled = false
    @Published var isUploading = false
    @Published var isUploadButtonDisabled = false
    @Published var showingStatus = false

    
    init() {
        self.loggingService = BlueJeansSDK.loggingService
    }
    
    func toggleLoadingAndButtonDisabled(isLoading: Bool) {
        isUploading = isLoading
        isUploadButtonDisabled = isLoading
    }
    
    private func getLoggingMode(_ selectedValue: String) -> LoggingMode {
        switch selectedValue {
        case LoggingMode.error.description:
            return .error
        case LoggingMode.warning.description:
            return .warning
        case LoggingMode.info.description:
            return .info
        case LoggingMode.debug.description:
            return .debug
        case LoggingMode.verbose.description:
            return .verbose
        default:
            return .info
        }
    }
    
    func showUploadResult(for logUpload: LogUploadResult) {
        if userNameInput.isEmpty {
            uploadResult = "Username Field was empty"
            showingStatus = true
            return
        }
        
        switch logUpload {
        case .success:
            uploadResult = "Log Upload Success!"
        case .failure:
            uploadResult = "Log Upload Failed"
        default:
            return
        }
        
        showingStatus = true
    }
    
    func uploadLogs() {
        toggleLoadingAndButtonDisabled(isLoading: true)
        
        loggingService.uploadLogs(comments: commentInput, username: userNameInput) { [weak self] logUploadResult in
            guard let self = self else { return }
            self.showUploadResult(for: logUploadResult)
            self.toggleLoadingAndButtonDisabled(isLoading: false)
        }
    }
    
    func enableAudioDumpToggle() {
        loggingService.enableAudioCaptureDump(audioDumpEnabled)
    }
    
    func selectCurrentLogModeInPickerView(_ value: String) {
        loggingService.setLoggingMode(to: getLoggingMode(value))
    }
}
