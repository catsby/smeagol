#
# Cookbook Name:: rvm
# Recipe:: default
#

execute "install rvm for the user" do
  command "rvm-install"
  not_if  "test -d ~/.rvm"
end

script "installing ruby" do
  interpreter "bash"
  code <<-EOS
    source ~/.cider.profile
    `rvm rbx -S ruby --version | grep rbx | head -n1 | grep -q "not installed"`
    if [ $? -eq 0 ]; then
      rvm install rbx
      rvm use ruby-1.8.7-p249 --default
    fi
  EOS
end

script "updating rvm to the latest stable version" do
  interpreter "bash"
  code <<-EOS
    source ~/.cider.profile
    rvm update -—head
  EOS
end

execute "cleanup rvm build artifacts" do
  command "rm -rf ~/.rvm/src/rbx-1.0.0-20100514 ~/.rvm/src/rubinius-1.0.0 ~/.rvm/src/ruby-1.8.7-p249"
end

template "#{ENV['HOME']}/.gemrc" do
  source "dot.gemrc.erb"
end

script "updating to the latest bundler 0.9.X version" do
  interpreter "bash"
  code <<-EOS
    `gem list bundler | grep -q '0.9.25'`
    if [[ $? -eq 0 ]]; then
      source ~/.cider.profile
      gem install bundler --no-rdoc --no-ri
    fi
  EOS
end

script "updating to the latest bundler08 version" do
  interpreter "bash"
  code <<-EOS
    `gem list bundler08 | grep -q '0.8.5'`
    if [[ $? -eq 0 ]]; then
      source ~/.cider.profile
      gem install bundler08 --no-rdoc --no-ri
    fi
  EOS
end

script "updating to the latest cider version" do
  interpreter "bash"
  code <<-EOS
    `gem list cider | grep -q '0.1.2'`
    if [[ $? -eq 0 ]]; then
      source ~/.cider.profile
      gem install cider --no-rdoc --no-ri
    fi
  EOS
end

gem_package "cider" do
  version "0.1.2"
  gem_binary "#{ENV['HOME']}/.rvm/rubies/ruby-1.8.7-p249/bin/gem"
end
