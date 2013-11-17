Pod::Spec.new do |s|
  s.name = 'BSPanViewController'
  s.version = '1.0.0'
  s.homepage = 'https://github.com/simonbs/BSPanViewController'
  s.authors = { 'Simon Støvring' => 'simon@intuitaps.d' }
  s.license = 'MIT'
  s.summary = 'A take on the sliding controllers which can optionally move the status bar along with the main view.'
  s.source = { :git => 'https://github.com/simonbs/BSPanViewController.git', :tag => '1.0.0' }
  s.source_files = 'BSPanViewController/*.{h,m}'
  s.ios.deployment_target = '7.0'
  s.requires_arc = true
end