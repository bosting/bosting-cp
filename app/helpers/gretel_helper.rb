module GretelHelper
  def gretel_link_name(object)
    if object.persisted?
      object.name
    else
      t("actions.#{object.class.to_s.underscore}.create")
    end
  end

  def gretel_url_for_new_or_edit(objects)
    if [objects].flatten.last.persisted?
      url_for([:edit, objects].flatten)
    end
  end
end
