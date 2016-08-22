module FormHelper
  def form_wrapper(heading, panel_type = 'default', &block)
    content_tag(:div, class: "panel panel-#{panel_type}") do
      content_tag(:div, heading, class: 'panel-heading') +
          content_tag(:div, class: 'panel-body') do
            capture(&block)
          end
    end
  end

  def options_for_horizontal_form
    {
        html: {
            class: 'form-horizontal'
        },
        wrapper: :horizontal_form,
        wrapper_mappings: {
            check_boxes: :horizontal_radio_and_checkboxes,
            radio_buttons: :horizontal_radio_and_checkboxes,
            file: :horizontal_file_input,
            boolean: :horizontal_boolean
        }
    }
  end
end
