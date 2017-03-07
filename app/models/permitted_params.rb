PermittedParams = Struct.new(:params, :current_user) do
  def permitted_params
    model = params[:controller].singularize.to_sym
    attrs = permitted_attributes(model)[0]
    if attrs == :all
      params.require(model).permit!
    else
      params.require(model).permit(*attrs)
    end
  end

  def permitted_attributes(model_name)
    if current_user.is_admin?
      [:all, []]
    else
      case model_name
      when :edit_user
        [[:name, :email], []]
      when :system_user
        [[], [:name, :uid]]
      when :apache
        [[:apache_variation_id, :server_admin], [:skip_nginx]]
      when :vhost
        [add_fields_on_create([:primary, :vhost_aliases, :directory_index, :indexes, :active], :server_name),
         [:server_name, :skip_nginx, :ssl, :ssl_ip_address_id, :ssl_port, :intermediate_cert_id, :ssl_key, :ssl_certificate]]
      when :domain
        [[:active], [:name, :email, :ns1_ip_address_id, :ns2_ip_address_id]]
      when :dns_record
        [[:origin, :dns_record_type, :mx_priority, :dns_record_type_id, :ip_address_id, :value], []]
      when :ftp
        [[:Dir, :User, :new_password, :system_user_id], []]
      when :mysql_user
        [add_fields_on_create([:new_password], [:login, :apache_id, :rails_server_id, :create_db]),
         [:login, :apache_id, :rails_server_id]]
      when :mysql_db
        [add_fields_on_create([], :db_name), [:db_name]]
      when :pgsql_user
        [add_fields_on_create([:new_password], [:login, :apache_id, :rails_server_id, :create_db]),
         [:login, :apache_id, :rails_server_id]]
      when :pgsql_db
        [add_fields_on_create([], :db_name), [:db_name]]
      when :email_domain
        [[], []]
      when :email_user
        [[:username, :new_password], []]
      when :email_alias
        [[:username, :destination], []]
      else
        [[], []]
      end
    end
  end

  private

  def add_fields_on_create(fields, on_create)
    fields << on_create if %w(new create).include?(params[:action])
    fields.flatten
  end
end
