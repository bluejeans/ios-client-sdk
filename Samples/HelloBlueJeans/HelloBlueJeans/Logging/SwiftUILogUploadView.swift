//
//  LogUpload.swift
//  HelloBlueJeans
//
//  Created by Hayden McDowall on 16/01/23.
//

import SwiftUI
import BJNClientSDK

struct SwiftUILogUploadView: View {
    
    // MARK: - Variables
    @ObservedObject var swiftUIlogViewModel = SwiftUILogUploadViewModel()
    
    @State private var selectedLogMode = LoggingMode.info.description
    @State private var keyboardHeight: CGFloat = 0
    
    var body: some View {
        VStack{
            // MARK: - Heading and loading spinner
            HStack {
                Text("SwiftUI Log Upload")
                    .font(.title)
                Spacer()
                if swiftUIlogViewModel.isUploading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(2)
                        .padding(.trailing, 10)
                }
            }.padding()
            
            VStack {
                ScrollView {
                    
                    // MARK: - Toggle audio dump
                    VStack {
                        Text("Audio logs will be captured while this switch is on and be sent next time logs are uploaded. Enabling Audio Capture dumps generates a lot of debug information, and should only be turned on for short periods when debugging audio issues. ")
                            .font(.body)
                            .padding()
                        
                        Toggle("Capture audio debug logs", isOn: $swiftUIlogViewModel.audioDumpEnabled)
                            .onChange(of: swiftUIlogViewModel.audioDumpEnabled) { value in swiftUIlogViewModel.enableAudioDumpToggle()
                            }
                            .padding(.horizontal)
                            .padding(.bottom, 10)
                    }
                    .background(Color(.systemGray6))
                    .padding(.horizontal)
                    
                    // MARK: - Capture level picker
                    VStack {
                        Text("Set the level to capture logs at. The level represents the extent of logging detail provided by the SDK in order to diagnose operations.")
                            .font(.body)
                            .padding(.horizontal)
                            .padding(.top, 10)
                            .padding(.bottom, 20)
                        
                        Picker("", selection: $selectedLogMode) {
                            ForEach(LoggingMode.allCases, id: \.self){
                                Text($0.description)
                                    .tag($0.description)
                            }
                        }
                        .onChange(of: selectedLogMode) { value in
                            swiftUIlogViewModel.selectCurrentLogModeInPickerView(value)
                        }
                        .pickerStyle(.wheel)
                        .background(Color(.systemGray5))
                        .padding(.horizontal, 10)
                        .padding(.bottom, 20)
                        
                    }.background(Color(.systemGray6))
                        .padding(.horizontal)
                    
                    // MARK: - Reporter details and comment
                    VStack{
                        Text("Upload recent BlueJeans logs to the BlueJeans Cloud. Can be used to to help us diagnose issues.")
                            .font(.body)
                            .padding(.horizontal)
                            .padding(.top, 10)
                            .padding(.bottom, 20)
                        
                        TextField("Username (required)", text: $swiftUIlogViewModel.userNameInput)
                            .padding(.vertical, 5)
                            .background(Color.white)
                            .padding(.horizontal)
                        
                        TextField("Comments (optional)", text: $swiftUIlogViewModel.commentInput)
                            .padding(.vertical, 5)
                            .background(Color.white)
                            .padding(.horizontal)
                            .padding(.bottom)
                    }.background(Color(.systemGray6))
                        .padding(.horizontal)
                }
            }
            
            // MARK: - Upload button
            VStack {
                Text("Upload Logs")
            }
            .padding(.horizontal, 125)
            .padding(.vertical, 10)
            .contentShape(Rectangle())
            .onTapGesture {
                swiftUIlogViewModel.uploadLogs()
            }
            .background(Color.blue)
            .foregroundColor(.white)
            .font(.body)
            
            // Changes the padding on the upload logs button depending on if the keyboard is present or not.
            .padding(.bottom, keyboardHeight > 0 ? 10 : 60)
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillChangeFrameNotification)) { notification in
                guard let keyboardEndFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
                keyboardHeight = keyboardEndFrame.height
            }
            .onAppear {
                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
                    keyboardHeight = 0
                }
            }
            .disabled($swiftUIlogViewModel.isUploadButtonDisabled.wrappedValue)
            .alert(isPresented: $swiftUIlogViewModel.showingStatus) {
                Alert(title: Text(swiftUIlogViewModel.uploadResult))
            }
        }
    }
}

struct LogUploadView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUILogUploadView()
    }
}
