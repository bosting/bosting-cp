crumb :root do
  link 'Главная', root_path
end

%w(apache domain edit_user email_domain ftp ip_address mysql_db mysql_user pgsql_db pgsql_user rails_server registrar
   setting ssl_cert_chain system_group system_user system_user_shell ).each do |object|
  plural_name = object.pluralize

  crumb plural_name.to_sym do
    link t("headers.#{plural_name}"), [plural_name]
  end

  crumb object.to_sym do |object|
    link gretel_link_name(object), gretel_url_for_new_or_edit(object)
    parent plural_name.to_sym
  end
end

[%w(dns_record domain), %w(vhost apache), %w(email_user email_domain), %w(email_alias email_domain), %w(mysql_db mysql_user), %w(pgsql_db pgsql_user)].each do |object_name, parent_object_name|
  plural_name = object_name.pluralize
  parent_plural_name = parent_object_name.pluralize

  crumb plural_name.to_sym do |parent_object|
    link t("headers.#{plural_name}"), [parent_object, plural_name.to_sym]
    parent parent_object_name.to_sym, parent_object
  end

  crumb object_name.to_sym do |object, parent_object|
    link gretel_link_name(object)
    parent plural_name.to_sym, parent_object
  end

  crumb parent_object_name.to_sym do |object|
    link gretel_link_name(object), gretel_url_for_new_or_edit(object)
    parent parent_plural_name.to_sym
  end
end

crumb :quick_registration do
  link t('actions.quick_registration.create')
end
