require 'middleman-gh-pages'

ENV["BRANCH_NAME"] = "master"
ENV["REMOTE_NAME"] = "origin"



task :update do

  TUTORIALS_REPOS = ['hyperloop-devise-tutorial',
                     'todo-tutorial',
                     'hyperloop-rails-webpackergem-helloworld'
  ]

  GEMS_REPOS = [     { repo: 'hyper-operation', folder: 'operations' },
                     { repo: 'hyper-react', folder: 'components' },
                     { repo: 'hyper-operation' , folder: 'policies', file: 'DOCS-POLICIES.md' },
                     { repo: 'hyper-store', folder: 'stores' },
                     { repo: 'hyper-mesh', folder: 'models' },
                     { repo: 'hyper-router', folder: 'router' },
  ]

  mkdir 'hyperloop-repos' unless File.directory?('hyperloop-repos')

  cd 'hyperloop-repos' do

    TUTORIALS_REPOS.each do |tutorial_repo|
      sh "wget -N 'https://raw.githubusercontent.com/ruby-hyperloop/#{tutorial_repo}/master/README.md' -P #{tutorial_repo}"
      cp "#{tutorial_repo}/README.md", "../source/tutorials/hyperlooprails/#{tutorial_repo}.html.md"
    end

    GEMS_REPOS.each do |item|
      repo = item[:repo]
      folder = item[:folder]
      file = item[:file] || 'DOCS.md'
      sh "wget -N 'https://raw.githubusercontent.com/ruby-hyperloop/#{repo}/master/#{file}' -P #{repo}"
      cp "#{repo}/#{file}", "../source/docs/#{folder}/docs.html.md"
    end

  end
end
