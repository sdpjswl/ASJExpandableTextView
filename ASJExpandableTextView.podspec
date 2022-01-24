Pod::Spec.new do |s|
  s.name          = 'ASJExpandableTextView'
  s.version       = '0.5'
  s.platform      = :ios, '9.0'
  s.license       = { :type => 'MIT' }
  s.homepage      = 'https://github.com/sdpjswl/ASJExpandableTextView'
  s.authors       = { 'Sudeep' => 'sdpjswl1@gmail.com' }
  s.summary       = 'A UITextView with placeholder that can expand and contract according to its content'
  s.source        = { :git => 'https://github.com/sdpjswl/ASJExpandableTextView.git', :tag => s.version }
  s.source_files  = 'ASJExpandableTextView/*.{h,m}'
  s.resources     = 'ASJExpandableTextView/*.{xib}'
  s.requires_arc  = true
end