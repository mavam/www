# Matthias Vallentin

This repository hosts the source code for my personal website at
<http://matthias.vallentin.net>.

## Architecture

This site uses the static-site generator [nanoc](http://nanoc.ws) to drive the
preprocessing and compilation of the various frameworks unified in this
project:

1. [Bundler](http://bundler.io) manages the Ruby dependencies, listed in
   [Gemfile](Gemfile).

2. [Bower](https://bower.io) to manage the various web frameworks. Examples
   include [Foundation](http://foundation.zurb.com) and
   [Font Awesome](http://fontawesome.io). The file [bower.json](bower.json)
   configures all used packages in this project.

2. [Compass](http://compass-style.org) as CSS/SASS framework. In the
   configuration file [compass_config.rb](compass_config.rb), one can import
   SCSS from the various frameworks bower installed in
   `content/assets/components`.

3. We use [HAML](http://haml.info) to write clean and concise HTML markup.

The repository layout
```
  .
  |----aux/                   Auxiliary external data 
  |----content/               The site content
  |----|----assets/           Resources
  |----|----|----components   Bower packages
  |----|----|----images       Images
  |----|----|----scripts      JavaScript scripts
  |----|----|----stylesheets  (S)CSS
  |----layouts/               Site layouts written in HAML
  |----lib/                   Additional Ruby code for use in layouts
  |----bower.json             Bower package manager configuration
  |----compass_config.rb      SASS configuration
  |----nanoc.yaml             Nanoc configuration
  |----Rules                  Nanoc compilation rules

```

The [Rules](Rules) file describes the compilation process in detail.

# Usage

You need Ruby >= 2.3 and node JS to compile the site. (On Mac OS, `brew install
ruby node` does the trick.) Make sure you have bundler and bower installed:

    gem install bundler
    npm -g install bower

Thereafter, configure the project by installing potentially missing
dependencies:

    bundle install
    bower install

You're set. Now compile the site as follows:

    bundle exec nanoc

Serve the compiled site at <http://localhost:3000>:

    bundle exec nanoc view

To make the edit-compile-view cycle more efficient, you can also use
[Guard](https://github.com/guard/guard) to watch filesystem changes and
automatically recompile the site:

    bundle exec guard

If you're tired of manually hitting reload in the browser, just install the
[LiveReload](http://livereload.com/extensions) extension.

## Deploying

After compiling and visually inspecting the changes, perform the unit tests:

    bundle exec nanoc check --all

In order to push the new site upstream, you need to setup this very git
repository in the `output` directory in branch `gh-pages`:

    cd output
    git init .
    git remote add origin THIS_ORIGIN
    git fetch
    git checkout -f gh-pages # force overwrite to get current state

Thereafter, use nanoc to automatically push your changes upstream:

    bundle exec nanoc deploy

## License

Please consult the [licensing terms](LICENSE.md) for details.
