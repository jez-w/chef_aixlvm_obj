#
# Author:: Jez Wain
# Cookbook Name:: lvmaix
# Library::  lvmobj.rb
#
# Copyright:: © IBM 2016

require 'minitest/autorun'
require_relative '../libraries/storage_system'


class TestStorageSystem < MiniTest::Unit::TestCase
  
  def setup
  end
  
  def test_initialize
    refute nil, AIXLVM::StorageSystem.new
  end
end