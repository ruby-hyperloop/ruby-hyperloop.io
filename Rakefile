require 'middleman-gh-pages'

ENV["BRANCH_NAME"] = "master"
ENV["REMOTE_NAME"] = "origin"



task :update do

  TUTORIALS_REPOS = ['hyperloop-devise-tutorial',
                     'todo-tutorial',
                     'hyperloop-rails-webpackergem-helloworld'
  ]

  GEMS_REPOS = [     { "hyper-operation" => "operations" },
                     { "hyper-store" => "stores" },
                     { "hyper-mesh" => "models" },
                     { "hyper-router" => "router" },
  ]

  # GEMS_REPOS = ["hyper-mesh" => "hypermesh",
  #               "hyperloop-js" => "hyperloopjs",
  #               "hyperloop" => "hyperloop",
  #               "hyper-operation" => "operations",
  #               "hyper-react" => "hyperreact",
  #               "hyperloop-config" => "hyperloopconfig",
  #               "hyper-spec" => "hyperspec",
  #               "hyper-component" => "components",
  #               "hyper-trace" => "hypertrace",
  #               "hyper-console" => "hyperconsole"]


  mkdir 'hyperloop-repos' unless File.directory?('hyperloop-repos')

  cd 'hyperloop-repos' do

    TUTORIALS_REPOS.each do |tutorial_repo|
      sh "wget -N 'https://raw.githubusercontent.com/ruby-hyperloop/#{tutorial_repo}/master/README.md' -P #{tutorial_repo}"
      cp "#{tutorial_repo}/README.md", "../source/tutorials/hyperlooprails/#{tutorial_repo}.html.md"
    end

    GEMS_REPOS.each do |key, value|
      sh "wget -N 'https://raw.githubusercontent.com/ruby-hyperloop/#{key}/master/DOCS.md' -P #{key}"
      cp "#{key}/DOCS.md", "../source/docs/#{value}/docs.html.md"
    end

  end
end
