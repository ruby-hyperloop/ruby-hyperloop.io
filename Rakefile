require 'middleman-gh-pages'

ENV["BRANCH_NAME"] = "master"
ENV["REMOTE_NAME"] = "origin"

def clone_and_pull repo
  sh "git clone https://github.com/ruby-hyperloop/#{repo}.git" unless File.directory?(repo)
  cd repo do
    sh 'git pull'
  end
end

task :update do
  mkdir 'hyperloop-repos' unless File.directory?('hyperloop-repos')

  cd 'hyperloop-repos' do

  # ---------------------------- TUTORIALS

    clone_and_pull 'hyperloop-devise-tutorial'
    cp 'hyperloop-devise-tutorial/README.md', '../source/tutorials/hyperlooprails/devise.html.md'

    clone_and_pull 'todo-tutorial'
    cp 'todo-tutorial/README.md', '../source/tutorials/hyperlooprails/todomvc.html.md'

  # ---------------------------- GEMS

    clone_and_pull 'hyper-mesh'
    #cp ...

    clone_and_pull 'hyperloop-js'
    #  cp...

    clone_and_pull 'hyper-store'
    # cp...

    clone_and_pull 'hyperloop'
    # cp...

    clone_and_pull 'hyper-operation'
    # cp ...

    clone_and_pull 'hyper-router'
    # cp ...

    clone_and_pull 'hyper-react'
    # cp ...

    clone_and_pull 'hyperloop-config'
    # cp ...

    clone_and_pull 'hyper-model'
    # cp ...

    clone_and_pull 'hyper-spec'
    # cp ...

    clone_and_pull 'hyper-component'
    # cp ...

    clone_and_pull 'hyper-trace'
    # cp ...


  end
end
