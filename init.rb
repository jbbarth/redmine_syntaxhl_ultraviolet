require 'redmine'
require 'ultraviolethl'

Redmine::Plugin.register :redmine_syntaxhl_ultraviolet do
  name 'Ultraviolet Highlighter plugin'
  author 'Jean-Baptiste BARTH'
  author_url 'http://github.com/jbbarth/redmine_syntaxhl_ultraviolet'
  description 'Ultraviolet highlighting for Redmine (see http://ultraviolet.rubyforge.org/) ; requires "ultraviolet" gem and "redmine_syntaxhl" plugin'
  version '0.1'
end
