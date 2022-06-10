
# ✨ Airtime Media SDK - Early Access ✨

## Installation

 1. Open an Xcode Project that you would like to add real-time capabilities to.
 2. Select `File->Add Packages...`.
 3. At the bottom of the Package Manager window, select `Add Local...`.
 4. Select the directory containing the accompanying `Package.swift` and then select `Add Package`.
 5. Under the `Link Binary with Libraries` build phase of your app target, add the `AirtimeMedia` library.
 6. In order to publish through `LocalStream`'s, you need to provide a microphone usage description in your Info.plist

## Limitations

 - Builds for ARM iOS and x86 Simulator.
 - Bitcode must be **disabled**

## Usage
Please consult the included `AirtimeMedia.doccarchive` for further details on the precise public API, e.g. `open AirtimeMedia.doccarchive/`.

### Creating a channel
The `AirtimeMedia` module exposes a singleton, `Engine.sharedInstance` that is the top level object to interact with the SDK. It can produce `Channel` objects.

A `Channel` object is your connection to a real time voice call. You can think of “joining” a `Channel` as an act similar to tuning into a radio frequency on a walkie-talkie. Instead of a radio frequency, a `Channel` tunes into a channel ID.

Once you create a channel through the `Engine`'s `joinChannel` function, you must retain the resulting object to stay connected. The channel will not be able to receive remote streams until the `start` method is called.
```Swift
// Swift
import AirtimeMedia

// Token variable doesn't do anything at the moment
let token = "this_does_not_matter"
// The channel ID is your Channel's identifier
let channelId = "id_for_participants_to_use"

// Keep this object around!
let channel = Engine.sharedInstance.joinChannel(token: token, channelId: channelId)
// Check if the channel was successfully created
guard let channel = channel else { fatalError() } // Handle error case

// Start the channel
channel.start()

// Store the channel somewhere safe
channelStorage.channel = channel
```
```objectivec
// Objective-C
@import AirtimeMedia

// Token variable doesn't do anything at the moment
NSString *token = @"this_does_not_matter";
// The channel ID is your Channel's identifier
NSString *channelId = @"id_for_participants_to_use";

// Keep this object around!
ATMChannel *channel = [ATMEngine.sharedInstance joinChannelWithToken:token
                                                                 channelId:channelId];

// Check if the channel was successfully created
if (channel == nil) {
  exit(); // Handle error case
}

// Start the channel
[channel start];

// Store the channel somewhere safe
channelStorage.channel = channel;
```

### Leaving a Channel
A Channel is left when all references to the Channel go out of scope, or if the `leave()` method is called on the Channel. `leave()` can be called on the Channel even before the Channel is joined. Once a Channel is left, it and all its streams will be terminated permanently, rendering the Channel object invalid and disposable. 

