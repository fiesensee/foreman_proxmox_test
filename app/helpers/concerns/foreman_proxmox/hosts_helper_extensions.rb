module ForemanProxmox
  module HostsHelperExtensions
    extend ActiveSupport::Concern
    

    included do
      alias_method_chain :host_title_actions, :proxmox
    end

    
    def host_title_actions_with_proxmox(*args)
      title_actions(
        button_group(
          if @host.build
            display_button_if_authorized(_("Create VM"), {:controller => 'foreman_proxmox/vm', :action => 'create_vm', :id => @host}, :class => 'btn')
          else
            display_button_if_authorized(_("Delete VM"), {:controller => 'foreman_proxmox/vm', :action => 'delete_vm', :id => @host}, :class => 'btn')
          end
        )
      )
      host_title_actions_without_proxmox(*args)
    end
    
    def display_button_if_authorized(name, options = {}, html_options = {})
      if is_authorized(options)
        link_to(name, proxmox_url(options), html_options)
      else
        ""
      end
    end
    
    def proxmox_url(options)
      ForemanProxmox::Engine.routes.url_for(options.merge(:only_path => true, :script_name => foreman_proxmox_path))
    end
    
    def is_authorized(options)
      User.current.allowed_to?(options)
    end
  end
end
