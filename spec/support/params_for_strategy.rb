module ParamsForStrategy
  def params_for(factory_name, options = {})
    factory_attrs = options[:factory_attrs] || {}
    merge_attrs   = options[:merge_attrs]   || {}

    exclude_params = %w(id slug position created_at updated_at)
    f = FactoryBot.build(factory_name, factory_attrs)

    params = f.attributes.except(*exclude_params).dup.with_indifferent_access

    f.class.reflections.select do |_k, v|
      v.macro == :has_many && !v.instance_of?(ActiveRecord::Reflection::ThroughReflection)
    end.each_key do |k|
      assoc_collection = f.send(k)

      next if assoc_collection.empty?
      params["#{k}_attributes"] = {}

      assoc_collection.each_with_index do |assoc_obj, idx|
        params["#{k}_attributes"][idx.to_s] = assoc_obj.attributes.except(*exclude_params << "#{f.class.name.underscore}_id")
      end
    end

    params.merge(merge_attrs)
  end
end

RSpec.configure { |config| config.include ParamsForStrategy, type: :controller }
