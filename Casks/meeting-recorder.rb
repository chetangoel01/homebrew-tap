cask "meeting-recorder" do
  version "0.6.1"
  sha256 "364a8f8077f70703f42417847a37af9bcd9d286b1f1574327b2dd8684f9a63c0"

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
