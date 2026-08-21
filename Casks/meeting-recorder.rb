cask "meeting-recorder" do
  version "0.5.0"
  sha256 "c32872ffbd2df110965741fc3ce2691bc4ffb350bd8b1bcb32fa11c64b17e328"

  url "https://github.com/chetangoel01/meeting-recorder/releases/download/v#{version}/MeetingRecorder-#{version}.dmg"
  name "Meeting Recorder"
  desc "Menu bar meeting recorder with transcription and AI notes"
  homepage "https://github.com/chetangoel01/meeting-recorder"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :sequoia"

  app "Meeting Recorder.app"

  zap trash: [
    "~/Library/Application Support/Meeting Recorder",
    "~/Library/Preferences/com.chetangoel.MeetingRecorder.plist",
  ]
end
