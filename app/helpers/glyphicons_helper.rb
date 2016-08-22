module GlyphiconsHelper
  # TODO: Add font-linux library to vendor
  def glyphicon_tag(library, icon, options = {})
    klass = case library
              when :bs # Bootstrap
                "glyphicon glyphicon-#{icon} "
              when :fa # Font Awesome
                "fa fa-#{icon}"
              when :mi # Material Icon
                "mi #{icon}"
              when :fl # Font Linux
                "fl-#{icon}"
              else
                raise ArgumentError, 'Unknown glyphicon library'
            end
    options[:class] = "icon #{klass} #{options[:class]}".strip
    content_tag(:span, '', options)
  end
end
