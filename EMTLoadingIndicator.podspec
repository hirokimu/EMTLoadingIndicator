Pod::Spec.new do |s|
  s.name         = "EMTLoadingIndicator"
  s.version      = "4.0.0"
  s.summary      = "Displays loading indicator on Apple watchOS 3+"
  s.description  = <<-DESC
                   It has dot-style waiting indicator, circular indicator, and progress indicator. Makes animated images for WKInterfaceImage dynamically.
                   DESC
  s.homepage     = "https://github.com/hirokimu/EMTLoadingIndicator"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Hironobu Kimura" => "kimura@emotionale.jp" }
  s.platform     = :watchos, "3.0"
  s.watchos.deployment_target = "3.0"
  s.source       = { :git => "https://github.com/hirokimu/EMTLoadingIndicator.git", :tag => s.version }
  s.watchos.source_files = "EMTLoadingIndicator/Classes/*.swift"
  s.watchos.resources = "EMTLoadingIndicator/Resources/*.png"
  s.frameworks = "UIKit"
  s.requires_arc = true
end
