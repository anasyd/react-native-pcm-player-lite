require "json"
package = JSON.parse(File.read(File.join(__dir__, "package.json")))

Pod::Spec.new do |s|
  s.name         = "react-native-pcm-player-lite"
  s.version      = package["version"]
  s.summary      = package["description"]
  s.license      = { :type => "MIT" }
  s.author       = { "Your Name" => "you@example.com" }
  s.homepage     = package["repository"]["url"]
  s.source       = { :git => package["repository"]["url"], :tag => "v#{s.version}" }
  s.platforms    = { :ios => "12.0" }
  s.source_files = "ios/**/*.{swift,m}"
  s.requires_arc = true

  s.dependency "React-Core"
end
