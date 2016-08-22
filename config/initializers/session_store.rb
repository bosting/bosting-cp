# Be sure to restart your server when you modify this file.

domain = if Rails.env.production?
           Setting.get('panel_domain')
         else
           '.lvh.me'
         end
Rails.application.config.session_store :active_record_store, key: '_bosting-cp_session', domain: domain
