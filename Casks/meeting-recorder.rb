cask "meeting-recorder" do
  version "0.6.0"
  sha256 "542be2e88e5e30736f68354bfdcb8b37ce6a4eef26ded05e6bd015d1dc1316e2"

  url "https://github.com/chetangoel01/meeting-recorder/releases/download/v#{version}/MeetingRecorder-#{version}.dmg"
  name "Meeting Recorder"
  desc "Menu bar meeting recorder with transcription and AI notes"
  homepage "https://github.com/chetangoel01/meeting-recorder"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :sequoia

  app "Meeting Recorder.app"

  zap trash: [
    "~/Library/Application Support/Meeting Recorder",
    "~/Library/Preferences/com.chetangoel.MeetingRecorder.plist",
  ]
end
