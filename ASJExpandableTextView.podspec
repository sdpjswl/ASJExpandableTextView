Pod::Spec.new do |s|
  s.name         = 'ASJExpandableTextView'
  s.version      = '0.1'
  s.platform	   = :ios, '7.0'
  s.license      = { :type => 'MIT' }
  s.homepage     = 'https://github.com/sudeepjaiswal/ASJExpandableTextView'
  s.authors      = { 'Sudeep Jaiswal' => 'sudeepjaiswal87@gmail.com' }
  s.summary      = 'A UITextView with placeholder that can expand and contract according to its content'
  s.source       = { :git => 'https://github.com/sudeepjaiswal/ASJExpandableTextView.git', :tag => '0.1' }
  s.source_files = 'ASJExpandableTextView/{ASJ}*.{h,m}'
  s.resources = 'ASJExpandableTextView/*.xib'
  s.requires_arc = true
end