#
# Author:: Jez Wain
# Cookbook Name:: lvmaix
# Library::  lvmobj.rb
#
# Copyright:: © IBM 2016

require_relative 'command'

module AIXLVM
  class PhysicalVolume
    attr_reader :name
    
    def initialize name
      @name = name
    end
    
  end
end