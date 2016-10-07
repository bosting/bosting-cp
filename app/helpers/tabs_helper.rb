module TabsHelper
  def tabs_block(&block)
    content_tag(:ul, capture(&block), class: 'nav nav-tabs', role:'tablist')
  end

  def tabs_content(&block)
    content_tag(:div, capture(&block), class: 'tab-content')
  end

  def tab_presentation(href, desc, active = nil)
    content_tag(:li, role: 'presentation', class: active ? 'active' : nil) do
      link_to(desc, "##{href}", 'aria-controls': href, role: 'tab', 'data-toggle': 'tab')
    end
  end

  def tab_pane(name, active = nil, &block)
    active = active ? ' active in' : ''
    content_tag(:div, capture(&block), id: name, class: 'tab-pane' + active, role: 'tabpanel')
  end
end
