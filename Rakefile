require 'middleman-gh-pages'

ENV["BRANCH_NAME"] = "master"
ENV["REMOTE_NAME"] = "origin"



task :update do

  TUTORIALS_REPOS = ['hyperloop-devise-tutorial', 'todo-tutorial', 'hyperloop-rails-webpackergem-helloworld' ]
  #GEMS_REPOS = ['hyper-mesh', 'hyperloop-js', 'hyper-store', 'hyperloop', 'hyper-operation', 'hyper-router', 'hyper-react', 'hyperloop-config', 'hyper-model', 'hyper-spec', 'hyper-component', 'hyper-component', 'hyper-trace']
  GEMS_REPOS = {"hyper-operation" => "operations" }

  mkdir 'hyperloop-repos' unless File.directory?('hyperloop-repos')

  cd 'hyperloop-repos' do

  # ---------------------------- TUTORIALS

    TUTORIALS_REPOS.each do |tutorial_repo|
      sh "wget -N 'https://raw.githubusercontent.com/ruby-hyperloop/#{tutorial_repo}/master/README.md' -P #{tutorial_repo}"
      cp "#{tutorial_repo}/README.md", "../source/tutorials/hyperlooprails/#{tutorial_repo}.html.md"
    end

    GEMS_REPOS.each do |key, value|
      sh "wget -N 'https://raw.githubusercontent.com/ruby-hyperloop/#{key}/master/DOCS.md' -P #{key}"
      cp "#{key}/DOCS.md", "../source/docs/#{value}/docs.html.md"
    end

    # clone_and_pull 'hyperloop-devise-tutorial', true
    # cp 'hyperloop-devise-tutorial/README.md', '../source/tutorials/hyperlooprails/devise.html.md'

    # clone_and_pull 'todo-tutorial', true
    # cp 'todo-tutorial/README.md', '../source/tutorials/hyperlooprails/todomvc.html.md'

    # clone_and_pull 'hyperloop-rails-webpackergem-helloworld', true
    # cp 'hyperloop-rails-webpackergem-helloworld/README.md', '../source/tutorials/hyperlooprails/webpacker.html.md'

  # ---------------------------- GEMS

    # clone_and_pull 'hyper-mesh', false
    # #cp ...

    # clone_and_pull 'hyperloop-js', false
    # #  cp...

    # clone_and_pull 'hyper-store', false
    # # cp...

    # clone_and_pull 'hyperloop', false
    # # cp...

    # clone_and_pull 'hyper-operation', false
    # cp 'hyper-operation/DOCS.md', '../docs/operations/docs.html.md'

    # clone_and_pull 'hyper-router', false
    # # cp ...

    # clone_and_pull 'hyper-react', false
    # # cp ...

    # clone_and_pull 'hyperloop-config', false
    # # cp ...

    # clone_and_pull 'hyper-model', false
    # # cp ...

    # clone_and_pull 'hyper-spec', false
    # # cp ...

    # clone_and_pull 'hyper-component', false
    # # cp ...

    # clone_and_pull 'hyper-trace', false
    # cp ...


  end
end
