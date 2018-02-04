require 'compass/import-once/activate'

# Add import paths to bower packages here.
add_import_path "content/assets/components/foundation-sites/scss"
add_import_path "content/assets/components/fontawesome/scss"
add_import_path "content/assets/components/motion-ui"

http_path             = "/"
project_path          = File.expand_path(File.dirname(__FILE__))
css_dir               = "content/assets/stylesheets"
sass_dir              = "content/assets/stylesheets"
images_dir            = "content/assets/images"
javascripts_dir       = "content/assets/javascripts"
http_javascripts_path = "js"
http_stylesheets_path = "css"
http_images_path      = "images"
http_fonts_dir        = "fonts"

sass_options = {
  :syntax => :scss
}

# Possible options to generate CSS:
# - :expanded
# - :nested
# - :compact
# - :compressed
output_style = :expanded

# Do not siplay original location of files
line_comments = false
