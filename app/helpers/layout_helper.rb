module LayoutHelper
  def title(page_title, show_title = true)
    content_for(:title) { page_title.to_s }
    @show_title = show_title
  end

  def show_title?
    @show_title
  end

  def stylesheet(*args)
    content_for(:head) { stylesheet_link_tag(*args) }
  end

  def javascript(*args)
    content_for(:head) { javascript_include_tag(*args) }
  end

  def flash_messages
    flash_messages = []
    flash.each do |type, message|
      type = type.to_sym
      type = :success if type == :notice
      type = :danger  if type == :alert
      type = :danger  if type == :error
      next unless [:success, :info, :warning, :danger].include?(type)

      close_button = content_tag(:button, type: 'button', class: 'close', 'data-dismiss' => 'alert', 'aria-label' => 'Close') do
        content_tag(:span, raw('&times;'), 'aria-hidden' => 'true')
      end

      Array(message).each do |msg|
        text = content_tag(:div, close_button + msg, class: "alert alert-#{type} alert-dismissible", role: 'alert')
        flash_messages << text if msg
      end
    end
    flash_messages.join("\n").html_safe
  end

  def yes_no(val)
    if val
      admin_icon(:yes)
    else
      admin_icon(:no)
    end
  end

  def admin_icon(action)
    case action
    when :edit
      glyphicon_tag(:mi, 'edit')
    when :destroy
      glyphicon_tag(:fa, 'trash')
    when :dns_records
      glyphicon_tag(:mi, 'dns')
    when :vhosts
      glyphicon_tag(:mi, 'web')
    when :external_link
      glyphicon_tag(:fa, 'external-link', title: t('site.external_link'))
    when :yes
      glyphicon_tag(:bs, 'ok-circle', class: 'icon-yes', title: t('site.yes'), 'data-toggle': 'tooltip')
    when :no
      glyphicon_tag(:bs, 'remove-circle', class: 'icon-no', title: t('site.no'), 'data-toggle': 'tooltip')
    when :email_users
      glyphicon_tag(:mi, 'people')
    when :mail_aliases
      glyphicon_tag(:fa, 'share')
    when :databases
      glyphicon_tag(:fa, 'database')
    else
      raise ArgumentError, 'Unknown icon'
    end
  end

  def link_to_new(controller, parent_object = nil)
    content_tag(:div) do
      link_to t("actions.#{controller}.create"), [:new, parent_object, controller].compact, class: 'btn btn-new btn-primary'
    end
  end

  def link_to_back(path)
    content_tag(:p, link_to(t('site.back'), path, class: 'btn btn-sm btn-default'))
  end

  def link_to_edit(path)
    link_to(admin_icon(:edit), [:edit, path].flatten, class: 'btn btn-success', title: t('site.edit'), 'data-toggle': 'tooltip')
  end

  def link_to_destroy(path)
    link_to(admin_icon(:destroy), path, 'data-confirm': t('site.confirm'), method: :delete,
                                        class: 'btn btn-danger', title: t('site.destroy'), 'data-toggle': 'tooltip')
  end

  def active_class(controller)
    controller_name == controller.to_s ? 'active' : nil
  end

  def table_class
    'table table-hover'
  end
end
