class PermittedFormBuilder < SimpleForm::FormBuilder
  alias parent_input input

  def input(attribute_name, options = {}, &block)
    case field_permission(attribute_name)
      when :editable
        super
      when :readonly
        super { object[attribute_name].to_s }
    end
  end

  def association(attribute_name, options={}, &block)
    case field_permission((attribute_name.to_s + '_id').to_sym)
      when :editable
        super
      when :readonly
        parent_input(attribute_name, options) do
          attribute = object.send(attribute_name)
          if attribute.class == Array
            attribute.map { |attr| extract_value(attr) }.join(', ')
          else
            extract_value(attribute)
          end
        end
    end
  end

  def fields_for(attribute_name, *args, &block)
    case field_permission(attribute_name)
      when :editable
        super
      when :readonly
        super { object.send(attribute_name).map { |attr| extract_value(attr) }.join(' ') }
    end
  end

  def editable_field?(attribute_name)
    field_permission(attribute_name) == :editable
  end

  private
  def field_permission(attribute_name)
    if check_attr_permission(get_options[:editable_attributes], attribute_name)
      :editable
    elsif check_attr_permission(get_options[:readonly_attributes], attribute_name)
      :readonly
    end
  end

  def extract_value(attribute)
    method = SimpleForm.collection_label_methods.find { |m| attribute.respond_to?(m) }
    attribute.send(method)
  end

  def check_attr_permission(collection, attribute_name)
    return false if collection.nil?
    collection == :all || collection.include?(attribute_name) || collection.include?("#{attribute_name}_id")
  end

  def get_options
    if @parent_builder
      @parent_builder.options
    else
      self.options
    end
  end
end
