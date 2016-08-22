class <%= controller_class_name %>Controller < ApplicationController
  load_and_authorize_resource except: :create

  def index
  end

  <%- if options.show? -%>
  def show
  end

  <%- end -%>
  def new
  end

  def edit
  end

  def create
    @<%= singular_table_name %> = <%= orm_class.build(class_name, "permitted_params") %>
    if @<%= orm_instance.save %>
        redirect_to <%= redirect_to_url %>, notice: t('flash.<%= singular_table_name %>.create')
    else
      render :new
    end
  end

  def update
    @<%= singular_table_name %> = <%= orm_class.find(class_name, "params[:id]") %>
    if @<%= orm_instance.update("permitted_params") %>
      redirect_to <%= redirect_to_url %>, notice: t('flash.<%= singular_table_name %>.update')
    else
      render :edit
    end
  end

  def destroy
    @<%= orm_instance.destroy %>
    redirect_to <%= index_helper %>_path, notice: t('flash.<%= singular_table_name %>.destroy')
  end
end
