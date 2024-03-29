module ForemanProxmox
  module HostExtensions
    extend ActiveSupport::Concern

    included do
      # execute callbacks
    end

    # create or overwrite instance methods...
    def destroy
        vm = Virtualmachine.where("host_id = #{self.id}").first
        vm.delete_virtualmachine
        super
    end
    
    def create
      super
      new_vm = Virtualmachine.new
      if self.params['vmid'] == nil then
        new_vm.get_free_vmid
      else
          new_vm.vmid = self.params['vmid']
      end
        new_vm.sockets = self.params['sockets']
        new_vm.cores = self.params['cores']
        new_vm.memory = self.params['memory']
        new_vm.size = self.params['size']
        new_vm.mac = self.mac
        new_vm.host_id = self.id
        new_vm.save
        
        new_vm.create_harddisk
        new_vm.create_virtualmachine
        new_vm.start
        
    end

    module ClassMethods
      # create or overwrite class methods...
      
    end
  end
end
