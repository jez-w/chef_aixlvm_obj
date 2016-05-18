#
# Author:: Jez Wain
# Cookbook Name:: lvmaix
# Library::  lvmobj.rb
#
# Copyright:: © IBM 2016

require_relative 'command'
require_relative 'volume_group'
require_relative 'physical_volume'

module AIXLVM
  class StorageSystem
    
    def initialize
      @volume_groups = nil
      @physical_volumes = nil
    end
    
    def volume_groups
      self.volume_groups ||=  existing_volume_groups
    end
    
    def existing_volume_groups
      all_vgs = {}
      Command.run('lsvg').stdout.each_line do |vg_name|
        vg_name.chomp!
        vg = VolumeGroup.new({name: vg_name})
        all_vgs[vg_name] = vg
      end
      all_vgs
    end
    
    def physical_volumes
      self.physical_volumes ||= existing_physical_volumes
    end
    
    def existing_physical_volumes
      all_pvs{}
      Command.run('lspv').stdout.each_line do |pv_line|
        pv_name, pv_id, vg, state = pvline.chomp!.split ' '
      end
    end
    
  end
end