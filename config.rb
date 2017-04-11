
###
# Page options, layouts, aliases and proxies
###

# Per-page layout changes:
#
# With no layout
page '/*.xml', layout: false
page '/*.json', layout: false
page '/*.txt', layout: false

page "/chatrb.html", layout: false
page "/reactrb.html", layout: false

# With alternative layout
# page "/path/to/file.html", layout: :otherlayout

# Proxy pages (http://middlemanapp.com/basics/dynamic-pages/)
# proxy "/this-page-has-no-template.html", "/template-file.html", locals: {
#  which_fake_page: "Rendering a fake page with a local variable" }

###
# Helpers
###

helpers do

  def table_of_contents(resource)
    content = File.read(resource.source_file)
    toc_renderer = Redcarpet::Render::HTML_TOC.new(nesting_level: 1)
    markdown = Redcarpet::Markdown.new(toc_renderer)
    markdown.render(content)
  end

  def componentslink
    link_to '/docs/components/dsl-overview', :class => 'component-blue' do
      "<b>C</b>omponents"
    end
  end

  def operationslink
    link_to '/docs/operations/overview', :class => 'operation-purple' do
      "<b>O</b>perations"
    end
  end

  def modelslink
    link_to '/docs/models/overview', :class => 'model-orange' do
      "<b>M</b>odels"
    end
  end

  def policieslink
    link_to '/docs/policies/authorization', :class => 'policies-black' do
      "<b>P</b>olicies"
    end
  end

  def storeslink
    link_to '/docs/stores/overview', :class => 'store-green' do
      "<b>S</b>tores"
    end
  end

  def isomodelsapilink 
    link_to '/docs/models/active-record', :class => 'model-orange' do
      "<b>I</b>somorphic models and ActiveRecord API"
    end
  end

  def pushnotificationslink 
    link_to '/docs/models/configuring-transport', :class => 'policies-black' do
      "<b>P</b>ush notifications"
    end
  end

  def broadcastpoliciesslink 
    link_to '/docs/policies/authorization#details', :class => 'policies-black' do
      "<b>B</b>roadcast policies"
    end
  end

  def hyperloopgemlink
    link_to 'https://github.com/ruby-hyperloop/hyperloop', :target => '_blank' do
      "<b>H</b>yperloop Gem"
    end
  end



end

activate :blog do |blog|
  # This will add a prefix to all links, template references and source paths
  # blog.prefix = "blog"

  # blog.paginate = true

  blog.permalink = "blog/{year}/{month}/{day}/{title}.html"
  # Matcher for blog source files
  # blog.sources = "{year}-{month}-{day}-{title}.html"
  # blog.taglink = "tags/{tag}.html"
  # blog.layout = "layout"
  blog.summary_separator = /(READMORE)/
  # blog.summary_length = 250
  # blog.year_link = "{year}.html"
  # blog.month_link = "{year}/{month}.html"
  # blog.day_link = "{year}/{month}/{day}.html"
  # blog.default_extension = ".markdown"

  blog.tag_template = "tag.html"
  blog.calendar_template = "calendar.html"

  # Enable pagination
  # blog.paginate = true
  # blog.per_page = 10
  # blog.page_link = "page/{num}"
end

# set :relative_links, true # this does not work!

page "/feed.xml", layout: false
# Reload the browser automatically whenever files change
configure :development do
  activate :livereload
  # Used for generating absolute URLs
  
end

# Methods defined in the helpers block are available in templates
# helpers do
#   def some_helper
#     "Helping"
#   end
# end

# Build-specific configuration
configure :build do
  # Minify CSS on build
  # activate :minify_css

  # Minify Javascript on build
  # activate :minify_javascript

  #activate :relative_assets
  # set :relative_links, true
  # set :site_url, "/reactrb.org"
  # set :http_prefix, '/reactrb.org'


end

# Reload the browser automatically whenever files change
# activate :livereload

# Turn this on if you want to make your url's prettier, without the .html
activate :directory_indexes
activate :relative_assets

set :images_dir, 'images'

# code highlighting in clogs
activate :syntax, :line_numbers => false

set :markdown_engine, :redcarpet

set :markdown, :tables => true, :autolink => true,
  :gh_blockcode => false, :fenced_code_blocks => true,
  :smartypants => false,  with_toc_data: true






activate :deploy do |deploy|
  deploy.deploy_method   = :sftp
  deploy.host            = 'pixagency.com'
  deploy.port            = 22
  deploy.path            = '/home/fcooker/apps/hyperloop'
end