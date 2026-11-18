# typed: strict
# frozen_string_literal: true

cask "fleet" do
  version "0.2.2"
  sha256 "d3ea7d573d43539a8d16aafc84af959992ebaf36f072d47796aa97cb239d3fa1"

  url "https://github.com/chetangoel01/fleet/releases/download/v#{version}/Fleet-#{version}.dmg"
  name "Fleet"
  desc "Menu bar status for a few Macs, read from a small helper on each"
  homepage "https://github.com/chetangoel01/fleet"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on arch: :arm64
  depends_on macos: :sequoia

  app "Fleet.app"

  # The helper (fleetd) is a launchd job of the user's, so nothing here needs a password.
  # Install steps cannot talk to launchd, so they only write the job's file. After an upgrade
  # the running helper finds its file replaced and leaves, and launchd starts the new copy.
  postflight_steps do
    mkdir_p "Library/LaunchAgents", base: :home
    write_file "Library/LaunchAgents/com.chetangoel.fleetd.plist", <<~PLIST, base: :home
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
          <key>Label</key><string>com.chetangoel.fleetd</string>
          <key>ProgramArguments</key><array><string>{{appdir}}/Fleet.app/Contents/Helpers/fleetd</string></array>
          <key>RunAtLoad</key><true/>
          <key>KeepAlive</key><dict><key>SuccessfulExit</key><false/></dict>
          <key>ThrottleInterval</key><integer>30</integer>
          <key>ProcessType</key><string>Interactive</string>
      </dict>
      </plist>
    PLIST
  end

  uninstall_postflight_steps do
    remove "Library/LaunchAgents/com.chetangoel.fleetd.plist", base: :home
  end

  # Homebrew runs these before every upgrade too, except the signal, which it keeps for a
  # removal. fleetd leaves with 0 on an interrupt, so launchd does not start it again.
  uninstall quit:   "com.chetangoel.fleet",
            signal: ["INT", "com.chetangoel.fleetd"]

  zap trash: "~/Library/Logs/fleetd.log"

  caveats <<~EOS
    After the first install on a Mac, start the helper (logging out and in does the same):
      launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/com.chetangoel.fleetd.plist
    macOS then asks once, on that Mac's screen, whether to open Fleet, and the helper waits
    for the answer. A Mac with nobody at it needs Screen Sharing for that one click.
    Upgrades need neither step.
  EOS
end
