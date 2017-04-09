$:.push File.expand_path("../lib", __FILE__)  
require "backup/version"  

Gem::Specification.new do |s|  
  s.name        = "backup"  
  s.version     = Backup::VERSION  
  s.platform    = Gem::Platform::RUBY  
  s.authors     = ["gunina_ak"]  
  s.email       = ["gunina.a@list.ru"]  
  s.homepage    = "https://github.com/annkonst/backup-a1"  
  s.summary     = %q{make backup}  
  s.description = %q{make backup and save it to s3}  

  s.rubyforge_project = "backup"  

  s.files         = `git ls-files`.split("\n")   
  s.executables   << "backup"
  s.require_paths = ["lib"]  

  s.add_dependency "net-ssh"
  s.add_dependency "net-scp"
  s.add_dependency "aws-sdk"
end 
