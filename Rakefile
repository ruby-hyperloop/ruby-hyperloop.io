require 'middleman-gh-pages'

ENV["BRANCH_NAME"] = "master"
ENV["REMOTE_NAME"] = "origin"

task :update do
  mkdir 'hyperloop-repos' unless File.directory?('hyperloop-repos')

  cd 'hyperloop-repos' do

    # hyperloop-devise-tutorial
    sh 'git clone https://github.com/ruby-hyperloop/hyperloop-devise-tutorial.git' unless File.directory?('hyperloop-devise-tutorial')
    cd 'hyperloop-devise-tutorial' do
      sh 'git pull'
      cp 'README.md', '../../source/tutorials/hyperlooprails/devise.html.md'
    end

    # hyperloop-todonvc-tutorial
    sh 'git clone https://github.com/ruby-hyperloop/todo-tutorial.git' unless File.directory?('todo-tutorial')
    cd 'todo-tutorial' do
      sh 'git pull'
      cp 'README.md', '../../source/tutorials/hyperlooprails/todomvc.html.md'
    end


  end
end