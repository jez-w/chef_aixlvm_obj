#
# Author:: Jez Wain
# Cookbook Name:: lvmaix
# Library::  lvmobj.rb
#
# Copyright:: © IBM 2016

require_relative 'command'


class String
  def is_i?
    /\A[-+]?\d+\z/ === self
  end
end

module AIXLVM
  class VolumeGroup
    attr_accessor :name, :identifier, :state, :pp_size, :total_pps, :free_pps, :used_pps, :max_lvs, :physical_volumes, :logical_volumes
    
    VG_ATTRIBUTES = %w(vg_identifier vg_state pp_size 
    total_pps free_pps used_pps max_lvs physical_volumes)
    
    def initialize attributes
      raise ArgumentError, "Must have at least the name" if attributes.count < 1
      raise ArgumentError, "Must have the name" unless attributes[:name]
      
      @name = attributes[:name]
      p "Initializing volume group: #{@name}"
      
      # If only the name is provided, determine the attributes from the system
      if attributes.count == 1
        load_attributes
        
        # Otherwise create a new VG
      else
        create_vg attributes
      end
    end
        
    # Sets self attributes for an existing vg
    def load_attributes
      p "load attributes"
      self.load_general_attributes
      self.load_pv_attributes
      self.load_lv_attributes
    end
    
    
    # Read the vg attributes from AIX
    #
    # TODO: Check that this work with a non "en_US" LANG
    def load_general_attributes
      p "load general attributes"
      lsvg_command = "lsvg #{self.name}"
      p lsvg_command
      command = Command.run(lsvg_command)
      if command.success?
        stanzas = stanzas_from_lsvg(command.stdout)
        set_attributes_from_stanzas(stanzas)
      else
        p "Command failed #{command.stderr}"
      end
    end
    
    def load_pv_attributes
    end
    
    def load_lv_attributes
    end
    
    # Creates a list of stanzas from the 2 column output of lsvg
    def stanzas_from_lsvg(lsvg_out)
      stanzas = []
      lsvg_out.each_line do |line|
        line.chomp!
        stanza0 = line[0,44].rstrip
        stanza1 = line[45..-1].strip
        stanzas << stanza0
        stanzas << stanza1 if stanza1.length > 0
      end
      stanzas
    end
    
    # Sets self's attributes from a list of lsvg stanzas
    def set_attributes_from_stanzas(lsvg_stanzas)
    
      lsvg_stanzas.each do |stanza|
        attribute, value = stanza.split ':'
        attribute.downcase!.tr!(' ', '_')
        if VG_ATTRIBUTES.include? attribute
          attribute.sub!(/vg_/, '')
          value = value.slice(/[\w\d]+/)
          value = value.to_i if value.is_i?
          method_name = attribute + '='
          if self.respond_to? method_name
            self.send(method_name, value)
          else
            p "No accessor for #{attribute}"
          end
        end
      end
    end # set_attributes_from_stanzas
  end # class
end # module