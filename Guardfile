ignore /output\/\.git/

guard "nanoc" do
  watch("compass_config.rb")
  watch("nanoc.yaml")
  watch("Rules")
  watch(%r{^(content|layouts|lib)/.*$})
end

guard :bundler do
  watch("Gemfile")
end

guard "livereload" do
  watch(%r{output/.*$})
end
