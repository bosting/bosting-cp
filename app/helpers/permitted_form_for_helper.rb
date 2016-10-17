module PermittedFormForHelper
  def permitted_form_for(*args, &block)
    options = args.extract_options!.reverse_merge(builder: PermittedFormBuilder,
                                                  editable_attributes: editable_attributes_from_object(args.first),
                                                  readonly_attributes: readonly_attributes_from_object(args.first))
    simple_form_for(*(args << options), &block)
  end

  def permitted_nested_form_for(*args, &block)
    options = args.extract_options!.reverse_merge(builder: PermittedNestedFormBuilder,
                                                  editable_attributes: editable_attributes_from_object(args.first),
                                                  readonly_attributes: readonly_attributes_from_object(args.first))
    simple_form_for(*(args << options)) do |f|
      capture(f, &block).to_s << after_nested_form_callbacks
    end
  end

  private
  def editable_attributes_from_object(object)
    permitted_attributes(get_model_name(object))[0]
  end

  def readonly_attributes_from_object(object)
    permitted_attributes(get_model_name(object))[1]
  end

  def get_model_name(object)
    (object.class == Array ? object.last : object).class.to_s.underscore.to_sym
  end
end
