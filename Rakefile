require 'middleman-gh-pages'

ENV["BRANCH_NAME"] = "master"
ENV["REMOTE_NAME"] = "origin"

def clone_and_pull link, repo
  sh "git clone #{link}" unless File.directory?(repo)
  cd repo do
    sh 'git pull'
  end
end

task :update do
  mkdir 'hyperloop-repos' unless File.directory?('hyperloop-repos')

  cd 'hyperloop-repos' do

  # ---------------------------- TUTORIALS

    clone_and_pull 'https://github.com/ruby-hyperloop/hyperloop-devise-tutorial.git', 'hyperloop-devise-tutorial'
    cp 'hyperloop-devise-tutorial/README.md', '../source/tutorials/hyperlooprails/devise.html.md'

    clone_and_pull 'https://github.com/ruby-hyperloop/todo-tutorial.git', 'todo-tutorial'
    cp 'todo-tutorial/README.md', '../source/tutorials/hyperlooprails/todomvc.html.md'

  # ---------------------------- GEMS

    clone_and_pull 'https://github.com/ruby-hyperloop/hyper-mesh.git', 'hyper-mesh'
    #cp ...

    clone_and_pull 'https://github.com/ruby-hyperloop/hyperloop-js.git', 'hyperloop-js'
    #  cp...

    clone_and_pull 'https://github.com/ruby-hyperloop/hyper-store.git', 'hyper-store'
    # cp...

    clone_and_pull 'https://github.com/ruby-hyperloop/hyperloop.git', 'hyperloop'
    # cp...

    clone_and_pull 'https://github.com/ruby-hyperloop/hyper-operation.git', 'hyper-operation'
    # cp ...

    clone_and_pull 'https://github.com/ruby-hyperloop/hyper-router.git', 'hyper-router'
    # cp ...

    clone_and_pull 'https://github.com/ruby-hyperloop/hyper-react.git', 'hyper-react'
    # cp ...

    clone_and_pull 'https://github.com/ruby-hyperloop/hyperloop-config.git', 'hyperloop-config'
    # cp ...

    clone_and_pull 'https://github.com/ruby-hyperloop/hyper-model.git', 'hyper-model'
    # cp ...

    clone_and_pull 'https://github.com/ruby-hyperloop/hyper-spec.git', 'hyper-spec'
    # cp ...

    clone_and_pull 'https://github.com/ruby-hyperloop/hyper-component.git', 'hyper-component'
    # cp ...

    clone_and_pull 'https://github.com/ruby-hyperloop/hyper-trace.git', 'hyper-trace'
    # cp ...

  end
end
