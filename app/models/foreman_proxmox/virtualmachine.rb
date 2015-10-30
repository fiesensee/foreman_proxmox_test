module ForemanProxmox
  class Virtualmachine < ActiveRecord::Base
    belongs_to :proxmoxserver
    belongs_to :host
    
    
    def create_qemu
      proxmoxserver = Proxmoxserver.find(self.proxmoxserver_id)
      proxmoxserver.create_ide(self.vmid,self.size)
      proxmoxserver.create_kvm(self.vmid,self.sockets,self.cores,self.memory,self.mac)
    end
    
    def start
      proxmoxserver = Proxmoxserver.find(self.proxmoxserver_id)
      proxmoxserver.start_kvm(self.vmid)
    end
    
    def stop
      proxmoxserver = Proxmoxserver.find(self.proxmoxserver_id)
      proxmoxserver.stop_kvm(self.vmid)
    end
    
    def reboot
      proxmoxserver = Proxmoxserver.find(self.proxmoxserver_id)
      proxmoxserver.reboot_kvm(self.vmid)
    end
    
    def delete
      proxmoxserver = Proxmoxserver.find(self.proxmoxserver_id)
      self.stop
      proxmoxserver.delete_kvm(self.vmid)
    end
    
    def get_free_vmid
      proxmoxserver = Proxmoxserver.find(self.proxmoxserver_id)
      self.vmid = proxmoxserver.get_next_free_vmid
    end
  end
end
