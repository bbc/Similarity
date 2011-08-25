Gem::Specification.new do |s|
  s.name = %q{similarity}
  s.version = "0.2.4"
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Chris Lowis"]
  s.date = %q{2011-05-25}
  s.description = <<-EOT
Document similarity calculations using cosine similarity and TF-IDF weights
EOT
  s.email = %q{chris.lowis@bbc.co.uk}
  s.files = Dir["lib/**/*"]
  s.has_rdoc = false
  s.homepage = %q{}
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{similarity}
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Document similarity calculations using cosine similarity and TF-IDF weights}

  s.add_dependency "gsl"

  s.add_development_dependency "rake"
  s.add_development_dependency "faker"
  s.add_development_dependency "ruby-graphviz"
end