### Receiving streams
While you are connected to a channel, you will be receiving remote streams automatically. These streams will appear in the `remoteStreams` property on your `Channel` object. To be notified about when streams are added and removed from this connected streams set, you can subscribe to the provided notifications.
```Swift
import AirtimeMedia

let channel: Channel

NotificationCenter.default.addObserver(self,
                                       selector: #selector(onRemoteStreamAdded(_:)),
                                       name: ChannelNotification.remoteStreamWasAdded,
                                       object: channel)
                                       
NotificationCenter.default.addObserver(self,
                                       selector: #selector(onRemoteStreamRemoved(_:)),
                                       name: ChannelNotification.remoteStreamWasRemoved,
                                       object: channel)
```
```objectivec
// Objective-C
@import AirtimeMedia

ATMChannel *channel;

[NSNotificationCenter.defaultCenter addObserver:self
                                       selector:@selector(onRemoteStreamAdded:)
                                           name:ATMChannelNotification.remoteStreamWasAdded
                                         object:channel];
                                       
[NSNotificationCenter.defaultCenter addObserver:self
                                       selector:@selector(onRemoteStreamRemoved:)
                                           name:ATMChannelNotification.remoteStreamWasRemoved
                                         object:channel];
```
The notification's object will always be the channel whose `remoteStreams` set changed, and the `Notification` object parameter'  `userInfo` dictionary will contain the specific remote stream that was added or removed.
```Swift
// Swift

@objc func onRemoteStreamAdded(_ notif: NSNotification) {
  // The RemoteStream can be optionally retained
  // Otherwise it can be accessed from the channel's remoteStreams property
  let remoteStream = notif.userInfo?[ChannelNotification.Key.remoteStream] as? RemoteStream
}

```
```objectivec
// Objective-C

- (void)onRemoteStreamAdded:(NSNotification *)notif {
  // The RemoteStream can be optionally retained
  // Otherwise it can be accessed from the channel's remoteStreams property
  RemoteStream *remoteStream = [notif.userInfo valueForKey:ATMChannelNotificationKey.remoteStream];
}
```
### Remote streams
To interact with remote streams, you use a `RemoteStream` object. To check the state of a remote stream, you use the `connectionState` property. This property is observable through notifications.
```Swift
// Swift

let remoteStream: RemoteStream

NotificationCenter.default.addObserver(self,
                                       selector: #selector(onRemoteStreamConnectionChange(_:)),
                                       name: RemoteStreamNotification.connectionStateDidChange,
                                       object: remoteStream)

@objc func onRemoteStreamConnectionChange(_ notif: NSNotification) {
  // Check the current `connectionState` and respond accordingly
  let state = remoteStream.connectionState
  switch state {
  case .connecting:
  case .connected:
  case .terminated:
    // Optionally check the termination cause here
    let terminationCause = remoteStream.terminationCause
  }
}

```
```objectivec
// Objective-C

ATMRemoteStream *remoteStream;

[NSNotificationCenter.defaultCenter addObserver:self
                                       selector:@selector(onRemoteStreamConnectionChange:)
                                           name:ATMRemoteStreamNotification.connectionStateDidChange
                                         object:remoteStream];

- (void)onRemoteStreamConnectionChange:(NSNotification *)notif {
  // Check the current `connectionState` and respond accordingly
  ATMRemoteStreamConnectionState state = remoteStream.connectionState;
  switch(state) {
    case ATMRemoteStreamConnectionStateConnecting:
      break;
    case ATMRemoteStreamConnectionStateConnected:
      break;
    case ATMRemoteStreamConnectionStateTerminated:
      // Optionally check the termination cause here
      ATMRemoteStreamTerminationCause cause = remoteStream.terminationCause;
      break;
  }
}
```
If a remote stream is terminated, you can check the termination reason on the `terminationCause` property of the `RemoteStream`.  Once a remote stream is terminated, it will never revive, the `RemoteStream` object will no longer be valid, and the object will be removed from the corresponding `Channel`'s `remoteStreams` set property. Thus, if you no longer hold any strong references to the `RemoteStream` object, it will be destroyed.

#### RemoteStream mute state
The RemoteStream's mute state is tracked through the `remoteAudioMuted` property. You can observe changes to this property with the `RemoteStreamNotification.remoteAudioMuteStateWasSet` notification. The `remoteAudioMuted` property specifically represents whether the remote user has muted their stream or if the stream was administratively muted.

### Local streams
To send your own local audio to other channel members, you will need to make a `LocalStream`.

After starting, a `LocalStream`  can be muted or unmuted.  Muting is an asynchronous operation.  To unmute a stream, behind the scenes we must verify with a server that the User has permission to unmute themself.  On the other hand, a stream can always be muted immediately.


```Swift
// Swift
import AirtimeMedia

// ... create a channel

let localStream = channel.createLocalStream()
guard let localStream = localStream else { fatalError() } // Handle error case

// Start the local stream
localStream.start()

// Mute/unmute the audio
localStream.muteAudio(true)

// The local stream can be optionally retained or otherwise it can be accessed from the channel.

// When you wish to stop sending local audio, stop the local stream
localStream.stop()
```

```objectivec
// Objective-C
@import AirtimeMedia

// ... create a channel

ATMLocalStream *localStream = [channel createLocalStream];

// Check if the local stream was successfully created
if (localStream == nil) {
  exit(); // Handle error case
}

// Start the local stream
[localStream start];

// Mute/unmute the audio
[localStream muteAudio:YES];

// The local stream can be optionally retained or otherwise it can be accessed from the channel.

// When you wish to stop sending local audio, stop the local stream
[localStream stop];
```
