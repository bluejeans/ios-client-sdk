Change Log
==========

## Version 1.4.0
---------------------------------
### Added 
- 720p 16x9 Capture Support (on supported devices)
- `getSelfView()` and `getContentView()` methods that return a UIView that will automatically maintain the correct aspect ratio for it's video/content
- Color customization of video layouts, allows setting the background colors/gradients of the remote video views
### Deprecated
- `getSelfViewInstance()` and `getContentReceiveInstance()` deprecated in favour of the above `getSelfView()` and `getContentView()` methods. Now return a non-optional UIView

## Version 1.3.0

### Added
- Swift Package Manager Support
- Module Stability
- "Recording has started, has stopped, is on" audio notifications play by default when the meeting is being recorded
- privateChatService.participantsWithChats, the list of participants who have sent or received chat to/from the client during the meeting 

### Fixed
- Issue with private chat where offline participants unreadMessagesCount could not be cleared fixed.

## Version 1.2.0
---------------------------------

### ***Breaking Changes***

#### **Renamed**
- meetingService.participants -> meetingService.participantsService.participants
- BJNParticipant.isAudioMuted -> BJNParticipant.audioMuteState.muted
- BJNParticipant.isVideoMuted -> BJNParticipant.videoMuteState.muted

#### **Behaviour Changed**
- In meetingService.joinMeeting(...), the onCompletion closure will be called with JoinResult of `.success` when meetingState moves from `.validating` -> `.waitingRoom`
  when waiting room is enabled in the meeting. In 1.1.0, this was called when meetingState moved from `.waitingRoom` -> `connecting`. 
  
#### Added
- meetingService.participantsService
- participantsService.activeSpeaker, the current active speaker, or talking participant in the meeting
- MuteState, a struct which holds information about the overall mute state, and the local and remote (moderator) mute states
- meetingService.audioMuteState: BJNObservable<MuteState>
- meetingService.videoMuteState: BJNObservable<MuteState>
- meetingService.setRemoteAudioMuted(...), stops the audio stream of the meeting


## Version 1.1.0
---------------------------------

### ***Breaking Changes***

#### Renamed
- MeetingService -> MeetingServiceProtocol
- LoggingService -> LoggingServiceProtocol
- VideoDeviceService -> VideoDeviceServiceProtocol
- AudioDeviceService -> AudioDeviceServiceProtocol
- meetingService.leaveAndEndMeeting(kickoutDelayInSeconds: Int) -> meetingService.moderatorControlsService.endMeetingForAllParticipants(timeInSeconds: Int)]
- BJNMeeting -> MeetingInformation, meetingService.meetingInfo -> meetingService.meetingInformation

#### Removed
- ConnectionState (Use MeetingState instead)
- maxVideoBandwith removed from meetingService.join(...), can still be set as meetingService.maxVideoBandwith = ... before joining.

### Feature Additions
- ModeratorControlsService
    - Check if the client has moderator privileges
    - Start and stop recording
    - Mute the audio or video of one, or all participants
    - Drop a participant from the meeting
    - isModerator flag added to BJNParticipant
- Waiting Room Support
    - Join a waiting room enabled meeting
    - Added `.waitingRoom` to MeetingState
    - Events for approval, denial, meeting ended and demotion to waiting room.
- Waiting Room Moderation Support
    - View participants in the waiting room
    - Enable/disable waiting room
    - Check if a meeting supports waiting room
    - Admit or deny one or all participants in the WR
    - Demote a participant back to the WR
- Closed Caption Support
    - Check if the meeting supports Closed Captioning
    - Enable/disable closed captioning for the client
    - Observe the closed caption text
- Debugging Improvements
    - enableAudioCaptureDump(_ enable: Bool) 
- Remote Stream Enablement
    - Mute the remote video stream
    - Mute the remote content stream
- Meeting Information
    - Meeting ID added
    - Participant passcode added
    - Meeting owner username added
- PrivateChatService
    - isPrivateChatAvailable flag added - private chat can be disabled in some meetings.


## Version 1.0.0 
---------------------------------
### Features:

- Audio and Video Permission handling
- Join, End Meeting
- Self Video
- Remote Video, Remote Video states
- Content receive 
- Audio and Video self mute
- Orientation handling
- Toggle front / back camera
- Video Layout switch
- Participant list
- Participant properties: Audio mute state, Video mute state, is Self, Name and Unique Identifier
- Self Participant
- Screen Share
- Log Upload
- Multi-stream support ("Sequin" Video Layouts)
- Public and Private meeting Chat
- Remote Video mute
- Meeting Information (Title, Hostname, Meeting Id)
