module Redmine
  module SyntaxHighlighting
    module Ultraviolet
      
      class << self
        require 'uv'

        # Returns an array of parameters to define highlighter stylesheets
        # Each line should is passed to a "stylesheet_link_tag" method ; in case
        #   you're writing a plugin, each line would be an array with first the
        #   name of the stylesheet (put in plugin_dir/assets/stylesheets/), and
        #   next a hash of options to pass to "stylesheet_link_tag", for instance
        #   the plugin name...
        # The same is available for .js file if you define "javascripts" method
        def stylesheets
          [
            ["syntax/#{theme}", {:plugin => "redmine_syntaxhl_ultraviolet"}]
          ]
        end
        
        # Used to highlight text in the wiki :
        #   <code class="language">Your Code</code>
        #   will make Redmine call : colorize("Your Code", "language")
        def colorize(text, format)
          Uv.parse(text, "xhtml", format, true, theme)
        end

        # Used to highlight files ; filename is used to guess which language it
        # should use to highlight "content".
        def colorize_file(filename, content)
          # Attachment view has been patched to get the real filename
          # but in case of a repository, it's not simple to access the
          # file with File.open, which is needed by "syntax_for_file".
          # Creating a temporary file implies many problems... So for 
          # the moment, we define a static syntax to use if File is not
          # a real file (predefined extensions are taken from 
          # lib/redmine/mime_type.rb). Any better solution would be 
          # welcome !
          syntax = ""
          syntax = Uv.syntax_for_file("#{RAILS_ROOT}/files/"+filename) if File.readable?(filename)
          if syntax.blank?
            s = {'html'=>'htm,xhtml','c'=>'cpp,h,hh','javascript'=>'js','html'=>'rhtml',
                  'perl'=>'pl,pm','php'=>'php3,php4,php5','python'=>'py','ruby'=>'rb,rbw,ruby,rake',
                  'xml'=>'xml,xsd,mxml','yaml'=>'yml'}
            ext = File.extname(filename).gsub('.','')
            s.each do |k,v|
              syntax = k if v.split(',').include?(ext)
              puts "#{k} => #{v} ; syntax? #{syntax}" 
            end
            syntax = ext if syntax.blank? && Uv.syntaxes.include?(ext)
          end
          # parsing depending on syntax
          if syntax.blank?
            ERB::Util.h(content)
          else
            content = Uv.parse(content.chomp, "xhtml", syntax.first.first, false, theme)
            #next line is ugly, but Redmine handles its own line numbers with tables (which is great!),
            # and it splits ultraviolet "pre" content, so we have to restore it by hand...
            content.gsub(/\n<\/pre>$/,"</pre>").split(/\r?\n+/).join("</pre>\n<pre class=\"#{theme}\">")
          end
        end

        # Specific to ultraviolet
        def theme
          "active4d" #=>make it configurable in future version
        end
      end
      
    end
  end
end
