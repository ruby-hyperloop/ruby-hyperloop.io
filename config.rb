###
# Page options, layouts, aliases and proxies
###

# Per-page layout changes:
#
# With no layout
page '/*.xml', layout: false
page '/*.json', layout: false
page '/*.txt', layout: false
# page '/index.html', :layout => false

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
    toc_renderer = Redcarpet::Render::HTML_TOC.new(with_toc_data: true)
    markdown = Redcarpet::Markdown.new(toc_renderer)
    markdown.render(content)
    #  problem with this version is that the TOC is there
    #  but there are no anchor links
    #  Example: <h2>DSL Overview</h2>
  end
end

# helpers do
#   def table_of_contents(resource)
#     content = File.read(resource.source_file)
#     toc_renderer = Redcarpet::Render::HTML.new
#     markdown = Redcarpet::Markdown.new(toc_renderer)
#     markdown.render(content)
      # problem with this version is that there is NO TOC
      # but the anchor links are there!!
      # Example: <h2 id='dsl_overview'>DSL Overview</h2>
#   end
# end


activate :blog do |blog|
  # This will add a prefix to all links, template references and source paths
  # blog.prefix = "blog"

  # blog.permalink = "{year}/{month}/{day}/{title}.html"
  # Matcher for blog source files
  # blog.sources = "{year}-{month}-{day}-{title}.html"
  # blog.taglink = "tags/{tag}.html"
  # blog.layout = "layout"
  # blog.summary_separator = /(READMORE)/
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

page "/feed.xml", layout: false
# Reload the browser automatically whenever files change
# configure :development do
#   activate :livereload
# end

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

  activate :relative_assets
  set :relative_links, true
  set :site_url, "/reactrb.org"
  # set :http_prefix, '/reactrb.org' # enableing this stops sytlesheets working

end

# Reload the browser automatically whenever files change
activate :livereload

# Turn this on if you want to make your url's prettier, without the .html
activate :directory_indexes

# code highlighting in clogs
activate :syntax, :line_numbers => false
set :markdown_engine, :redcarpet
set :markdown, :tables => true, :autolink => true,
  :gh_blockcode => true, :fenced_code_blocks => true,
  :smartypants => true,  toc_data: true
