
Pod::Spec.new do |s|
  s.name             = 'sample_metalstdlib'
  s.version          = '0.1.0'
  s.summary          = 'A short description of sample_metalstdlib.'

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/LSJFR/sample_metalstdlib'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Julien' => 'julien.forestier@lumiscaphe.com' }
  s.source           = { :git => 'https://github.com/LSJFR/sample_metalstdlib.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.3'

  s.source_files = 'sample_metalstdlib/Classes/**/*'

  s.frameworks = 'Metal'

end
