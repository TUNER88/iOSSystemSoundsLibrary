# iOSSystemSoundsLibrary

A reference list of the system sounds built into iOS, plus a small demo app that lists every file in `/System/Library/Audio/UISounds` and plays it when you tap it.

- Run the demo project **on a real device** to hear all available system sounds. The iOS Simulator does not play system sounds.
- See the [screenshot](#screenshot).
- API documentation for the `SystemSoundsLibrary` Swift package: <https://tuner88.github.io/iOSSystemSoundsLibrary/documentation/systemsoundslibrary/>

> [!NOTE]
> Apple does not officially document these SystemSoundIDs or file names. The mappings below were collected on iOS 7 and **may differ, be missing, or be added on other iOS versions**. Always test on the iOS versions you support.

## Contents

- [Usage](#usage)
  - [Swift](#swift)
  - [SwiftUI](#swiftui)
  - [Objective-C](#objective-c)
- [List of SystemSoundIDs](#list-of-systemsoundids)
- [List of all system audio files in iOS 7.0.2](#list-of-all-system-audio-files-in-ios-702)
- [SystemSoundIDs added after iOS 7](#systemsoundids-added-after-ios-7)
- [List of all system audio files in iOS 26](#list-of-all-system-audio-files-in-ios-26)
- [List of all system audio files in iOS 27](#list-of-all-system-audio-files-in-ios-27)
- [Changes since iOS 7](#changes-since-ios-7)
- [FAQ](#faq)
- [Compatibility notes](#compatibility-notes)
- [Related projects](#related-projects)
- [Screenshot](#screenshot)
- [License](#license)

## Usage

All examples use the `AudioToolbox` framework (System Sound Services). It is linked automatically when you import it in a modern Xcode project.

### Swift

Play a sound by its SystemSoundID:

```swift
import AudioToolbox

AudioServicesPlaySystemSound(1003) // SMSReceived (see the table below)
```

Play a file from `/System/Library/Audio/UISounds` and dispose of the sound when it has finished playing:

```swift
import AudioToolbox

func playSystemSoundFile(named fileName: String) {
    let url = URL(fileURLWithPath: "/System/Library/Audio/UISounds/\(fileName)")
    var soundID: SystemSoundID = 0
    guard AudioServicesCreateSystemSoundID(url as CFURL, &soundID) == kAudioServicesNoError else { return }
    AudioServicesPlaySystemSoundWithCompletion(soundID) {
        AudioServicesDisposeSystemSoundID(soundID)
    }
}

playSystemSoundFile(named: "ReceivedMessage.caf") // see the file list below
```

### SwiftUI

```swift
import SwiftUI
import AudioToolbox

struct ContentView: View {
    var body: some View {
        Button("Play “Tink”") {
            AudioServicesPlaySystemSound(1103) // KeyPressed (Tink.caf)
        }
    }
}
```

### Objective-C

```objective-c
#import <AudioToolbox/AudioToolbox.h>

// Play a sound by its SystemSoundID
AudioServicesPlaySystemSound(1003); // SMSReceived (see the table below)

// Play a file and dispose of the sound when it has finished playing
NSURL *fileURL = [NSURL fileURLWithPath:@"/System/Library/Audio/UISounds/ReceivedMessage.caf"]; // see the file list below
SystemSoundID soundID = 0;
if (AudioServicesCreateSystemSoundID((__bridge CFURLRef)fileURL, &soundID) == kAudioServicesNoError) {
    AudioServicesPlaySystemSoundWithCompletion(soundID, ^{
        AudioServicesDisposeSystemSoundID(soundID);
    });
}
```

`AudioServicesPlaySystemSoundWithCompletion` requires iOS 9 or later.

## List of SystemSoundIDs

Collected on iOS 7. Unofficial, and may differ on other iOS versions.

| SystemSoundID | File name | Category |
| --- | --- | --- |
| 1000 | new-mail.caf | MailReceived |
| 1001 | mail-sent.caf | MailSent |
| 1002 | Voicemail.caf | VoicemailReceived |
| 1003 | ReceivedMessage.caf | SMSReceived |
| 1004 | SentMessage.caf | SMSSent |
| 1005 | alarm.caf | CalendarAlert |
| 1006 | low_power.caf | LowPower |
| 1007 | sms-received1.caf | SMSReceived_Alert |
| 1008 | sms-received2.caf | SMSReceived_Alert |
| 1009 | sms-received3.caf | SMSReceived_Alert |
| 1010 | sms-received4.caf | SMSReceived_Alert |
| 1011 | - | SMSReceived_Vibrate |
| 1012 | sms-received1.caf | SMSReceived_Alert |
| 1013 | sms-received5.caf | SMSReceived_Alert |
| 1014 | sms-received6.caf | SMSReceived_Alert |
| 1015 | Voicemail.caf | - |
| 1016 | tweet_sent.caf | SMSSent |
| 1020 | Anticipate.caf | SMSReceived_Alert |
| 1021 | Bloom.caf | SMSReceived_Alert |
| 1022 | Calypso.caf | SMSReceived_Alert |
| 1023 | Choo_Choo.caf | SMSReceived_Alert |
| 1024 | Descent.caf | SMSReceived_Alert |
| 1025 | Fanfare.caf | SMSReceived_Alert |
| 1026 | Ladder.caf | SMSReceived_Alert |
| 1027 | Minuet.caf | SMSReceived_Alert |
| 1028 | News_Flash.caf | SMSReceived_Alert |
| 1029 | Noir.caf | SMSReceived_Alert |
| 1030 | Sherwood_Forest.caf | SMSReceived_Alert |
| 1031 | Spell.caf | SMSReceived_Alert |
| 1032 | Suspense.caf | SMSReceived_Alert |
| 1033 | Telegraph.caf | SMSReceived_Alert |
| 1034 | Tiptoes.caf | SMSReceived_Alert |
| 1035 | Typewriters.caf | SMSReceived_Alert |
| 1036 | Update.caf | SMSReceived_Alert |
| 1050 | ussd.caf | USSDAlert |
| 1051 | SIMToolkitCallDropped.caf | SIMToolkitTone |
| 1052 | SIMToolkitGeneralBeep.caf | SIMToolkitTone |
| 1053 | SIMToolkitNegativeACK.caf | SIMToolkitTone |
| 1054 | SIMToolkitPositiveACK.caf | SIMToolkitTone |
| 1055 | SIMToolkitSMS.caf | SIMToolkitTone |
| 1057 | Tink.caf | PINKeyPressed |
| 1070 | ct-busy.caf | AudioToneBusy |
| 1071 | ct-congestion.caf | AudioToneCongestion |
| 1072 | ct-path-ack.caf | AudioTonePathAcknowledge |
| 1073 | ct-error.caf | AudioToneError |
| 1074 | ct-call-waiting.caf | AudioToneCallWaiting |
| 1075 | ct-keytone2.caf | AudioToneKey2 |
| 1100 | lock.caf | ScreenLocked |
| 1101 | unlock.caf | ScreenUnlocked |
| 1102 | - | FailedUnlock |
| 1103 | Tink.caf | KeyPressed |
| 1104 | Tock.caf | KeyPressed |
| 1105 | Tock.caf | KeyPressed |
| 1106 | beep-beep.caf | ConnectedToPower |
| 1107 | RingerChanged.caf | RingerSwitchIndication |
| 1108 | photoShutter.caf | CameraShutter |
| 1109 | shake.caf | ShakeToShuffle |
| 1110 | jbl_begin.caf | JBL_Begin |
| 1111 | jbl_confirm.caf | JBL_Confirm |
| 1112 | jbl_cancel.caf | JBL_Cancel |
| 1113 | begin_record.caf | BeginRecording |
| 1114 | end_record.caf | EndRecording |
| 1115 | jbl_ambiguous.caf | JBL_Ambiguous |
| 1116 | jbl_no_match.caf | JBL_NoMatch |
| 1117 | begin_video_record.caf | BeginVideoRecording |
| 1118 | end_video_record.caf | EndVideoRecording |
| 1150 | vc\~invitation-accepted.caf | VCInvitationAccepted |
| 1151 | vc\~ringing.caf | VCRinging |
| 1152 | vc\~ended.caf | VCEnded |
| 1153 | ct-call-waiting.caf | VCCallWaiting |
| 1154 | vc\~ringing.caf | VCCallUpgrade |
| 1200 | dtmf-0.caf | TouchTone |
| 1201 | dtmf-1.caf | TouchTone |
| 1202 | dtmf-2.caf | TouchTone |
| 1203 | dtmf-3.caf | TouchTone |
| 1204 | dtmf-4.caf | TouchTone |
| 1205 | dtmf-5.caf | TouchTone |
| 1206 | dtmf-6.caf | TouchTone |
| 1207 | dtmf-7.caf | TouchTone |
| 1208 | dtmf-8.caf | TouchTone |
| 1209 | dtmf-9.caf | TouchTone |
| 1210 | dtmf-star.caf | TouchTone |
| 1211 | dtmf-pound.caf | TouchTone |
| 1254 | long_low_short_high.caf | Headset_StartCall |
| 1255 | short_double_high.caf | Headset_Redial |
| 1256 | short_low_high.caf | Headset_AnswerCall |
| 1257 | short_double_low.caf | Headset_EndCall |
| 1258 | short_double_low.caf | Headset_CallWaitingActions |
| 1259 | middle_9_short_double_low.caf | Headset_TransitionEnd |
| 1300 | Voicemail.caf | SystemSoundPreview |
| 1301 | ReceivedMessage.caf | SystemSoundPreview |
| 1302 | new-mail.caf | SystemSoundPreview |
| 1303 | mail-sent.caf | SystemSoundPreview |
| 1304 | alarm.caf | SystemSoundPreview |
| 1305 | lock.caf | SystemSoundPreview |
| 1306 | Tock.caf | KeyPressClickPreview |
| 1307 | sms-received1.caf | SMSReceived_Selection |
| 1308 | sms-received2.caf | SMSReceived_Selection |
| 1309 | sms-received3.caf | SMSReceived_Selection |
| 1310 | sms-received4.caf | SMSReceived_Selection |
| 1311 | - | SMSReceived_Vibrate |
| 1312 | sms-received1.caf | SMSReceived_Selection |
| 1313 | sms-received5.caf | SMSReceived_Selection |
| 1314 | sms-received6.caf | SMSReceived_Selection |
| 1315 | Voicemail.caf | SystemSoundPreview |
| 1320 | Anticipate.caf | SMSReceived_Selection |
| 1321 | Bloom.caf | SMSReceived_Selection |
| 1322 | Calypso.caf | SMSReceived_Selection |
| 1323 | Choo_Choo.caf | SMSReceived_Selection |
| 1324 | Descent.caf | SMSReceived_Selection |
| 1325 | Fanfare.caf | SMSReceived_Selection |
| 1326 | Ladder.caf | SMSReceived_Selection |
| 1327 | Minuet.caf | SMSReceived_Selection |
| 1328 | News_Flash.caf | SMSReceived_Selection |
| 1329 | Noir.caf | SMSReceived_Selection |
| 1330 | Sherwood_Forest.caf | SMSReceived_Selection |
| 1331 | Spell.caf | SMSReceived_Selection |
| 1332 | Suspense.caf | SMSReceived_Selection |
| 1333 | Telegraph.caf | SMSReceived_Selection |
| 1334 | Tiptoes.caf | SMSReceived_Selection |
| 1335 | Typewriters.caf | SMSReceived_Selection |
| 1336 | Update.caf | SMSReceived_Selection |
| 1350 | - | RingerVibeChanged |
| 1351 | - | SilentVibeChanged |
| 4095 | - | Vibrate |

## List of all system audio files in iOS 7.0.2

```text
/System/Library/Audio/UISounds/Modern/airdrop_invite.caf
/System/Library/Audio/UISounds/Modern/calendar_alert_chord.caf
/System/Library/Audio/UISounds/Modern/camera_shutter_burst.caf
/System/Library/Audio/UISounds/Modern/camera_shutter_burst_begin.caf
/System/Library/Audio/UISounds/Modern/camera_shutter_burst_end.caf
/System/Library/Audio/UISounds/Modern/sms_alert_aurora.caf
/System/Library/Audio/UISounds/Modern/sms_alert_bamboo.caf
/System/Library/Audio/UISounds/Modern/sms_alert_circles.caf
/System/Library/Audio/UISounds/Modern/sms_alert_complete.caf
/System/Library/Audio/UISounds/Modern/sms_alert_hello.caf
/System/Library/Audio/UISounds/Modern/sms_alert_input.caf
/System/Library/Audio/UISounds/Modern/sms_alert_keys.caf
/System/Library/Audio/UISounds/Modern/sms_alert_note.caf
/System/Library/Audio/UISounds/Modern/sms_alert_popcorn.caf
/System/Library/Audio/UISounds/Modern/sms_alert_synth.caf
/System/Library/Audio/UISounds/New/Anticipate.caf
/System/Library/Audio/UISounds/New/Bloom.caf
/System/Library/Audio/UISounds/New/Calypso.caf
/System/Library/Audio/UISounds/New/Choo_Choo.caf
/System/Library/Audio/UISounds/New/Descent.caf
/System/Library/Audio/UISounds/New/Fanfare.caf
/System/Library/Audio/UISounds/New/Ladder.caf
/System/Library/Audio/UISounds/New/Minuet.caf
/System/Library/Audio/UISounds/New/News_Flash.caf
/System/Library/Audio/UISounds/New/Noir.caf
/System/Library/Audio/UISounds/New/Sherwood_Forest.caf
/System/Library/Audio/UISounds/New/Spell.caf
/System/Library/Audio/UISounds/New/Suspense.caf
/System/Library/Audio/UISounds/New/Telegraph.caf
/System/Library/Audio/UISounds/New/Tiptoes.caf
/System/Library/Audio/UISounds/New/Typewriters.caf
/System/Library/Audio/UISounds/New/Update.caf
/System/Library/Audio/UISounds/ReceivedMessage.caf
/System/Library/Audio/UISounds/RingerChanged.caf
/System/Library/Audio/UISounds/SIMToolkitCallDropped.caf
/System/Library/Audio/UISounds/SIMToolkitGeneralBeep.caf
/System/Library/Audio/UISounds/SIMToolkitNegativeACK.caf
/System/Library/Audio/UISounds/SIMToolkitPositiveACK.caf
/System/Library/Audio/UISounds/SIMToolkitSMS.caf
/System/Library/Audio/UISounds/SentMessage.caf
/System/Library/Audio/UISounds/Swish.caf
/System/Library/Audio/UISounds/Tink.caf
/System/Library/Audio/UISounds/Tock.caf
/System/Library/Audio/UISounds/Voicemail.caf
/System/Library/Audio/UISounds/alarm.caf
/System/Library/Audio/UISounds/beep-beep.caf
/System/Library/Audio/UISounds/begin_record.caf
/System/Library/Audio/UISounds/begin_video_record.caf
/System/Library/Audio/UISounds/ct-busy.caf
/System/Library/Audio/UISounds/ct-call-waiting.caf
/System/Library/Audio/UISounds/ct-congestion.caf
/System/Library/Audio/UISounds/ct-error.caf
/System/Library/Audio/UISounds/ct-keytone2.caf
/System/Library/Audio/UISounds/ct-path-ack.caf
/System/Library/Audio/UISounds/dtmf-0.caf
/System/Library/Audio/UISounds/dtmf-1.caf
/System/Library/Audio/UISounds/dtmf-2.caf
/System/Library/Audio/UISounds/dtmf-3.caf
/System/Library/Audio/UISounds/dtmf-4.caf
/System/Library/Audio/UISounds/dtmf-5.caf
/System/Library/Audio/UISounds/dtmf-6.caf
/System/Library/Audio/UISounds/dtmf-7.caf
/System/Library/Audio/UISounds/dtmf-8.caf
/System/Library/Audio/UISounds/dtmf-9.caf
/System/Library/Audio/UISounds/dtmf-pound.caf
/System/Library/Audio/UISounds/dtmf-star.caf
/System/Library/Audio/UISounds/end_record.caf
/System/Library/Audio/UISounds/end_video_record.caf
/System/Library/Audio/UISounds/jbl_ambiguous.caf
/System/Library/Audio/UISounds/jbl_begin.caf
/System/Library/Audio/UISounds/jbl_cancel.caf
/System/Library/Audio/UISounds/jbl_confirm.caf
/System/Library/Audio/UISounds/jbl_no_match.caf
/System/Library/Audio/UISounds/lock.caf
/System/Library/Audio/UISounds/long_low_short_high.caf
/System/Library/Audio/UISounds/low_power.caf
/System/Library/Audio/UISounds/mail-sent.caf
/System/Library/Audio/UISounds/middle_9_short_double_low.caf
/System/Library/Audio/UISounds/new-mail.caf
/System/Library/Audio/UISounds/photoShutter.caf
/System/Library/Audio/UISounds/shake.caf
/System/Library/Audio/UISounds/short_double_high.caf
/System/Library/Audio/UISounds/short_double_low.caf
/System/Library/Audio/UISounds/short_low_high.caf
/System/Library/Audio/UISounds/sms-received1.caf
/System/Library/Audio/UISounds/sms-received2.caf
/System/Library/Audio/UISounds/sms-received3.caf
/System/Library/Audio/UISounds/sms-received4.caf
/System/Library/Audio/UISounds/sms-received5.caf
/System/Library/Audio/UISounds/sms-received6.caf
/System/Library/Audio/UISounds/sq_alarm.caf
/System/Library/Audio/UISounds/sq_beep-beep.caf
/System/Library/Audio/UISounds/sq_lock.caf
/System/Library/Audio/UISounds/sq_tock.caf
/System/Library/Audio/UISounds/tweet_sent.caf
/System/Library/Audio/UISounds/unlock.caf
/System/Library/Audio/UISounds/ussd.caf
/System/Library/Audio/UISounds/vc~ended.caf
/System/Library/Audio/UISounds/vc~invitation-accepted.caf
/System/Library/Audio/UISounds/vc~ringing.caf
```

<!-- BEGIN GENERATED: scripts/generate_readme.py from data/. Do not edit by hand. -->

## SystemSoundIDs added after iOS 7

293 IDs that aren't in the iOS 7 table above. Mappings and minimum versions come from [p-x9](https://github.com/p-x9/swift-system-sound/blob/e3f44c2d5766b0a7c3cdaacd4d61b5e1c8804794/SystemSoundTable.md) (MIT, iOS 16–26.0). Files were checked against the iOS 26 file list. Like everything here, they are unofficial, so test on a device. "≤ 16" means the ID existed in iOS 16 or earlier. The source data is in [`data/sounds.json`](data/sounds.json).

| SystemSoundID | File name | Folder | Category | Min iOS | Confidence |
| --- | --- | --- | --- | --- | --- |
| 30 | ringback_tone_ansi.caf | nano | InCallSystemSound | ≤ 16 | medium |
| 31 | ringback_tone_cept.caf | nano | InCallSystemSound | ≤ 16 | medium |
| 32 | busy_tone_ansi.caf | nano | InCallSystemSound | ≤ 16 | medium |
| 33 | busy_tone_cept.caf | nano | InCallSystemSound | ≤ 16 | medium |
| 34 | call_waiting_tone_ansi.caf | nano | InCallSystemSound | ≤ 16 | medium |
| 35 | call_waiting_tone_cept.caf | nano | InCallSystemSound | ≤ 16 | medium |
| 36 | end_call_tone_cept.caf | nano | EndOfCallTone_CEPT(iOS26\~) InCallSystemSound(\~iOS18) | ≤ 16 | medium |
| 37 | ringback_tone_hk.caf | nano | InCallSystemSound | ≤ 16 | medium |
| 38 | ringback_tone_aus.caf | nano | InCallSystemSound | ≤ 16 | medium |
| 39 | ringback_tone_uk.caf | nano | InCallSystemSound | ≤ 16 | medium |
| 1017 | alarm.caf | (root) | ReminderAlert | ≤ 16 | medium |
| 1018 | Swish.caf | (root) | MailSent | ≤ 16 | medium |
| 1060 | WebcamStart.caf | (root) | WebcamStartAlwaysHeard | 16.0 | medium |
| 1061 | LiquidDetected.caf | (root) | LiquidDetectedAlwaysHeard | 17.0 | medium |
| 1119 | camera_shutter_burst.caf | Modern | CameraShutterAlt | ≤ 16 | medium |
| 1120 | airdrop_invite.caf | Modern | AirDropInvitation | 17.0 | medium |
| 1121 | camera_shutter_burst_begin.caf | Modern | CameraShutterAlt | ≤ 16 | medium |
| 1122 | camera_shutter_burst_end.caf | Modern | CameraShutterAlt | ≤ 16 | medium |
| 1123 | key_press_click.caf | (root) | KeyPressClick_Remote | ≤ 16 | medium |
| 1124 | focus_change_keyboard.caf | (root) | FocusChangeKeyboard | ≤ 16 | medium |
| 1125 | focus_change_app_icon.caf | (root) | FocusChangeAppIcon | ≤ 16 | medium |
| 1126 | focus_change_large.caf | (root) | FocusChangeLarge | ≤ 16 | medium |
| 1127 | focus_change_small.caf | (root) | FocusChangeSmall | ≤ 16 | medium |
| 1128 | navigation_push.caf | (root) | NavigationPush | ≤ 16 | medium |
| 1129 | navigation_pop.caf | (root) | NavigationPop | ≤ 16 | medium |
| 1130 | keyboard_press_normal.caf | (root) | KeyboardPressNormal | ≤ 16 | medium |
| 1131 | keyboard_press_delete.caf | (root) | KeyboardPressDelete | ≤ 16 | medium |
| 1132 | keyboard_press_clear.caf | (root) | KeyboardPressClear | ≤ 16 | medium |
| 1133 | photoShutter.caf | (root) | - | 26.0 | medium |
| 1134 | begin_record.caf | (root) | - | 26.0 | medium |
| 1135 | end_record.caf | (root) | - | 26.0 | medium |
| 1155 | key_press_delete.caf | (root) | KeyPressed | ≤ 16 | medium |
| 1156 | key_press_modifier.caf | (root) | KeyPressed | ≤ 16 | medium |
| 1157 | wheels_of_time.caf | (root) | KeyPressed | ≤ 16 | medium |
| 1158 | go_to_sleep_alert.caf | (root) | GoToSleep_Alert | ≤ 16 | medium |
| 1159 | warsaw.caf | (root) | Warsaw | ≤ 16 | medium |
| 1160 | nfc_scan_complete.caf | (root) | PaymentSuccess | ≤ 16 | medium |
| 1161 | - | - | PearlSuccess | ≤ 16 | medium |
| 1162 | - | - | PearlFailure | ≤ 16 | medium |
| 1163 | access_scan_complete.caf | (root) | PaymentSuccess | ≤ 16 | medium |
| 1164 | - | - | USBHardening_Alert | ≤ 16 | medium |
| 1165 | 3rd_party_critical.caf | (root) | Critical_Alert | ≤ 16 | medium |
| 1166 | PaymentReceived.caf | (root) | PaymentReceived | ≤ 16 | medium |
| 1167 | Doorbell.caf | (root) | Doorbell | 16.0 | medium |
| 1168 | PaymentReceivedFailure.caf | (root) | PaymentReceivedFailure | 16.0 | medium |
| 1169 | EarInteraction_Complete.caf | (root) | EarInteraction_Complete | 18.1 | medium |
| 1174 | - | - | Time_To_Run | 16.0 | medium |
| 1175 | - | - | Time_To_Walk | 16.0 | medium |
| 1253 | DeviceShutdown.caf | (root) | DeviceShutdown | 16.0 | medium |
| 1260 | camera_timer_final_second.caf | (root) | CameraShutterAlt | ≤ 16 | medium |
| 1261 | camera_timer_countdown.caf | (root) | CameraShutterAlt | ≤ 16 | medium |
| 1262 | health_notification.caf | (root) | Health_Alert | ≤ 16 | medium |
| 1263 | MultiwayJoin.caf | nano | InCallSystemSound | ≤ 16 | medium |
| 1264 | MultiwayLeave.caf | nano | InCallSystemSound | ≤ 16 | medium |
| 1265 | multiway_invitation.caf | (root) | VCGroupInvitation_Alert | ≤ 16 | medium |
| 1270 | PushToTalkJoined.caf | nano | PushToTalkJoined | 16.2 | medium |
| 1271 | PushToTalkLeft.caf | nano | PushToTalkLeft | 16.2 | medium |
| 1272 | PushToTalkUnmute.caf | nano | PushToTalkUnmute | 16.2 | medium |
| 1273 | PushToTalkMute.caf | nano | PushToTalkMute | 16.2 | medium |
| 1274 | PushToTalkUnmuteFail.caf | nano | PushToTalkUnmuteFail | 16.2 | medium |
| 1275 | SenderConfirmation.caf | nano | IDCard_Sender_Confirmation | 17.0 | medium |
| 1276 | ReceiverConfirmation.caf | nano | IDCard_Receiver_Confirmation | 17.0 | medium |
| 1277 | ReceiverConnect.caf | nano | IDCard_Receiver_Connect | 17.0 | medium |
| 1278 | - | - | DictationBegin | 18.0 | medium |
| 1279 | - | - | DictationCancel | 18.0 | medium |
| 1280 | - | - | DictationConfirm | 18.0 | medium |
| 1281 | RemoteAttentionRequest_Alert.caf | (root) | RemoteAttentionRequest_Alert | 18.2 | medium |
| 1317 | alarm.caf | (root) | SystemSoundPreview_IgnoreRingerSwitch | ≤ 16 | medium |
| 1318 | Swish.caf | (root) | SystemSoundPreview_IgnoreRingerSwitch_NoVibe | ≤ 16 | medium |
| 1340 | PINEnterDigit_AX.caf | (root) | PINEnterDigit_AX | 16.0 | medium |
| 1341 | PINDelete_AX.caf | (root) | PINDelete_AX | 16.0 | medium |
| 1342 | PINSubmit_AX.caf | (root) | PINSubmit_AX | 16.0 | medium |
| 1343 | PINUnexpected.caf | (root) | PINUnexpected | 16.0 | medium |
| 1344 | PINEnterDigit.caf | (root) | PINEnterDigit | 16.0 | medium |
| 1345 | PINDelete.caf | (root) | PINDelete | 16.0 | medium |
| 1346 | NFCCardProvisioned.caf | (root) | NFCCardProvisioned(iOS26\~) | 18.0 | medium |
| 1347 | NFCCardComplete.caf | (root) | NFCCardComplete(iOS26\~) | 18.0 | medium |
| 1348 | NFCCardError.caf | (root) | NFCCardError(iOS26\~) | 18.0 | medium |
| 1352 | - | - | VibrateAlways | ≤ 16 | medium |
| 1360 | connect_power.caf | (root) | - | ≤ 16 | medium |
| 1361 | connect_power.caf | (root) | - | ≤ 16 | medium |
| 1362 | HeadphoneAudioExposureLimitExceeded.caf | nano | HeadphoneAudioExposureLimitExceeded | ≤ 16 | medium |
| 1363 | HealthNotificationUrgent.caf | nano | HealthNotificationUrgent | ≤ 16 | medium |
| 1364 | MicMute.caf | nano | InCallSystemSound | ≤ 16 | medium |
| 1365 | MicUnmute.caf | nano | InCallSystemSound | ≤ 16 | medium |
| 1366 | MicUnmuteFail.caf | nano | InCallSystemSound | ≤ 16 | medium |
| 1367 | ScreenSharingStarted.caf | nano | InCallSystemSound | ≤ 16 | medium |
| 1368 | MediaPaused.caf | nano | - | ≤ 16 | medium |
| 1369 | MediaHandoff.caf | nano | - | ≤ 16 | medium |
| 1370 | NavigationGenericManeuver.caf | (root) | NavigationGenericManeuver | ≤ 16 | medium |
| 1371 | HeadGesturesDoubleNod.caf | nano | - | 18.0 | medium |
| 1372 | HeadGesturesDoubleShake.caf | nano | - | 18.0 | medium |
| 1373 | HeadGesturesPartialNod.caf | nano | - | 18.0 | medium |
| 1374 | HeadGesturesPartialShake.caf | nano | - | 18.0 | medium |
| 1390 | LiveTranslationStart.caf | (root) | PersonalTranslator | 26.0 | medium |
| 1391 | LiveTranslationStop.caf | (root) | PersonalTranslator | 26.0 | medium |
| 1392 | DualBudLongPressFailure.caf | (root) | PersonalTranslator | 26.0 | medium |
| 1393 | ScreenCapture.caf | nano | CameraShutterAlt | ≤ 16 | medium |
| 1394 | payment_success.caf | (root) | PaymentSuccess | ≤ 16 | medium |
| 1395 | payment_failure.caf | (root) | PaymentFailure | ≤ 16 | medium |
| 1396 | acknowledgment_sent.caf | (root) | - | ≤ 16 | medium |
| 1397 | acknowledgment_received.caf | (root) | - | ≤ 16 | medium |
| 1398 | nfc_scan_failure.caf | (root) | PaymentFailure | ≤ 16 | medium |
| 1400 | Notification_Haptic.caf | nano | Notification_Haptic | ≤ 16 | medium |
| 1401 | Ringtone_US_Haptic.caf | nano | Ringtone_US_Haptic | ≤ 16 | medium |
| 1402 | Ringtone_UK_Haptic.caf | nano | Ringtone_UK_Haptic | ≤ 16 | medium |
| 1403 | Alarm_Haptic.caf | nano | Alarm_Haptic | ≤ 16 | medium |
| 1404 | SiriStart_Haptic.caf | nano | SiriStart_Haptic | ≤ 16 | medium |
| 1405 | SiriStopSuccess_Haptic.caf | nano | SiriStopSuccess_Haptic | ≤ 16 | medium |
| 1406 | SiriStopFailure_Haptic.caf | nano | SiriStopFailure_Haptic | ≤ 16 | medium |
| 1407 | Stockholm_Haptic.caf | nano | Stockholm_Haptic | ≤ 16 | medium |
| 1408 | Beat_Haptic.caf | nano | Beat_Haptic | ≤ 16 | medium |
| 1409 | - | - | RubberBand_Haptic | ≤ 16 | medium |
| 1410 | DoNotDisturb_Haptic.caf | nano | DoNotDisturb_Haptic | ≤ 16 | medium |
| 1411 | - | - | UIConfirmation_Haptic | ≤ 16 | medium |
| 1412 | - | - | ET_Heartbeat_Haptic | ≤ 16 | medium |
| 1413 | Timer_Haptic.caf | nano | Timer_Haptic | ≤ 16 | medium |
| 1414 | NavigationLeftTurn_Haptic.caf | nano | NavigationLeftTurn_Haptic | ≤ 16 | medium |
| 1415 | NavigationRightTurn_Haptic.caf | nano | NavigationRightTurn_Haptic | ≤ 16 | medium |
| 1416 | Detent_Haptic.caf | nano | Detent_Haptic | ≤ 16 | medium |
| 1417 | NavigationGenericManeuver_Haptic.caf | nano | NavigationGenericManeuver_Haptic | ≤ 16 | medium |
| 1418 | CameraCountdownTick_Haptic.caf | nano | CameraCountdownTick_Haptic | ≤ 16 | medium |
| 1419 | CameraCountdownImminent_Haptic.caf | nano | CameraCountdownImminent_Haptic | ≤ 16 | medium |
| 1420 | ET_RemoteTap_Receive_Haptic.caf | nano | ET_RemoteTap_Receive_Haptic | ≤ 16 | medium |
| 1421 | ET_RemoteTap_Send_Haptic.caf | nano | ET_RemoteTap_Send_Haptic | ≤ 16 | medium |
| 1422 | ET_BeginNotification_Haptic.caf | nano | ET_BeginNotification_Haptic | ≤ 16 | medium |
| 1423 | - | - | DoNotDisturbExpiryWarning_Haptic | ≤ 16 | medium |
| 1424 | StockholmActive_Haptic.caf | nano | StockholmActive_Haptic | ≤ 16 | medium |
| 1425 | StockholmActiveSingleCycle_Haptic.caf | nano | StockholmActiveSingleCycle_Haptic | ≤ 16 | medium |
| 1426 | StockholmFailure_Haptic.caf | nano | StockholmFailure_Haptic | ≤ 16 | medium |
| 1427 | SedentaryTimer_Haptic.caf | nano | SedentaryTimer_Haptic | ≤ 16 | medium |
| 1428 | HourlyChime_Haptic.caf | nano | HourlyChime_Haptic | ≤ 16 | medium |
| 1429 | Preview_AudioAndHaptic.caf | nano | Preview_AudioAndHaptic | ≤ 16 | medium |
| 1430 | Alert_ActivityGoalAttained_Haptic.caf | nano | Alert_ActivityGoalAttained_Haptic | ≤ 16 | medium |
| 1431 | Alert_ActivityGoalBehind_Haptic.caf | nano | Alert_ActivityGoalBehind_Haptic | ≤ 16 | medium |
| 1432 | Alert_ActivityGoalClose_Haptic.caf | nano | Alert_ActivityGoalClose_Haptic | ≤ 16 | medium |
| 1433 | Alert_BatteryLow_10p_Haptic.caf | nano | Alert_BatteryLow_Haptic | ≤ 16 | medium |
| 1434 | Alert_BatteryLow_5p_Haptic.caf | nano | Alert_BatteryCritical_Haptic | ≤ 16 | medium |
| 1435 | Alert_Calendar_Haptic.caf | nano | Alert_Calendar_Haptic | ≤ 16 | medium |
| 1436 | Notification_Haptic.caf | nano | Alert_Mail_Haptic | ≤ 16 | medium |
| 1437 | Notification_Haptic.caf | nano | Alert_Messages_1_Haptic | ≤ 16 | medium |
| 1438 | Notification_Haptic.caf | nano | Alert_Messages_2_Haptic | ≤ 16 | medium |
| 1439 | Notification_Haptic.caf | nano | Alert_Messages_3_Haptic | ≤ 16 | medium |
| 1440 | Alert_PassbookBalance_Haptic.caf | nano | Alert_PassbookBalance_Haptic | ≤ 16 | medium |
| 1441 | Alert_PassbookGeofence_Haptic.caf | nano | Alert_PassbookGeofence_Haptic | ≤ 16 | medium |
| 1442 | Alert_PhotostreamActivity_Haptic.caf | nano | Alert_PhotostreamActivity_Haptic | ≤ 16 | medium |
| 1443 | Alert_ReminderDue_Haptic.caf | nano | Alert_ReminderDue_Haptic | ≤ 16 | medium |
| 1444 | Notification_Haptic.caf | nano | Alert_Voicemail_Haptic | ≤ 16 | medium |
| 1445 | Alert_WalkieTalkie_Haptic.caf | nano | Alert_WalkieTalkie_Haptic | ≤ 16 | medium |
| 1446 | BatteryMagsafe_Haptic.caf | nano | BatteryMagsafe_Haptic | ≤ 16 | medium |
| 1447 | BuddyPairingFailure_Haptic.caf | nano | BuddyPairingFailure_Haptic | ≤ 16 | medium |
| 1448 | BuddyPairingSuccess_Haptic.caf | nano | BuddyPairingSuccess_Haptic | ≤ 16 | medium |
| 1449 | CameraShutter_Haptic.caf | nano | CameraShutter_Haptic | ≤ 16 | medium |
| 1450 | Alert_MapsDirectionsInApp_Haptic.caf | nano | Alert_MapsDirectionsInApp_Haptic | ≤ 16 | medium |
| 1451 | MessagesIncoming_Haptic.caf | nano | MessagesIncoming_Haptic | ≤ 16 | medium |
| 1452 | MessagesOutgoing_Haptic.caf | nano | MessagesOutgoing_Haptic | ≤ 16 | medium |
| 1453 | OnOffPasscodeFailure_Haptic.caf | nano | OnOffPasscodeFailure_Haptic | ≤ 16 | medium |
| 1457 | - | - | OrbInvoke_Haptic | ≤ 16 | medium |
| 1458 | OrbLayers_Haptic.caf | nano | OrbLayers_Haptic | ≤ 16 | medium |
| 1459 | PhoneHangUp_Haptic.caf | nano | PhoneHangUp_Haptic | ≤ 16 | medium |
| 1460 | PhotosZoomDetent_Haptic.caf | nano | PhotosZoomDetent_Haptic | ≤ 16 | medium |
| 1461 | QB_Dictation_Haptic.caf | nano | QB_Dictation_Haptic | ≤ 16 | medium |
| 1462 | - | - | SpringboardEdgeUniverse_Haptic | ≤ 16 | medium |
| 1463 | - | - | SpringboardHardStop_Haptic | ≤ 16 | medium |
| 1464 | StopwatchLap_Haptic.caf | nano | StopwatchLap_Haptic | ≤ 16 | medium |
| 1465 | StopwatchReset_Haptic.caf | nano | StopwatchReset_Haptic | ≤ 16 | medium |
| 1466 | StopwatchStart_Haptic.caf | nano | StopwatchStart_Haptic | ≤ 16 | medium |
| 1467 | StopwatchStop_Haptic.caf | nano | StopwatchStop_Haptic | ≤ 16 | medium |
| 1468 | TimerCancel_Haptic.caf | nano | TimerCancel_Haptic | ≤ 16 | medium |
| 1469 | TimerPause_Haptic.caf | nano | TimerPause_Haptic | ≤ 16 | medium |
| 1470 | TimerStart_Haptic.caf | nano | TimerStart_Haptic | ≤ 16 | medium |
| 1471 | TimerWheelHoursDetent_Haptic.caf | nano | TimerWheelHoursDetent_Haptic | ≤ 16 | medium |
| 1472 | WalkieTalkieActiveStart_Haptic.caf | nano | WalkieTalkieActiveStart_Haptic | ≤ 16 | medium |
| 1473 | WorkoutComplete_Haptic.caf | nano | WorkoutComplete_Haptic | ≤ 16 | medium |
| 1474 | WorkoutCountdown_Haptic.caf | nano | WorkoutCountdown_Haptic | ≤ 16 | medium |
| 1475 | Alert_3rdParty_Haptic.caf | nano | Alert_3rdParty_Haptic | ≤ 16 | medium |
| 1476 | WorkoutSelect_Haptic.caf | nano | WorkoutSelect_Haptic | ≤ 16 | medium |
| 1477 | WorkoutPressStart_Haptic.caf | nano | WorkoutPressStart_Haptic | ≤ 16 | medium |
| 1478 | - | - | ClockAnalogTick_Haptic | ≤ 16 | medium |
| 1479 | TimerWheelMinutesDetent_Haptic.caf | nano | TimerWheelMinutesDetent_Haptic | ≤ 16 | medium |
| 1480 | PhoneAnswer_Haptic.caf | nano | PhoneAnswer_Haptic | ≤ 16 | medium |
| 1481 | PhoneHold_Haptic.caf | nano | PhoneHold_Haptic | ≤ 16 | medium |
| 1482 | WalkieTalkieActiveEnd_Haptic.caf | nano | WalkieTalkieActiveEnd_Haptic | ≤ 16 | medium |
| 1483 | - | - | UISnap_Haptic | ≤ 16 | medium |
| 1484 | UISwitch_On_Haptic.caf | nano | UISwitch_On_Haptic | ≤ 16 | medium |
| 1485 | UISwitch_Off_Haptic.caf | nano | UISwitch_Off_Haptic | ≤ 16 | medium |
| 1486 | UISwipe_Haptic.caf | nano | UISwipe_Haptic | ≤ 16 | medium |
| 1487 | SystemStartup_Haptic.caf | nano | SystemStartup_Haptic | ≤ 16 | medium |
| 1488 | BuddyPairingRemoteConnection_Haptic.caf | nano | BuddyPairingRemoteConnection_Haptic | ≤ 16 | medium |
| 1489 | BuddyPairingRemoteTap_Haptic.caf | nano | BuddyPairingRemoteTap_Haptic | ≤ 16 | medium |
| 1490 | QB_Dictation_Off_Haptic.caf | nano | QB_Dictation_Off_Haptic | ≤ 16 | medium |
| 1491 | RingtoneDucked_US_Haptic.caf | nano | RingtoneDucked_US_Haptic | ≤ 16 | medium |
| 1492 | RingtoneDucked_UK_Haptic.caf | nano | RingtoneDucked_UK_Haptic | ≤ 16 | medium |
| 1493 | SalientNotification_Haptic.caf | nano | SalientNotification_Haptic | ≤ 16 | medium |
| 1494 | Notification_Salient_Haptic.caf | nano | Notification_Salient_Haptic | ≤ 16 | medium |
| 1495 | ET_BeginNotification_Salient_Haptic.caf | nano | ET_BeginNotification_Salient_Haptic | ≤ 16 | medium |
| 1496 | Alert_Calendar_Salient_Haptic.caf | nano | Alert_Calendar_Salient_Haptic | ≤ 16 | medium |
| 1497 | Notification_Salient_Haptic.caf | nano | Alert_Mail_Salient_Haptic | ≤ 16 | medium |
| 1498 | Notification_Salient_Haptic.caf | nano | Alert_Messages_1_Salient_Haptic | ≤ 16 | medium |
| 1499 | Alert_ReminderDue_Salient_Haptic.caf | nano | Alert_ReminderDue_Salient_Haptic | ≤ 16 | medium |
| 1500 | Notification_Salient_Haptic.caf | nano | Alert_Voicemail_Salient_Haptic | ≤ 16 | medium |
| 1501 | Alert_3rdParty_Salient_Haptic.caf | nano | Alert_3rdParty_Salient_Haptic | ≤ 16 | medium |
| 1502 | 3rdParty_DirectionUp_Haptic.caf | nano | 3rdParty_DirectionUp_Haptic | ≤ 16 | medium |
| 1503 | 3rdParty_DirectionDown_Haptic.caf | nano | 3rdParty_DirectionDown_Haptic | ≤ 16 | medium |
| 1504 | 3rdParty_Success_Haptic.caf | nano | 3rdParty_Success_Haptic | ≤ 16 | medium |
| 1505 | 3rdParty_Failure_Haptic.caf | nano | 3rdParty_Failure_Haptic | ≤ 16 | medium |
| 1506 | 3rdParty_Retry_Haptic.caf | nano | 3rdParty_Retry_Haptic | ≤ 16 | medium |
| 1507 | 3rdParty_Start_Haptic.caf | nano | 3rdParty_Start_Haptic | ≤ 16 | medium |
| 1508 | 3rdParty_Stop_Haptic.caf | nano | 3rdParty_Stop_Haptic | ≤ 16 | medium |
| 1509 | Alarm_Nightstand_Haptic.caf | nano | Alarm_Nightstand_Haptic | ≤ 16 | medium |
| 1510 | Alert_BatteryLow_5p_Salient_Haptic.caf | nano | Alert_BatteryCritical_Salient_Haptic | ≤ 16 | medium |
| 1511 | NavigationLeftTurn_Salient_Haptic.caf | nano | NavigationLeftTurn_Salient_Haptic | ≤ 16 | medium |
| 1512 | NavigationRightTurn_Salient_Haptic.caf | nano | NavigationRightTurn_Salient_Haptic | ≤ 16 | medium |
| 1513 | NavigationGenericManeuver_Salient_Haptic.caf | nano | NavigationGenericManeuver_Salient_Haptic | ≤ 16 | medium |
| 1514 | SedentaryTimer_Salient_Haptic.caf | nano | SedentaryTimer_Salient_Haptic | ≤ 16 | medium |
| 1515 | Alert_ActivityGoalAttained_Salient_Haptic.caf | nano | Alert_ActivityGoalAttained_Salient_Haptic | ≤ 16 | medium |
| 1516 | Alert_ActivityGoalBehind_Salient_Haptic.caf | nano | Alert_ActivityGoalBehind_Salient_Haptic | ≤ 16 | medium |
| 1517 | Alert_PassbookGeofence_Salient_Haptic.caf | nano | Alert_PassbookGeofence_Salient_Haptic | ≤ 16 | medium |
| 1518 | WorkoutSaved_Haptic.caf | nano | WorkoutSaved_Haptic | ≤ 16 | medium |
| 1519 | - | - | OrbPeek_Haptic | ≤ 16 | medium |
| 1520 | - | - | OrbPop_Haptic | ≤ 16 | medium |
| 1521 | - | - | OrbNegative_Haptic | ≤ 16 | medium |
| 1522 | VoiceOver_Click_Haptic.caf | nano | VoiceOver_Click_Haptic | ≤ 16 | medium |
| 1523 | SiriAutoSend_Haptic.caf | nano | SiriAutoSend_Haptic | ≤ 16 | medium |
| 1524 | - | - | HummingbirdCycle_Haptic | ≤ 16 | medium |
| 1525 | HummingbirdCompletion_Haptic.caf | nano | HummingbirdCompletion_Haptic | ≤ 16 | medium |
| 1526 | HummingbirdNotification_Haptic.caf | nano | HummingbirdNotification_Haptic | ≤ 16 | medium |
| 1527 | RemoteCameraShutterBurstBegin_Haptic.caf | nano | RemoteCameraShutterBurstBegin_Haptic | ≤ 16 | medium |
| 1528 | RemoteCameraShutterBurstEnd_Haptic.caf | nano | RemoteCameraShutterBurstEnd_Haptic | ≤ 16 | medium |
| 1529 | WorkoutPaused_Haptic.caf | nano | WorkoutPaused_Haptic | ≤ 16 | medium |
| 1530 | WorkoutResumed_Haptic.caf | nano | WorkoutResumed_Haptic | ≤ 16 | medium |
| 1531 | GoToSleep_Haptic.caf | nano | GoToSleep_Haptic | ≤ 16 | medium |
| 1532 | Warsaw_Haptic.caf | nano | Warsaw_Haptic | ≤ 16 | medium |
| 1533 | AutoUnlock_Haptic.caf | nano | AutoUnlock_Haptic | ≤ 16 | medium |
| 1534 | Alert_ActivityFriendsGoalAttained_Haptic.caf | nano | Alert_ActivityFriendsGoalAttained_Haptic | ≤ 16 | medium |
| 1535 | Alert_SpartanConnecting_Haptic.caf | nano | Alert_SpartanConnecting_Haptic | ≤ 16 | medium |
| 1536 | Alert_SpartanConnecting_LowLatency_Haptic.caf | nano | Alert_SpartanConnecting_LowLatency_Haptic | ≤ 16 | medium |
| 1537 | Alert_SpartanConnected_LowLatency_Haptic.caf | nano | Alert_SpartanConnected_LowLatency_Haptic | ≤ 16 | medium |
| 1538 | Alert_SpartanDisconnected_LowLatency_Haptic.caf | nano | Alert_SpartanDisconnected_LowLatency_Haptic | ≤ 16 | medium |
| 1539 | - | - | Alert_SpartanReminderEscalationLevel1_Haptic | ≤ 16 | medium |
| 1540 | - | - | Alert_SpartanReminderEscalationLevel2_Haptic | ≤ 16 | medium |
| 1541 | - | - | Alert_SpartanReminderEscalationLevel3_Haptic | ≤ 16 | medium |
| 1542 | - | - | Alert_SpartanReminderEscalationLevel4_Haptic | ≤ 16 | medium |
| 1543 | AccessScanComplete_Haptic.caf | nano | AccessScanComplete_Haptic | ≤ 16 | medium |
| 1544 | BuddyMigrationStart_Haptic.caf | nano | BuddyMigrationStart_Haptic | ≤ 16 | medium |
| 1545 | SOSFallDetectionPrompt_Haptic.caf | nano | SOSFallDetectionPrompt_Haptic | ≤ 16 | medium |
| 1546 | SOSEmergencyContactTextPrompt_Haptic.caf | nano | SOSEmergencyContactTextPrompt_Haptic | ≤ 16 | medium |
| 1547 | WorkoutStartAutodetect.caf | nano | WorkoutStartAutoDetected_Haptic | ≤ 16 | medium |
| 1548 | WorkoutCompleteAutodetect.caf | nano | WorkoutCompleteAutoDetected_Haptic | ≤ 16 | medium |
| 1549 | WorkoutPausedAutoDetect.caf | nano | WorkoutPausedAutoDetected_Haptic | ≤ 16 | medium |
| 1550 | WorkoutResumedAutoDetect.caf | nano | WorkoutResumedAutoDetected_Haptic | ≤ 16 | medium |
| 1551 | WorkoutPaceAbove.caf | nano | Alert_PaceAbove_Haptic | ≤ 16 | medium |
| 1552 | WorkoutPaceBelow.caf | nano | Alert_PaceBelow_Haptic | ≤ 16 | medium |
| 1553 | WalkieTalkieReceiveStart_Haptic.caf | nano | WalkieTalkieReceiveStart_Haptic | ≤ 16 | medium |
| 1554 | WalkieTalkieReceiveEnd_Haptic.caf | nano | WalkieTalkieReceiveEnd_Haptic | ≤ 16 | medium |
| 1555 | Alert_Health_Haptic.caf | nano | Alert_Health_Haptic | ≤ 16 | medium |
| 1556 | MultiwayJoin.caf | nano | InCallSystemSound | ≤ 16 | medium |
| 1557 | MultiwayLeave.caf | nano | InCallSystemSound | ≤ 16 | medium |
| 1558 | MultiwayInvitation.caf | nano | Alert_VCGroupInvitation_Haptic | ≤ 16 | medium |
| 1559 | 3rd_Party_Critical_Haptic.caf | nano | Alert_Critical_Haptic | ≤ 16 | medium |
| 1560 | Alert_1stParty_Haptic.caf | nano | Alert_FirstParty_Haptic | ≤ 16 | medium |
| 1561 | HealthNotificationUrgent.caf | nano | Alert_HealthNotificationUrgent_Haptic | ≤ 16 | medium |
| 1562 | - | - | Alert_Limit_Exceeded_Haptic | 16.0 | medium |
| 1563 | Siren_Countdown_Major_Haptic.caf | nano | Siren_Countdown_Major_Haptic | 16.0 | medium |
| 1564 | Siren_Countdown_Minor_Haptic.caf | nano | Siren_Countdown_Minor_Haptic | 16.0 | medium |
| 1565 | - | - | SunlightPrompt_Haptic | 16.0 | medium |
| 1566 | Doorbell_Haptic.caf | nano | Doorbell_Haptic | 16.0 | medium |
| 1567 | System_Notification_Haptic.caf | nano | System_Notification_Haptic | ≤ 16 | medium |
| 1568 | SOSFallDetectionPromptEscalation_Haptic.caf | nano | SOSFallDetectionPromptEscalation_Haptic | ≤ 16 | medium |
| 1569 | - | - | WalkAMile_Haptic | ≤ 16 | medium |
| 1570 | HealthReadingComplete_Haptic.caf | nano | HealthReadingComplete_Haptic | ≤ 16 | medium |
| 1571 | HealthReadingFail_Haptic.caf | nano | HealthReadingFail_Haptic | ≤ 16 | medium |
| 1572 | HeadphoneAudioExposureLimitExceeded.caf | nano | HeadphoneAudioExposureLimitExceeded_Haptic | ≤ 16 | medium |
| 1573 | ScreenCapture.caf | nano | CameraShutter_Haptic | ≤ 16 | medium |
| 1574 | - | - | Time_To_Run_Haptic | 16.0 | medium |
| 1575 | - | - | Time_To_Walk_Haptic | 16.0 | medium |
| 1576 | PushToTalkJoined.caf | nano | PushToTalkJoined_Haptic | 16.2 | medium |
| 1577 | PushToTalkLeft.caf | nano | PushToTalkLeft_Haptic | 16.2 | medium |
| 1578 | PushToTalkUnmute.caf | nano | PushToTalkUnmute_Haptic | 16.2 | medium |
| 1579 | PushToTalkMute.caf | nano | PushToTalkMute_Haptic | 16.2 | medium |
| 1580 | PushToTalkUnmuteFail.caf | nano | PushToTalkUnmuteFail_Haptic | 16.2 | medium |
| 1581 | WorkoutPrecisionStart_Haptic.caf | nano | WorkoutPrecisionStart_Haptic | 17.0 | medium |
| 1582 | IntervalEnded.caf | nano | Alert_IntervalEnded_Haptic | 16.2 | medium |
| 1583 | IntervalUpcoming.caf | nano | Alert_IntervalUpcoming_Haptic | 16.2 | medium |
| 1584 | Elevation.caf | nano | Elevation_Alert_Haptic | 17.0 | medium |
| 1585 | SenderConfirmation.caf | nano | IDCard_Sender_Confirmation_Haptic | 17.0 | medium |
| 1586 | ReceiverConfirmation.caf | nano | IDCard_Receiver_Confirmation_Haptic | 17.0 | medium |
| 1587 | ReceiverConnect.caf | nano | IDCard_Receiver_Connect_Haptic | 17.0 | medium |
| 1588 | RegattaTimer.caf | nano | - | 18.0 | medium |
| 1589 | SatelliteMessageSent.caf | nano | Satellite_Message_Sent_Haptic | 26.0 | medium |
| 3100 | - | - | AudioPrewarm | 16.0 | medium |
| 3101 | - | - | HapticPrewarm | 16.0 | medium |
| 4096 | - | - | UserAlert | ≤ 16 | medium |

## List of all system audio files in iOS 26

337 files, from a filesystem dump of iOS 26 (September 2025). Source: <https://3.onj.me/phonetones/unzipped/Apple/iOS-26/System/Library/Audio/UISounds/>, also in [`data/uisounds/ios-26.txt`](data/uisounds/ios-26.txt).

```text
/System/Library/Audio/UISounds/3rd_party_critical.caf
/System/Library/Audio/UISounds/DeviceShutdown.caf
/System/Library/Audio/UISounds/Doorbell.caf
/System/Library/Audio/UISounds/DualBudLongPressFailure.caf
/System/Library/Audio/UISounds/EarInteraction_Complete.caf
/System/Library/Audio/UISounds/LiquidDetected.caf
/System/Library/Audio/UISounds/LiveTranslationStart.caf
/System/Library/Audio/UISounds/LiveTranslationStop.caf
/System/Library/Audio/UISounds/Modern/airdrop_invite.caf
/System/Library/Audio/UISounds/Modern/camera_shutter_burst.caf
/System/Library/Audio/UISounds/Modern/camera_shutter_burst_begin.caf
/System/Library/Audio/UISounds/Modern/camera_shutter_burst_end.caf
/System/Library/Audio/UISounds/NFCCardComplete.caf
/System/Library/Audio/UISounds/NFCCardError.caf
/System/Library/Audio/UISounds/NFCCardProvisioned.caf
/System/Library/Audio/UISounds/NavigationGenericManeuver.caf
/System/Library/Audio/UISounds/New/Anticipate.caf
/System/Library/Audio/UISounds/New/Bloom.caf
/System/Library/Audio/UISounds/New/Calypso.caf
/System/Library/Audio/UISounds/New/Choo_Choo.caf
/System/Library/Audio/UISounds/New/Descent.caf
/System/Library/Audio/UISounds/New/Fanfare.caf
/System/Library/Audio/UISounds/New/Ladder.caf
/System/Library/Audio/UISounds/New/Minuet.caf
/System/Library/Audio/UISounds/New/News_Flash.caf
/System/Library/Audio/UISounds/New/Noir.caf
/System/Library/Audio/UISounds/New/Sherwood_Forest.caf
/System/Library/Audio/UISounds/New/Spell.caf
/System/Library/Audio/UISounds/New/Suspense.caf
/System/Library/Audio/UISounds/New/Telegraph.caf
/System/Library/Audio/UISounds/New/Tiptoes.caf
/System/Library/Audio/UISounds/New/Typewriters.caf
/System/Library/Audio/UISounds/New/Update.caf
/System/Library/Audio/UISounds/PINDelete.caf
/System/Library/Audio/UISounds/PINDelete_AX.caf
/System/Library/Audio/UISounds/PINEnterDigit.caf
/System/Library/Audio/UISounds/PINEnterDigit_AX.caf
/System/Library/Audio/UISounds/PINSubmit_AX.caf
/System/Library/Audio/UISounds/PINUnexpected.caf
/System/Library/Audio/UISounds/PaymentReceived.caf
/System/Library/Audio/UISounds/PaymentReceivedFailure.caf
/System/Library/Audio/UISounds/ReceivedMessage.caf
/System/Library/Audio/UISounds/RemoteAttentionRequest_Alert.caf
/System/Library/Audio/UISounds/RingerChanged.caf
/System/Library/Audio/UISounds/SIMToolkitCallDropped.caf
/System/Library/Audio/UISounds/SIMToolkitGeneralBeep.caf
/System/Library/Audio/UISounds/SIMToolkitNegativeACK.caf
/System/Library/Audio/UISounds/SIMToolkitPositiveACK.caf
/System/Library/Audio/UISounds/SIMToolkitSMS.caf
/System/Library/Audio/UISounds/SentMessage.caf
/System/Library/Audio/UISounds/Swish.caf
/System/Library/Audio/UISounds/Tink.caf
/System/Library/Audio/UISounds/Tock.caf
/System/Library/Audio/UISounds/WebcamStart.caf
/System/Library/Audio/UISounds/access_scan_complete.caf
/System/Library/Audio/UISounds/acknowledgment_received.caf
/System/Library/Audio/UISounds/acknowledgment_sent.caf
/System/Library/Audio/UISounds/alarm.caf
/System/Library/Audio/UISounds/begin_record.caf
/System/Library/Audio/UISounds/camera_timer_countdown.caf
/System/Library/Audio/UISounds/camera_timer_final_second.caf
/System/Library/Audio/UISounds/connect_power.caf
/System/Library/Audio/UISounds/ct-busy.caf
/System/Library/Audio/UISounds/ct-congestion.caf
/System/Library/Audio/UISounds/ct-error.caf
/System/Library/Audio/UISounds/ct-keytone2.caf
/System/Library/Audio/UISounds/ct-path-ack.caf
/System/Library/Audio/UISounds/end_record.caf
/System/Library/Audio/UISounds/focus_change_app_icon.caf
/System/Library/Audio/UISounds/focus_change_keyboard.caf
/System/Library/Audio/UISounds/focus_change_large.caf
/System/Library/Audio/UISounds/focus_change_small.caf
/System/Library/Audio/UISounds/go_to_sleep_alert.caf
/System/Library/Audio/UISounds/health_notification.caf
/System/Library/Audio/UISounds/jbl_ambiguous.caf
/System/Library/Audio/UISounds/jbl_begin.caf
/System/Library/Audio/UISounds/jbl_begin_short.caf
/System/Library/Audio/UISounds/jbl_begin_short_carplay.caf
/System/Library/Audio/UISounds/jbl_cancel.caf
/System/Library/Audio/UISounds/jbl_confirm.caf
/System/Library/Audio/UISounds/jbl_no_match.caf
/System/Library/Audio/UISounds/key_press_click.caf
/System/Library/Audio/UISounds/key_press_delete.caf
/System/Library/Audio/UISounds/key_press_modifier.caf
/System/Library/Audio/UISounds/keyboard_press_clear.caf
/System/Library/Audio/UISounds/keyboard_press_delete.caf
/System/Library/Audio/UISounds/keyboard_press_normal.caf
/System/Library/Audio/UISounds/lock.caf
/System/Library/Audio/UISounds/long_low_short_high.caf
/System/Library/Audio/UISounds/low_power.caf
/System/Library/Audio/UISounds/mail-sent.caf
/System/Library/Audio/UISounds/middle_9_short_double_low.caf
/System/Library/Audio/UISounds/multiway_invitation.caf
/System/Library/Audio/UISounds/nano/3rdParty_DirectionDown_Haptic.caf
/System/Library/Audio/UISounds/nano/3rdParty_DirectionUp_Haptic.caf
/System/Library/Audio/UISounds/nano/3rdParty_Failure_Haptic.caf
/System/Library/Audio/UISounds/nano/3rdParty_Retry_Haptic.caf
/System/Library/Audio/UISounds/nano/3rdParty_Start_Haptic.caf
/System/Library/Audio/UISounds/nano/3rdParty_Stop_Haptic.caf
/System/Library/Audio/UISounds/nano/3rdParty_Success_Haptic.caf
/System/Library/Audio/UISounds/nano/3rd_Party_Critical_Haptic.caf
/System/Library/Audio/UISounds/nano/AccessScanComplete_Haptic.caf
/System/Library/Audio/UISounds/nano/Alarm_Haptic.caf
/System/Library/Audio/UISounds/nano/Alarm_Nightstand_Haptic.caf
/System/Library/Audio/UISounds/nano/Alert_1stParty_Haptic.caf
/System/Library/Audio/UISounds/nano/Alert_3rdParty_Haptic.caf
/System/Library/Audio/UISounds/nano/Alert_3rdParty_Salient_Haptic.caf
/System/Library/Audio/UISounds/nano/Alert_ActivityFriendsGoalAttained_Haptic.caf
/System/Library/Audio/UISounds/nano/Alert_ActivityGoalAttained_Haptic.caf
/System/Library/Audio/UISounds/nano/Alert_ActivityGoalAttained_Salient_Haptic.caf
/System/Library/Audio/UISounds/nano/Alert_ActivityGoalBehind_Haptic.caf
/System/Library/Audio/UISounds/nano/Alert_ActivityGoalBehind_Salient_Haptic.caf
/System/Library/Audio/UISounds/nano/Alert_ActivityGoalClose_Haptic.caf
/System/Library/Audio/UISounds/nano/Alert_BatteryLow_10p_Haptic.caf
/System/Library/Audio/UISounds/nano/Alert_BatteryLow_5p_Haptic.caf
/System/Library/Audio/UISounds/nano/Alert_BatteryLow_5p_Salient_Haptic.caf
/System/Library/Audio/UISounds/nano/Alert_Calendar_Haptic.caf
/System/Library/Audio/UISounds/nano/Alert_Calendar_Salient_Haptic.caf
/System/Library/Audio/UISounds/nano/Alert_Health_Haptic.caf
/System/Library/Audio/UISounds/nano/Alert_MapsDirectionsInApp_Haptic.caf
/System/Library/Audio/UISounds/nano/Alert_PassbookBalance_Haptic.caf
/System/Library/Audio/UISounds/nano/Alert_PassbookGeofence_Haptic.caf
/System/Library/Audio/UISounds/nano/Alert_PassbookGeofence_Salient_Haptic.caf
/System/Library/Audio/UISounds/nano/Alert_PhotostreamActivity_Haptic.caf
/System/Library/Audio/UISounds/nano/Alert_ReminderDue_Haptic.caf
/System/Library/Audio/UISounds/nano/Alert_ReminderDue_Salient_Haptic.caf
/System/Library/Audio/UISounds/nano/Alert_SpartanConnected_LowLatency_Haptic.caf
/System/Library/Audio/UISounds/nano/Alert_SpartanConnecting_Haptic.caf
/System/Library/Audio/UISounds/nano/Alert_SpartanConnecting_LowLatency_Haptic.caf
/System/Library/Audio/UISounds/nano/Alert_SpartanDisconnected_LowLatency_Haptic.caf
/System/Library/Audio/UISounds/nano/Alert_Voicemail_Haptic.caf
/System/Library/Audio/UISounds/nano/Alert_Voicemail_Salient_Haptic.caf
/System/Library/Audio/UISounds/nano/Alert_WalkieTalkie_Haptic.caf
/System/Library/Audio/UISounds/nano/AutoUnlock_Haptic.caf
/System/Library/Audio/UISounds/nano/BatteryMagsafe_Haptic.caf
/System/Library/Audio/UISounds/nano/Beat_Haptic.caf
/System/Library/Audio/UISounds/nano/BuddyMigrationStart_Haptic.caf
/System/Library/Audio/UISounds/nano/BuddyPairingFailure_Haptic.caf
/System/Library/Audio/UISounds/nano/BuddyPairingRemoteConnection_Haptic.caf
/System/Library/Audio/UISounds/nano/BuddyPairingRemoteTap_Haptic.caf
/System/Library/Audio/UISounds/nano/BuddyPairingSuccess_Haptic.caf
/System/Library/Audio/UISounds/nano/CameraCountdownImminent_Haptic.caf
/System/Library/Audio/UISounds/nano/CameraCountdownTick_Haptic.caf
/System/Library/Audio/UISounds/nano/CameraShutter_Haptic.caf
/System/Library/Audio/UISounds/nano/Detent_Haptic.caf
/System/Library/Audio/UISounds/nano/DoNotDisturb_Haptic.caf
/System/Library/Audio/UISounds/nano/Doorbell_Haptic.caf
/System/Library/Audio/UISounds/nano/ET_BeginNotification_Haptic.caf
/System/Library/Audio/UISounds/nano/ET_BeginNotification_Salient_Haptic.caf
/System/Library/Audio/UISounds/nano/ET_RemoteTap_Receive_Haptic.caf
/System/Library/Audio/UISounds/nano/ET_RemoteTap_Send_Haptic.caf
/System/Library/Audio/UISounds/nano/Elevation.caf
/System/Library/Audio/UISounds/nano/GoToSleep_Haptic.caf
/System/Library/Audio/UISounds/nano/HeadGesturesDoubleNod.caf
/System/Library/Audio/UISounds/nano/HeadGesturesDoubleShake.caf
/System/Library/Audio/UISounds/nano/HeadGesturesPartialNod.caf
/System/Library/Audio/UISounds/nano/HeadGesturesPartialShake.caf
/System/Library/Audio/UISounds/nano/HeadphoneAudioExposureLimitExceeded.caf
/System/Library/Audio/UISounds/nano/HealthNotificationUrgent.caf
/System/Library/Audio/UISounds/nano/HealthReadingComplete_Haptic.caf
/System/Library/Audio/UISounds/nano/HealthReadingFail_Haptic.caf
/System/Library/Audio/UISounds/nano/HourlyChime_Haptic.caf
/System/Library/Audio/UISounds/nano/HummingbirdCompletion_Haptic.caf
/System/Library/Audio/UISounds/nano/HummingbirdNotification_Haptic.caf
/System/Library/Audio/UISounds/nano/IntervalEnded.caf
/System/Library/Audio/UISounds/nano/IntervalUpcoming.caf
/System/Library/Audio/UISounds/nano/MediaHandoff.caf
/System/Library/Audio/UISounds/nano/MediaPaused.caf
/System/Library/Audio/UISounds/nano/MessagesIncoming_Haptic.caf
/System/Library/Audio/UISounds/nano/MessagesOutgoing_Haptic.caf
/System/Library/Audio/UISounds/nano/MicMute.caf
/System/Library/Audio/UISounds/nano/MicUnmute.caf
/System/Library/Audio/UISounds/nano/MicUnmuteFail.caf
/System/Library/Audio/UISounds/nano/MultiwayInvitation.caf
/System/Library/Audio/UISounds/nano/MultiwayJoin.caf
/System/Library/Audio/UISounds/nano/MultiwayLeave.caf
/System/Library/Audio/UISounds/nano/NanoAlert10.caf
/System/Library/Audio/UISounds/nano/NanoAlert10_Prominent.caf
/System/Library/Audio/UISounds/nano/NanoAlert2.caf
/System/Library/Audio/UISounds/nano/NanoAlert2_Prominent.caf
/System/Library/Audio/UISounds/nano/NanoAlert3.caf
/System/Library/Audio/UISounds/nano/NanoAlert3_Prominent.caf
/System/Library/Audio/UISounds/nano/NanoAlert4.caf
/System/Library/Audio/UISounds/nano/NanoAlert4_Promiment.caf
/System/Library/Audio/UISounds/nano/NanoAlert5.caf
/System/Library/Audio/UISounds/nano/NanoAlert5_Prominent.caf
/System/Library/Audio/UISounds/nano/NanoAlert6.caf
/System/Library/Audio/UISounds/nano/NanoAlert6_Prominent.caf
/System/Library/Audio/UISounds/nano/NanoRingtone3.caf
/System/Library/Audio/UISounds/nano/NanoRingtone4.caf
/System/Library/Audio/UISounds/nano/NanoRingtone6.caf
/System/Library/Audio/UISounds/nano/NavigationGenericManeuver_Haptic.caf
/System/Library/Audio/UISounds/nano/NavigationGenericManeuver_Salient_Haptic.caf
/System/Library/Audio/UISounds/nano/NavigationLeftTurn_Haptic.caf
/System/Library/Audio/UISounds/nano/NavigationLeftTurn_Salient_Haptic.caf
/System/Library/Audio/UISounds/nano/NavigationRightTurn_Haptic.caf
/System/Library/Audio/UISounds/nano/NavigationRightTurn_Salient_Haptic.caf
/System/Library/Audio/UISounds/nano/Notification_Haptic.caf
/System/Library/Audio/UISounds/nano/Notification_Salient_Haptic.caf
/System/Library/Audio/UISounds/nano/OnOffPasscodeFailure_Haptic.caf
/System/Library/Audio/UISounds/nano/OnOffPasscodeUnlockCampanion_Haptic.caf
/System/Library/Audio/UISounds/nano/OnOffPasscodeUnlock_Haptic.caf
/System/Library/Audio/UISounds/nano/OrbExit_Haptic.caf
/System/Library/Audio/UISounds/nano/OrbLayers_Haptic.caf
/System/Library/Audio/UISounds/nano/PhoneAnswer_Haptic.caf
/System/Library/Audio/UISounds/nano/PhoneHangUp_Haptic.caf
/System/Library/Audio/UISounds/nano/PhoneHold_Haptic.caf
/System/Library/Audio/UISounds/nano/PhotosZoomDetent_Haptic.caf
/System/Library/Audio/UISounds/nano/Preview_AudioAndHaptic.caf
/System/Library/Audio/UISounds/nano/PushToTalkJoined.caf
/System/Library/Audio/UISounds/nano/PushToTalkLeft.caf
/System/Library/Audio/UISounds/nano/PushToTalkMute.caf
/System/Library/Audio/UISounds/nano/PushToTalkUnmute.caf
/System/Library/Audio/UISounds/nano/PushToTalkUnmuteFail.caf
/System/Library/Audio/UISounds/nano/QB_Dictation_Haptic.caf
/System/Library/Audio/UISounds/nano/QB_Dictation_Off_Haptic.caf
/System/Library/Audio/UISounds/nano/ReceiverConfirmation.caf
/System/Library/Audio/UISounds/nano/ReceiverConnect.caf
/System/Library/Audio/UISounds/nano/RegattaTimer.caf
/System/Library/Audio/UISounds/nano/RemoteCameraShutterBurstBegin_Haptic.caf
/System/Library/Audio/UISounds/nano/RemoteCameraShutterBurstEnd_Haptic.caf
/System/Library/Audio/UISounds/nano/RingtoneDucked_UK_Haptic.caf
/System/Library/Audio/UISounds/nano/RingtoneDucked_US_Haptic.caf
/System/Library/Audio/UISounds/nano/Ringtone_2_Ducked_Haptic-sashimi.caf
/System/Library/Audio/UISounds/nano/Ringtone_2_Haptic-sashimi.caf
/System/Library/Audio/UISounds/nano/Ringtone_UK_Haptic.caf
/System/Library/Audio/UISounds/nano/Ringtone_US_Haptic.caf
/System/Library/Audio/UISounds/nano/SOSEmergencyContactTextPrompt_Haptic.caf
/System/Library/Audio/UISounds/nano/SOSFallDetectionPromptEscalation_Haptic.caf
/System/Library/Audio/UISounds/nano/SOSFallDetectionPrompt_Haptic.caf
/System/Library/Audio/UISounds/nano/SalientNotification_Haptic.caf
/System/Library/Audio/UISounds/nano/SatelliteMessageSent.caf
/System/Library/Audio/UISounds/nano/ScreenCapture.caf
/System/Library/Audio/UISounds/nano/ScreenSharingStarted.caf
/System/Library/Audio/UISounds/nano/SedentaryTimer_Haptic.caf
/System/Library/Audio/UISounds/nano/SedentaryTimer_Salient_Haptic.caf
/System/Library/Audio/UISounds/nano/SenderConfirmation.caf
/System/Library/Audio/UISounds/nano/Siren_Countdown_Major_Haptic.caf
/System/Library/Audio/UISounds/nano/Siren_Countdown_Minor_Haptic.caf
/System/Library/Audio/UISounds/nano/SiriAutoSend_Haptic.caf
/System/Library/Audio/UISounds/nano/SiriStart_Haptic.caf
/System/Library/Audio/UISounds/nano/SiriStopFailure_Haptic.caf
/System/Library/Audio/UISounds/nano/SiriStopSuccess_Haptic.caf
/System/Library/Audio/UISounds/nano/StockholmActiveSingleCycle_Haptic.caf
/System/Library/Audio/UISounds/nano/StockholmActive_Haptic.caf
/System/Library/Audio/UISounds/nano/StockholmFailure_Haptic.caf
/System/Library/Audio/UISounds/nano/Stockholm_Haptic.caf
/System/Library/Audio/UISounds/nano/StopwatchLap_Haptic.caf
/System/Library/Audio/UISounds/nano/StopwatchReset_Haptic.caf
/System/Library/Audio/UISounds/nano/StopwatchStart_Haptic.caf
/System/Library/Audio/UISounds/nano/StopwatchStop_Haptic.caf
/System/Library/Audio/UISounds/nano/SystemStartup_Haptic.caf
/System/Library/Audio/UISounds/nano/System_Notification_Haptic.caf
/System/Library/Audio/UISounds/nano/TimerCancel_Haptic.caf
/System/Library/Audio/UISounds/nano/TimerPause_Haptic.caf
/System/Library/Audio/UISounds/nano/TimerStart_Haptic.caf
/System/Library/Audio/UISounds/nano/TimerWheelHoursDetent_Haptic.caf
/System/Library/Audio/UISounds/nano/TimerWheelMinutesDetent_Haptic.caf
/System/Library/Audio/UISounds/nano/Timer_Haptic.caf
/System/Library/Audio/UISounds/nano/UISwipe_Haptic.caf
/System/Library/Audio/UISounds/nano/UISwitch_Off_Haptic.caf
/System/Library/Audio/UISounds/nano/UISwitch_On_Haptic.caf
/System/Library/Audio/UISounds/nano/VoiceOver_Click_Haptic.caf
/System/Library/Audio/UISounds/nano/WalkAMile_Haptic.caf
/System/Library/Audio/UISounds/nano/WalkieTalkieActiveEnd_Haptic.caf
/System/Library/Audio/UISounds/nano/WalkieTalkieActiveStart_Haptic.caf
/System/Library/Audio/UISounds/nano/WalkieTalkieReceiveEnd_Haptic.caf
/System/Library/Audio/UISounds/nano/WalkieTalkieReceiveStart_Haptic.caf
/System/Library/Audio/UISounds/nano/Warsaw_Haptic.caf
/System/Library/Audio/UISounds/nano/WorkoutCompleteAutodetect.caf
/System/Library/Audio/UISounds/nano/WorkoutComplete_Haptic.caf
/System/Library/Audio/UISounds/nano/WorkoutCountdown_Haptic.caf
/System/Library/Audio/UISounds/nano/WorkoutPaceAbove.caf
/System/Library/Audio/UISounds/nano/WorkoutPaceBelow.caf
/System/Library/Audio/UISounds/nano/WorkoutPausedAutoDetect.caf
/System/Library/Audio/UISounds/nano/WorkoutPaused_Haptic.caf
/System/Library/Audio/UISounds/nano/WorkoutPrecisionStart_Haptic.caf
/System/Library/Audio/UISounds/nano/WorkoutPressStart_Haptic.caf
/System/Library/Audio/UISounds/nano/WorkoutResumedAutoDetect.caf
/System/Library/Audio/UISounds/nano/WorkoutResumed_Haptic.caf
/System/Library/Audio/UISounds/nano/WorkoutSaved_Haptic.caf
/System/Library/Audio/UISounds/nano/WorkoutSelect_Haptic.caf
/System/Library/Audio/UISounds/nano/WorkoutStartAutodetect.caf
/System/Library/Audio/UISounds/nano/busy_tone_ansi.caf
/System/Library/Audio/UISounds/nano/busy_tone_cept.caf
/System/Library/Audio/UISounds/nano/call_waiting_tone_ansi.caf
/System/Library/Audio/UISounds/nano/call_waiting_tone_cept.caf
/System/Library/Audio/UISounds/nano/ct-call-waiting.caf
/System/Library/Audio/UISounds/nano/dtmf-0.caf
/System/Library/Audio/UISounds/nano/dtmf-1.caf
/System/Library/Audio/UISounds/nano/dtmf-2.caf
/System/Library/Audio/UISounds/nano/dtmf-3.caf
/System/Library/Audio/UISounds/nano/dtmf-4.caf
/System/Library/Audio/UISounds/nano/dtmf-5.caf
/System/Library/Audio/UISounds/nano/dtmf-6.caf
/System/Library/Audio/UISounds/nano/dtmf-7.caf
/System/Library/Audio/UISounds/nano/dtmf-8.caf
/System/Library/Audio/UISounds/nano/dtmf-9.caf
/System/Library/Audio/UISounds/nano/dtmf-pound.caf
/System/Library/Audio/UISounds/nano/dtmf-star.caf
/System/Library/Audio/UISounds/nano/end_call_tone_cept.caf
/System/Library/Audio/UISounds/nano/jbl_begin.caf
/System/Library/Audio/UISounds/nano/jbl_begin_short.caf
/System/Library/Audio/UISounds/nano/jbl_cancel.caf
/System/Library/Audio/UISounds/nano/jbl_confirm.caf
/System/Library/Audio/UISounds/nano/ringback_tone_ansi.caf
/System/Library/Audio/UISounds/nano/ringback_tone_aus.caf
/System/Library/Audio/UISounds/nano/ringback_tone_cept.caf
/System/Library/Audio/UISounds/nano/ringback_tone_hk.caf
/System/Library/Audio/UISounds/nano/ringback_tone_uk.caf
/System/Library/Audio/UISounds/nano/sms-received1.caf
/System/Library/Audio/UISounds/nano/vc~ended.caf
/System/Library/Audio/UISounds/nano/vc~invitation-accepted.caf
/System/Library/Audio/UISounds/nano/vc~ringing.caf
/System/Library/Audio/UISounds/nano/vc~ringing_watch.caf
/System/Library/Audio/UISounds/navigation_pop.caf
/System/Library/Audio/UISounds/navigation_push.caf
/System/Library/Audio/UISounds/new-mail.caf
/System/Library/Audio/UISounds/nfc_scan_complete.caf
/System/Library/Audio/UISounds/nfc_scan_failure.caf
/System/Library/Audio/UISounds/payment_failure.caf
/System/Library/Audio/UISounds/payment_success.caf
/System/Library/Audio/UISounds/photoShutter.caf
/System/Library/Audio/UISounds/shake.caf
/System/Library/Audio/UISounds/short_double_high.caf
/System/Library/Audio/UISounds/short_double_low.caf
/System/Library/Audio/UISounds/short_low_high.caf
/System/Library/Audio/UISounds/sms-received1.caf
/System/Library/Audio/UISounds/sms-received2.caf
/System/Library/Audio/UISounds/sms-received3.caf
/System/Library/Audio/UISounds/sms-received4.caf
/System/Library/Audio/UISounds/sms-received5.caf
/System/Library/Audio/UISounds/sms-received6.caf
/System/Library/Audio/UISounds/tweet_sent.caf
/System/Library/Audio/UISounds/ussd.caf
/System/Library/Audio/UISounds/warsaw.caf
/System/Library/Audio/UISounds/wheels_of_time.caf
```

## List of all system audio files in iOS 27

341 files, from a filesystem dump of iOS 27 (September 2026; SystemSoundIDs for iOS 27 are not mapped yet). Source: <https://3.onj.me/phonetones/unzipped/Apple/iOS-27/System/Library/Audio/UISounds/>, also in [`data/uisounds/ios-27.txt`](data/uisounds/ios-27.txt).

```text
/System/Library/Audio/UISounds/3rd_party_critical.caf
/System/Library/Audio/UISounds/DeviceShutdown.caf
/System/Library/Audio/UISounds/Doorbell.caf
/System/Library/Audio/UISounds/DualBudLongPressFailure.caf
/System/Library/Audio/UISounds/EarInteraction_Complete.caf
/System/Library/Audio/UISounds/GymKitConnected.caf
/System/Library/Audio/UISounds/GymKitConnecting.caf
/System/Library/Audio/UISounds/GymKitDisconnected.caf
/System/Library/Audio/UISounds/LiquidDetected.caf
/System/Library/Audio/UISounds/LiveTranslationStart.caf
/System/Library/Audio/UISounds/LiveTranslationStop.caf
/System/Library/Audio/UISounds/Modern/airdrop_invite.caf
/System/Library/Audio/UISounds/Modern/camera_shutter_burst.caf
/System/Library/Audio/UISounds/Modern/camera_shutter_burst_begin.caf
/System/Library/Audio/UISounds/Modern/camera_shutter_burst_end.caf
/System/Library/Audio/UISounds/NFCCardComplete.caf
/System/Library/Audio/UISounds/NFCCardError.caf
/System/Library/Audio/UISounds/NFCCardProvisioned.caf
/System/Library/Audio/UISounds/NavigationGenericManeuver.caf
/System/Library/Audio/UISounds/New/Anticipate.caf
/System/Library/Audio/UISounds/New/Bloom.caf
/System/Library/Audio/UISounds/New/Calypso.caf
/System/Library/Audio/UISounds/New/Choo_Choo.caf
/System/Library/Audio/UISounds/New/Descent.caf
/System/Library/Audio/UISounds/New/Fanfare.caf
/System/Library/Audio/UISounds/New/Ladder.caf
/System/Library/Audio/UISounds/New/Minuet.caf
/System/Library/Audio/UISounds/New/News_Flash.caf
/System/Library/Audio/UISounds/New/Noir.caf
/System/Library/Audio/UISounds/New/Sherwood_Forest.caf
/System/Library/Audio/UISounds/New/Spell.caf
/System/Library/Audio/UISounds/New/Suspense.caf
/System/Library/Audio/UISounds/New/Telegraph.caf
/System/Library/Audio/UISounds/New/Tiptoes.caf
/System/Library/Audio/UISounds/New/Typewriters.caf
/System/Library/Audio/UISounds/New/Update.caf
/System/Library/Audio/UISounds/PINDelete.caf
/System/Library/Audio/UISounds/PINDelete_AX.caf
/System/Library/Audio/UISounds/PINEnterDigit.caf
/System/Library/Audio/UISounds/PINEnterDigit_AX.caf
/System/Library/Audio/UISounds/PINSubmit_AX.caf
/System/Library/Audio/UISounds/PINUnexpected.caf
/System/Library/Audio/UISounds/PaymentReceived.caf
/System/Library/Audio/UISounds/PaymentReceivedFailure.caf
/System/Library/Audio/UISounds/ReceivedMessage.caf
/System/Library/Audio/UISounds/RemoteAttentionRequest_Alert.caf
/System/Library/Audio/UISounds/RingerChanged.caf
/System/Library/Audio/UISounds/SIMToolkitCallDropped.caf
/System/Library/Audio/UISounds/SIMToolkitGeneralBeep.caf
/System/Library/Audio/UISounds/SIMToolkitNegativeACK.caf
/System/Library/Audio/UISounds/SIMToolkitPositiveACK.caf
/System/Library/Audio/UISounds/SIMToolkitSMS.caf
/System/Library/Audio/UISounds/SentMessage.caf
/System/Library/Audio/UISounds/Swish.caf
/System/Library/Audio/UISounds/Tink.caf
/System/Library/Audio/UISounds/Tock.caf
/System/Library/Audio/UISounds/WebcamStart.caf
/System/Library/Audio/UISounds/access_scan_complete.caf
/System/Library/Audio/UISounds/acknowledgment_received.caf
/System/Library/Audio/UISounds/acknowledgment_sent.caf
/System/Library/Audio/UISounds/alarm.caf
/System/Library/Audio/UISounds/begin_record.caf
/System/Library/Audio/UISounds/camera_timer_countdown.caf
/System/Library/Audio/UISounds/camera_timer_final_second.caf
/System/Library/Audio/UISounds/connect_power.caf
/System/Library/Audio/UISounds/ct-busy.caf
/System/Library/Audio/UISounds/ct-congestion.caf
/System/Library/Audio/UISounds/ct-error.caf
/System/Library/Audio/UISounds/ct-keytone2.caf
/System/Library/Audio/UISounds/ct-path-ack.caf
/System/Library/Audio/UISounds/end_record.caf
/System/Library/Audio/UISounds/focus_change_app_icon.caf
/System/Library/Audio/UISounds/focus_change_keyboard.caf
/System/Library/Audio/UISounds/focus_change_large.caf
/System/Library/Audio/UISounds/focus_change_small.caf
/System/Library/Audio/UISounds/go_to_sleep_alert.caf
/System/Library/Audio/UISounds/health_notification.caf
/System/Library/Audio/UISounds/jbl_ambiguous.caf
/System/Library/Audio/UISounds/jbl_begin.caf
/System/Library/Audio/UISounds/jbl_begin_short.caf
/System/Library/Audio/UISounds/jbl_begin_short_carplay.caf
/System/Library/Audio/UISounds/jbl_cancel.caf
/System/Library/Audio/UISounds/jbl_confirm.caf
/System/Library/Audio/UISounds/jbl_no_match.caf
/System/Library/Audio/UISounds/key_press_click.caf
/System/Library/Audio/UISounds/key_press_delete.caf
/System/Library/Audio/UISounds/key_press_modifier.caf
/System/Library/Audio/UISounds/keyboard_press_clear.caf
/System/Library/Audio/UISounds/keyboard_press_delete.caf
/System/Library/Audio/UISounds/keyboard_press_normal.caf
/System/Library/Audio/UISounds/lock.caf
/System/Library/Audio/UISounds/long_low_short_high.caf
/System/Library/Audio/UISounds/low_power.caf
/System/Library/Audio/UISounds/mail-sent.caf
/System/Library/Audio/UISounds/middle_9_short_double_low.caf
/System/Library/Audio/UISounds/multiway_invitation.caf
/System/Library/Audio/UISounds/nano/3rdParty_DirectionDown_Haptic.caf
/System/Library/Audio/UISounds/nano/3rdParty_DirectionUp_Haptic.caf
/System/Library/Audio/UISounds/nano/3rdParty_Failure_Haptic.caf
/System/Library/Audio/UISounds/nano/3rdParty_Retry_Haptic.caf
/System/Library/Audio/UISounds/nano/3rdParty_Start_Haptic.caf
/System/Library/Audio/UISounds/nano/3rdParty_Stop_Haptic.caf
/System/Library/Audio/UISounds/nano/3rdParty_Success_Haptic.caf
/System/Library/Audio/UISounds/nano/3rd_Party_Critical_Haptic.caf
/System/Library/Audio/UISounds/nano/AccessScanComplete_Haptic.caf
/System/Library/Audio/UISounds/nano/Alarm_Haptic.caf
/System/Library/Audio/UISounds/nano/Alarm_Nightstand_Haptic.caf
/System/Library/Audio/UISounds/nano/Alert_1stParty_Haptic.caf
/System/Library/Audio/UISounds/nano/Alert_3rdParty_Haptic.caf
/System/Library/Audio/UISounds/nano/Alert_3rdParty_Salient_Haptic.caf
/System/Library/Audio/UISounds/nano/Alert_ActivityFriendsGoalAttained_Haptic.caf
/System/Library/Audio/UISounds/nano/Alert_ActivityGoalAttained_Haptic.caf
/System/Library/Audio/UISounds/nano/Alert_ActivityGoalAttained_Salient_Haptic.caf
/System/Library/Audio/UISounds/nano/Alert_ActivityGoalBehind_Haptic.caf
/System/Library/Audio/UISounds/nano/Alert_ActivityGoalBehind_Salient_Haptic.caf
/System/Library/Audio/UISounds/nano/Alert_ActivityGoalClose_Haptic.caf
/System/Library/Audio/UISounds/nano/Alert_BatteryLow_10p_Haptic.caf
/System/Library/Audio/UISounds/nano/Alert_BatteryLow_5p_Haptic.caf
/System/Library/Audio/UISounds/nano/Alert_BatteryLow_5p_Salient_Haptic.caf
/System/Library/Audio/UISounds/nano/Alert_Calendar_Haptic.caf
/System/Library/Audio/UISounds/nano/Alert_Calendar_Salient_Haptic.caf
/System/Library/Audio/UISounds/nano/Alert_Health_Haptic.caf
/System/Library/Audio/UISounds/nano/Alert_MapsDirectionsInApp_Haptic.caf
/System/Library/Audio/UISounds/nano/Alert_PassbookBalance_Haptic.caf
/System/Library/Audio/UISounds/nano/Alert_PassbookGeofence_Haptic.caf
/System/Library/Audio/UISounds/nano/Alert_PassbookGeofence_Salient_Haptic.caf
/System/Library/Audio/UISounds/nano/Alert_PhotostreamActivity_Haptic.caf
/System/Library/Audio/UISounds/nano/Alert_ReminderDue_Haptic.caf
/System/Library/Audio/UISounds/nano/Alert_ReminderDue_Salient_Haptic.caf
/System/Library/Audio/UISounds/nano/Alert_SpartanConnected_LowLatency_Haptic.caf
/System/Library/Audio/UISounds/nano/Alert_SpartanConnecting_Haptic.caf
/System/Library/Audio/UISounds/nano/Alert_SpartanConnecting_LowLatency_Haptic.caf
/System/Library/Audio/UISounds/nano/Alert_SpartanDisconnected_LowLatency_Haptic.caf
/System/Library/Audio/UISounds/nano/Alert_Voicemail_Haptic.caf
/System/Library/Audio/UISounds/nano/Alert_Voicemail_Salient_Haptic.caf
/System/Library/Audio/UISounds/nano/Alert_WalkieTalkie_Haptic.caf
/System/Library/Audio/UISounds/nano/AutoUnlock_Haptic.caf
/System/Library/Audio/UISounds/nano/BatteryMagsafe_Haptic.caf
/System/Library/Audio/UISounds/nano/Beat_Haptic.caf
/System/Library/Audio/UISounds/nano/BuddyMigrationStart_Haptic.caf
/System/Library/Audio/UISounds/nano/BuddyPairingFailure_Haptic.caf
/System/Library/Audio/UISounds/nano/BuddyPairingRemoteConnection_Haptic.caf
/System/Library/Audio/UISounds/nano/BuddyPairingRemoteTap_Haptic.caf
/System/Library/Audio/UISounds/nano/BuddyPairingSuccess_Haptic.caf
/System/Library/Audio/UISounds/nano/CameraCountdownImminent_Haptic.caf
/System/Library/Audio/UISounds/nano/CameraCountdownTick_Haptic.caf
/System/Library/Audio/UISounds/nano/CameraShutter_Haptic.caf
/System/Library/Audio/UISounds/nano/Detent_Haptic.caf
/System/Library/Audio/UISounds/nano/DoNotDisturb_Haptic.caf
/System/Library/Audio/UISounds/nano/Doorbell_Haptic.caf
/System/Library/Audio/UISounds/nano/ET_BeginNotification_Haptic.caf
/System/Library/Audio/UISounds/nano/ET_BeginNotification_Salient_Haptic.caf
/System/Library/Audio/UISounds/nano/ET_RemoteTap_Receive_Haptic.caf
/System/Library/Audio/UISounds/nano/ET_RemoteTap_Send_Haptic.caf
/System/Library/Audio/UISounds/nano/Elevation.caf
/System/Library/Audio/UISounds/nano/GoToSleep_Haptic.caf
/System/Library/Audio/UISounds/nano/HeadGesturesDoubleNod.caf
/System/Library/Audio/UISounds/nano/HeadGesturesDoubleShake.caf
/System/Library/Audio/UISounds/nano/HeadGesturesPartialNod.caf
/System/Library/Audio/UISounds/nano/HeadGesturesPartialShake.caf
/System/Library/Audio/UISounds/nano/HeadphoneAudioExposureLimitExceeded.caf
/System/Library/Audio/UISounds/nano/HealthNotificationUrgent.caf
/System/Library/Audio/UISounds/nano/HealthReadingComplete_Haptic.caf
/System/Library/Audio/UISounds/nano/HealthReadingFail_Haptic.caf
/System/Library/Audio/UISounds/nano/HourlyChime_Haptic.caf
/System/Library/Audio/UISounds/nano/HummingbirdCompletion_Haptic.caf
/System/Library/Audio/UISounds/nano/HummingbirdNotification_Haptic.caf
/System/Library/Audio/UISounds/nano/IntervalEnded.caf
/System/Library/Audio/UISounds/nano/IntervalUpcoming.caf
/System/Library/Audio/UISounds/nano/MediaHandoff.caf
/System/Library/Audio/UISounds/nano/MediaPaused.caf
/System/Library/Audio/UISounds/nano/MessagesIncoming_Haptic.caf
/System/Library/Audio/UISounds/nano/MessagesOutgoing_Haptic.caf
/System/Library/Audio/UISounds/nano/MicMute.caf
/System/Library/Audio/UISounds/nano/MicUnmute.caf
/System/Library/Audio/UISounds/nano/MicUnmuteFail.caf
/System/Library/Audio/UISounds/nano/MultiwayInvitation.caf
/System/Library/Audio/UISounds/nano/MultiwayJoin.caf
/System/Library/Audio/UISounds/nano/MultiwayLeave.caf
/System/Library/Audio/UISounds/nano/NanoAlert10.caf
/System/Library/Audio/UISounds/nano/NanoAlert10_Prominent.caf
/System/Library/Audio/UISounds/nano/NanoAlert2.caf
/System/Library/Audio/UISounds/nano/NanoAlert2_Prominent.caf
/System/Library/Audio/UISounds/nano/NanoAlert3.caf
/System/Library/Audio/UISounds/nano/NanoAlert3_Prominent.caf
/System/Library/Audio/UISounds/nano/NanoAlert4.caf
/System/Library/Audio/UISounds/nano/NanoAlert4_Promiment.caf
/System/Library/Audio/UISounds/nano/NanoAlert5.caf
/System/Library/Audio/UISounds/nano/NanoAlert5_Prominent.caf
/System/Library/Audio/UISounds/nano/NanoAlert6.caf
/System/Library/Audio/UISounds/nano/NanoAlert6_Prominent.caf
/System/Library/Audio/UISounds/nano/NanoRingtone3.caf
/System/Library/Audio/UISounds/nano/NanoRingtone4.caf
/System/Library/Audio/UISounds/nano/NanoRingtone6.caf
/System/Library/Audio/UISounds/nano/NavigationGenericManeuver_Haptic.caf
/System/Library/Audio/UISounds/nano/NavigationGenericManeuver_Salient_Haptic.caf
/System/Library/Audio/UISounds/nano/NavigationLeftTurn_Haptic.caf
/System/Library/Audio/UISounds/nano/NavigationLeftTurn_Salient_Haptic.caf
/System/Library/Audio/UISounds/nano/NavigationRightTurn_Haptic.caf
/System/Library/Audio/UISounds/nano/NavigationRightTurn_Salient_Haptic.caf
/System/Library/Audio/UISounds/nano/Notification_Haptic.caf
/System/Library/Audio/UISounds/nano/Notification_Salient_Haptic.caf
/System/Library/Audio/UISounds/nano/OnOffPasscodeFailure_Haptic.caf
/System/Library/Audio/UISounds/nano/OnOffPasscodeUnlockCampanion_Haptic.caf
/System/Library/Audio/UISounds/nano/OnOffPasscodeUnlock_Haptic.caf
/System/Library/Audio/UISounds/nano/OrbExit_Haptic.caf
/System/Library/Audio/UISounds/nano/OrbLayers_Haptic.caf
/System/Library/Audio/UISounds/nano/PhoneAnswer_Haptic.caf
/System/Library/Audio/UISounds/nano/PhoneHangUp_Haptic.caf
/System/Library/Audio/UISounds/nano/PhoneHold_Haptic.caf
/System/Library/Audio/UISounds/nano/PhotosZoomDetent_Haptic.caf
/System/Library/Audio/UISounds/nano/Preview_AudioAndHaptic.caf
/System/Library/Audio/UISounds/nano/PushToTalkJoined.caf
/System/Library/Audio/UISounds/nano/PushToTalkLeft.caf
/System/Library/Audio/UISounds/nano/PushToTalkMute.caf
/System/Library/Audio/UISounds/nano/PushToTalkUnmute.caf
/System/Library/Audio/UISounds/nano/PushToTalkUnmuteFail.caf
/System/Library/Audio/UISounds/nano/QB_Dictation_Haptic.caf
/System/Library/Audio/UISounds/nano/QB_Dictation_Off_Haptic.caf
/System/Library/Audio/UISounds/nano/ReceiverConfirmation.caf
/System/Library/Audio/UISounds/nano/ReceiverConnect.caf
/System/Library/Audio/UISounds/nano/RegattaTimer.caf
/System/Library/Audio/UISounds/nano/RemoteCameraShutterBurstBegin_Haptic.caf
/System/Library/Audio/UISounds/nano/RemoteCameraShutterBurstEnd_Haptic.caf
/System/Library/Audio/UISounds/nano/RingtoneDucked_UK_Haptic.caf
/System/Library/Audio/UISounds/nano/RingtoneDucked_US_Haptic.caf
/System/Library/Audio/UISounds/nano/Ringtone_2_Ducked_Haptic-sashimi.caf
/System/Library/Audio/UISounds/nano/Ringtone_2_Haptic-sashimi.caf
/System/Library/Audio/UISounds/nano/Ringtone_UK_Haptic.caf
/System/Library/Audio/UISounds/nano/Ringtone_US_Haptic.caf
/System/Library/Audio/UISounds/nano/SOSEmergencyContactTextPrompt_Haptic.caf
/System/Library/Audio/UISounds/nano/SOSFallDetectionPromptEscalation_Haptic.caf
/System/Library/Audio/UISounds/nano/SOSFallDetectionPrompt_Haptic.caf
/System/Library/Audio/UISounds/nano/SalientNotification_Haptic.caf
/System/Library/Audio/UISounds/nano/SatelliteMessageSent.caf
/System/Library/Audio/UISounds/nano/ScreenCapture.caf
/System/Library/Audio/UISounds/nano/ScreenSharingStarted.caf
/System/Library/Audio/UISounds/nano/SedentaryTimer_Haptic.caf
/System/Library/Audio/UISounds/nano/SedentaryTimer_Salient_Haptic.caf
/System/Library/Audio/UISounds/nano/SenderConfirmation.caf
/System/Library/Audio/UISounds/nano/Siren_Countdown_Major_Haptic.caf
/System/Library/Audio/UISounds/nano/Siren_Countdown_Minor_Haptic.caf
/System/Library/Audio/UISounds/nano/SiriAutoSend_Haptic.caf
/System/Library/Audio/UISounds/nano/SiriStart_Haptic.caf
/System/Library/Audio/UISounds/nano/SiriStopFailure_Haptic.caf
/System/Library/Audio/UISounds/nano/SiriStopSuccess_Haptic.caf
/System/Library/Audio/UISounds/nano/StockholmActiveSingleCycle_Haptic.caf
/System/Library/Audio/UISounds/nano/StockholmActive_Haptic.caf
/System/Library/Audio/UISounds/nano/StockholmFailure_Haptic.caf
/System/Library/Audio/UISounds/nano/Stockholm_Haptic.caf
/System/Library/Audio/UISounds/nano/StopwatchLap_Haptic.caf
/System/Library/Audio/UISounds/nano/StopwatchReset_Haptic.caf
/System/Library/Audio/UISounds/nano/StopwatchStart_Haptic.caf
/System/Library/Audio/UISounds/nano/StopwatchStop_Haptic.caf
/System/Library/Audio/UISounds/nano/SystemStartup_Haptic.caf
/System/Library/Audio/UISounds/nano/System_Notification_Haptic.caf
/System/Library/Audio/UISounds/nano/TimerCancel_Haptic.caf
/System/Library/Audio/UISounds/nano/TimerPause_Haptic.caf
/System/Library/Audio/UISounds/nano/TimerStart_Haptic.caf
/System/Library/Audio/UISounds/nano/TimerWheelHoursDetent_Haptic.caf
/System/Library/Audio/UISounds/nano/TimerWheelMinutesDetent_Haptic.caf
/System/Library/Audio/UISounds/nano/Timer_Haptic.caf
/System/Library/Audio/UISounds/nano/UISwipe_Haptic.caf
/System/Library/Audio/UISounds/nano/UISwitch_Off_Haptic.caf
/System/Library/Audio/UISounds/nano/UISwitch_On_Haptic.caf
/System/Library/Audio/UISounds/nano/VoiceOver_Click_Haptic.caf
/System/Library/Audio/UISounds/nano/WalkAMile_Haptic.caf
/System/Library/Audio/UISounds/nano/WalkieTalkieActiveEnd_Haptic.caf
/System/Library/Audio/UISounds/nano/WalkieTalkieActiveStart_Haptic.caf
/System/Library/Audio/UISounds/nano/WalkieTalkieReceiveEnd_Haptic.caf
/System/Library/Audio/UISounds/nano/WalkieTalkieReceiveStart_Haptic.caf
/System/Library/Audio/UISounds/nano/Warsaw_Haptic.caf
/System/Library/Audio/UISounds/nano/WorkoutCompleteAutodetect.caf
/System/Library/Audio/UISounds/nano/WorkoutComplete_Haptic.caf
/System/Library/Audio/UISounds/nano/WorkoutCountdown_Haptic.caf
/System/Library/Audio/UISounds/nano/WorkoutPaceAbove.caf
/System/Library/Audio/UISounds/nano/WorkoutPaceBelow.caf
/System/Library/Audio/UISounds/nano/WorkoutPausedAutoDetect.caf
/System/Library/Audio/UISounds/nano/WorkoutPaused_Haptic.caf
/System/Library/Audio/UISounds/nano/WorkoutPrecisionStart_Haptic.caf
/System/Library/Audio/UISounds/nano/WorkoutPressStart_Haptic.caf
/System/Library/Audio/UISounds/nano/WorkoutResumedAutoDetect.caf
/System/Library/Audio/UISounds/nano/WorkoutResumed_Haptic.caf
/System/Library/Audio/UISounds/nano/WorkoutSaved_Haptic.caf
/System/Library/Audio/UISounds/nano/WorkoutSelect_Haptic.caf
/System/Library/Audio/UISounds/nano/WorkoutStartAutodetect.caf
/System/Library/Audio/UISounds/nano/busy_tone_ansi.caf
/System/Library/Audio/UISounds/nano/busy_tone_cept.caf
/System/Library/Audio/UISounds/nano/call_waiting_tone_ansi.caf
/System/Library/Audio/UISounds/nano/call_waiting_tone_cept.caf
/System/Library/Audio/UISounds/nano/call_waiting_tone_low_priority.caf
/System/Library/Audio/UISounds/nano/ct-call-waiting.caf
/System/Library/Audio/UISounds/nano/dtmf-0.caf
/System/Library/Audio/UISounds/nano/dtmf-1.caf
/System/Library/Audio/UISounds/nano/dtmf-2.caf
/System/Library/Audio/UISounds/nano/dtmf-3.caf
/System/Library/Audio/UISounds/nano/dtmf-4.caf
/System/Library/Audio/UISounds/nano/dtmf-5.caf
/System/Library/Audio/UISounds/nano/dtmf-6.caf
/System/Library/Audio/UISounds/nano/dtmf-7.caf
/System/Library/Audio/UISounds/nano/dtmf-8.caf
/System/Library/Audio/UISounds/nano/dtmf-9.caf
/System/Library/Audio/UISounds/nano/dtmf-pound.caf
/System/Library/Audio/UISounds/nano/dtmf-star.caf
/System/Library/Audio/UISounds/nano/end_call_tone_cept.caf
/System/Library/Audio/UISounds/nano/jbl_begin.caf
/System/Library/Audio/UISounds/nano/jbl_begin_short.caf
/System/Library/Audio/UISounds/nano/jbl_cancel.caf
/System/Library/Audio/UISounds/nano/jbl_confirm.caf
/System/Library/Audio/UISounds/nano/ringback_tone_ansi.caf
/System/Library/Audio/UISounds/nano/ringback_tone_aus.caf
/System/Library/Audio/UISounds/nano/ringback_tone_cept.caf
/System/Library/Audio/UISounds/nano/ringback_tone_hk.caf
/System/Library/Audio/UISounds/nano/ringback_tone_uk.caf
/System/Library/Audio/UISounds/nano/sms-received1.caf
/System/Library/Audio/UISounds/nano/vc~ended.caf
/System/Library/Audio/UISounds/nano/vc~invitation-accepted.caf
/System/Library/Audio/UISounds/nano/vc~ringing.caf
/System/Library/Audio/UISounds/nano/vc~ringing_watch.caf
/System/Library/Audio/UISounds/navigation_pop.caf
/System/Library/Audio/UISounds/navigation_push.caf
/System/Library/Audio/UISounds/new-mail.caf
/System/Library/Audio/UISounds/nfc_scan_complete.caf
/System/Library/Audio/UISounds/nfc_scan_failure.caf
/System/Library/Audio/UISounds/payment_failure.caf
/System/Library/Audio/UISounds/payment_success.caf
/System/Library/Audio/UISounds/photoShutter.caf
/System/Library/Audio/UISounds/shake.caf
/System/Library/Audio/UISounds/short_double_high.caf
/System/Library/Audio/UISounds/short_double_low.caf
/System/Library/Audio/UISounds/short_low_high.caf
/System/Library/Audio/UISounds/sms-received1.caf
/System/Library/Audio/UISounds/sms-received2.caf
/System/Library/Audio/UISounds/sms-received3.caf
/System/Library/Audio/UISounds/sms-received4.caf
/System/Library/Audio/UISounds/sms-received5.caf
/System/Library/Audio/UISounds/sms-received6.caf
/System/Library/Audio/UISounds/tweet_sent.caf
/System/Library/Audio/UISounds/ussd.caf
/System/Library/Audio/UISounds/warsaw.caf
/System/Library/Audio/UISounds/wheels_of_time.caf
```

## Changes since iOS 7

Differences between the original iOS 7 data above (left unchanged) and recent iOS versions. Sources: [p-x9](https://github.com/p-x9/swift-system-sound/blob/e3f44c2d5766b0a7c3cdaacd4d61b5e1c8804794/SystemSoundTable.md) and the iOS 17–27 file lists in [`data/uisounds/`](data/uisounds/).

### File mapping differs

| SystemSoundID | iOS 7 file | Current file | Note |
| --- | --- | --- | --- |
| 1002 | Voicemail.caf | /System/Library/Audio/UISounds/nano/sms-received1.caf | iOS 7 file no longer exists |
| 1015 | Voicemail.caf | /System/Library/Audio/UISounds/nano/sms-received1.caf | iOS 7 file no longer exists |
| 1104 | Tock.caf | /System/Library/Audio/UISounds/key_press_click.caf | both files exist; verify on device |
| 1106 | beep-beep.caf | /System/Library/Audio/UISounds/connect_power.caf | iOS 7 file no longer exists |
| 1117 | begin_video_record.caf | /System/Library/Audio/UISounds/begin_record.caf | iOS 7 file no longer exists |
| 1118 | end_video_record.caf | /System/Library/Audio/UISounds/end_record.caf | iOS 7 file no longer exists |
| 1300 | Voicemail.caf | /System/Library/Audio/UISounds/nano/sms-received1.caf | iOS 7 file no longer exists |
| 1306 | Tock.caf | /System/Library/Audio/UISounds/key_press_click.caf | both files exist; verify on device |
| 1315 | Voicemail.caf | /System/Library/Audio/UISounds/nano/sms-received1.caf | iOS 7 file no longer exists |

### Category differs

| SystemSoundID | File name | iOS 7 category | Current category |
| --- | --- | --- | --- |
| 1016 | tweet_sent.caf | SMSSent | MailSent |
| 1301 | ReceivedMessage.caf | SystemSoundPreview | SystemSoundPreview_IgnoreRingerSwitch |
| 1302 | new-mail.caf | SystemSoundPreview | SystemSoundPreview_IgnoreRingerSwitch |
| 1303 | mail-sent.caf | SystemSoundPreview | SystemSoundPreview_IgnoreRingerSwitch |
| 1304 | alarm.caf | SystemSoundPreview | SystemSoundPreview_IgnoreRingerSwitch |

### IDs no longer listed

| SystemSoundID | iOS 7 file | iOS 7 category | Note |
| --- | --- | --- | --- |
| 1101 | unlock.caf | ScreenUnlocked | not listed by p-x9, file not in the iOS 17–27 file lists |

### Files moved

16 files from the iOS 7.0.2 list now live in a different folder (matched by file name).

| iOS 7.0.2 path | Path on iOS 17–27 |
| --- | --- |
| /System/Library/Audio/UISounds/ct-call-waiting.caf | /System/Library/Audio/UISounds/nano/ct-call-waiting.caf |
| /System/Library/Audio/UISounds/dtmf-0.caf | /System/Library/Audio/UISounds/nano/dtmf-0.caf |
| /System/Library/Audio/UISounds/dtmf-1.caf | /System/Library/Audio/UISounds/nano/dtmf-1.caf |
| /System/Library/Audio/UISounds/dtmf-2.caf | /System/Library/Audio/UISounds/nano/dtmf-2.caf |
| /System/Library/Audio/UISounds/dtmf-3.caf | /System/Library/Audio/UISounds/nano/dtmf-3.caf |
| /System/Library/Audio/UISounds/dtmf-4.caf | /System/Library/Audio/UISounds/nano/dtmf-4.caf |
| /System/Library/Audio/UISounds/dtmf-5.caf | /System/Library/Audio/UISounds/nano/dtmf-5.caf |
| /System/Library/Audio/UISounds/dtmf-6.caf | /System/Library/Audio/UISounds/nano/dtmf-6.caf |
| /System/Library/Audio/UISounds/dtmf-7.caf | /System/Library/Audio/UISounds/nano/dtmf-7.caf |
| /System/Library/Audio/UISounds/dtmf-8.caf | /System/Library/Audio/UISounds/nano/dtmf-8.caf |
| /System/Library/Audio/UISounds/dtmf-9.caf | /System/Library/Audio/UISounds/nano/dtmf-9.caf |
| /System/Library/Audio/UISounds/dtmf-pound.caf | /System/Library/Audio/UISounds/nano/dtmf-pound.caf |
| /System/Library/Audio/UISounds/dtmf-star.caf | /System/Library/Audio/UISounds/nano/dtmf-star.caf |
| /System/Library/Audio/UISounds/vc\~ended.caf | /System/Library/Audio/UISounds/nano/vc\~ended.caf |
| /System/Library/Audio/UISounds/vc\~invitation-accepted.caf | /System/Library/Audio/UISounds/nano/vc\~invitation-accepted.caf |
| /System/Library/Audio/UISounds/vc\~ringing.caf | /System/Library/Audio/UISounds/nano/vc\~ringing.caf |

### Files removed

20 files from the iOS 7.0.2 list are not in any of the iOS 17–27 file lists.

```text
/System/Library/Audio/UISounds/Modern/calendar_alert_chord.caf
/System/Library/Audio/UISounds/Modern/sms_alert_aurora.caf
/System/Library/Audio/UISounds/Modern/sms_alert_bamboo.caf
/System/Library/Audio/UISounds/Modern/sms_alert_circles.caf
/System/Library/Audio/UISounds/Modern/sms_alert_complete.caf
/System/Library/Audio/UISounds/Modern/sms_alert_hello.caf
/System/Library/Audio/UISounds/Modern/sms_alert_input.caf
/System/Library/Audio/UISounds/Modern/sms_alert_keys.caf
/System/Library/Audio/UISounds/Modern/sms_alert_note.caf
/System/Library/Audio/UISounds/Modern/sms_alert_popcorn.caf
/System/Library/Audio/UISounds/Modern/sms_alert_synth.caf
/System/Library/Audio/UISounds/Voicemail.caf
/System/Library/Audio/UISounds/beep-beep.caf
/System/Library/Audio/UISounds/begin_video_record.caf
/System/Library/Audio/UISounds/end_video_record.caf
/System/Library/Audio/UISounds/sq_alarm.caf
/System/Library/Audio/UISounds/sq_beep-beep.caf
/System/Library/Audio/UISounds/sq_lock.caf
/System/Library/Audio/UISounds/sq_tock.caf
/System/Library/Audio/UISounds/unlock.caf
```

<!-- END GENERATED -->

## FAQ

### Why don't the sounds follow the volume buttons / media volume?

System sounds play at the **ringer/alert volume**, not the media volume. If you need playback that follows the media volume (and the usual audio session rules), bundle the sound and play it with `AVAudioPlayer`. See [#1](https://github.com/TUNER88/iOSSystemSoundsLibrary/issues/1).

### Why can't I hear anything in the Simulator? What is the `MGIsDeviceOneOfType is not supported on this platform` log?

The iOS Simulator does not play system sounds, so run the demo on a real device. The `MGIsDeviceOneOfType` message is harmless Simulator log noise. See [#11](https://github.com/TUNER88/iOSSystemSoundsLibrary/issues/11).

### Can I use the SystemSoundID returned by `AudioServicesCreateSystemSoundID`?

Only within the current run of your app. IDs created by `AudioServicesCreateSystemSoundID` are generated at runtime and are **not stable**, so don't store or hard-code them. Use the predefined IDs in the table above or a file URL instead. See [#9](https://github.com/TUNER88/iOSSystemSoundsLibrary/pull/9).

## Compatibility notes

Things to know when you use system sounds on current Apple platforms (iOS 17 and later).

### Volume on iOS 27

System sounds follow the ringer/alert volume, not the media volume (see the [FAQ](#faq)). According to press reports, iOS 27 adds separate volume settings for ringtones, alarms, timers, and alerts and system sounds ([The Verge](https://www.theverge.com/news/992408/ios-27-release-date-features)). We haven't verified yet how this affects `AudioServicesPlaySystemSound`, so test on a device. If your sound needs to follow the media volume, bundle it and play it with [`AVAudioPlayer`](https://developer.apple.com/documentation/avfaudio/avaudioplayer).

### watchOS

System Sound Services (`AudioServicesPlaySystemSound` and friends) is not available on watchOS. Use [`WKInterfaceDevice.play(_:)`](<https://developer.apple.com/documentation/watchkit/wkinterfacedevice/play(_:)>) for haptic feedback on Apple Watch. `AudioServicesPlaySystemSound` is available on iOS, iPadOS, Mac Catalyst, macOS, tvOS and visionOS ([docs](<https://developer.apple.com/documentation/audiotoolbox/audioservicesplaysystemsound(_:)>)), but the IDs and files in this list are iOS-specific.

### Haptics instead of vibration IDs

For tactile feedback, prefer the haptics APIs over `kSystemSoundID_Vibrate` or vibration IDs:

- [`UIFeedbackGenerator`](https://developer.apple.com/documentation/uikit/uifeedbackgenerator) subclasses (impact, selection, notification, canvas) in UIKit
- [Core Haptics](https://developer.apple.com/documentation/corehaptics) for custom haptic and audio patterns
- [`.sensoryFeedback(_:trigger:)`](<https://developer.apple.com/documentation/swiftui/view/sensoryfeedback(_:trigger:)>) in SwiftUI (iOS 17+, macOS 14+, watchOS 10+)

### Keyboard clicks

To play the standard keyboard click in a custom input view, use [`UIDevice.playInputClick()`](<https://developer.apple.com/documentation/uikit/uidevice/playinputclick()>) and adopt [`UIInputViewAudioFeedback`](https://developer.apple.com/documentation/uikit/uiinputviewaudiofeedback) instead of hard-coding IDs like 1104. The click respects the user's keyboard click setting.

### Notification sounds

These IDs and files can't be used as notification sounds. [`UNNotificationSound`](https://developer.apple.com/documentation/usernotifications/unnotificationsound) only plays files from your app bundle or your app container's `Library/Sounds` directory. Critical alerts ([`defaultCritical`](https://developer.apple.com/documentation/usernotifications/unnotificationsound/defaultcritical)) need a special entitlement from Apple.

### App Review

- `AudioServicesPlaySystemSound` and `AudioServicesPlayAlertSound` are public APIs. The numeric IDs and file names in this list are not documented by Apple, and Apple notes that system-supplied alert and UI sounds "are not available to your iOS application" ([docs](<https://developer.apple.com/documentation/audiotoolbox/audioservicesplayalertsound(_:)>)). Treat them as unofficial and test on every iOS version you support.
- [App Review Guidelines](https://developer.apple.com/app-store/review/guidelines/#software-requirements) 2.5.1 (public APIs only) and 2.5.2 (apps may not read or write data outside their container) apply. The demo app enumerates `/System/Library/Audio/UISounds`, which is fine for a developer tool. In a shipping app, prefer fixed IDs over reading system directories.

## Related projects

- [klaas/SwiftySystemSounds](https://github.com/klaas/SwiftySystemSounds): lists, plays and extracts the system sounds on iOS (Swift)
- [p-x9/swift-system-sound](https://github.com/p-x9/swift-system-sound): Swift library for system sound playback, with an extended ID table for newer iOS versions
- [dashdoc/react-native-system-sounds](https://github.com/dashdoc/react-native-system-sounds): play system sounds and beeps in React Native
- [imedboumalek/flutter_system_ringtones](https://github.com/imedboumalek/flutter_system_ringtones): Flutter plugin to list and preview system ringtones, alarms and notification sounds

## Screenshot

![screenshot](https://raw.githubusercontent.com/TUNER88/iOSSystemSoundsLibrary/readme/img/screenshot.png)

## License

Released under the MIT License. See [LICENSE](LICENSE).
