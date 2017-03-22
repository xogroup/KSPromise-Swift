Pod::Spec.new do |s|
  s.name         = "XOPromise"
  s.version      = "0.1.0"
  s.summary      = "Another promise library"

  s.description  = <<-DESC
                    A fork of Kurtis Seebaldt's KSPromise-swift library.
                   DESC

  s.homepage     = "https://github.com/xogroup/XOPromise"
  s.license      = { :type => "MIT", :file => "LICENSE.txt" }
  s.author       = "Kurtis Seebaldt"
  s.ios.deployment_target = "8.0"
  s.source       = { :git => "https://github.com/xogroup/XOPromise.git", :tag => "#{s.version}" }
  s.source_files  = "XOPromise", "XOPromise/**/*.{h,swift}"
end
