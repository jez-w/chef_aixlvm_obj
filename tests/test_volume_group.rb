#
# Author:: Jez Wain
# Cookbook Name:: lvmaix
# Library::  lvmobj.rb
#
# Copyright:: © IBM 2016


require 'minitest/autorun'
require_relative '../libraries/volume_group'

class TestVolumeGroup < MiniTest::Unit::TestCase

  def test_instantiate
    vg = AIXLVM::VolumeGroup.new({name: 'rootvg'})
    refute nil, vg
    assert_equal 'rootvg', vg.name
    assert_equal vg.total_pps, (vg.free_pps + vg.used_pps)
    assert_equal 'active', vg.state
    assert_equal 32, vg.pp_size
  end
  
  def test_no_params
    assert_raises(ArgumentError) do
      vg = AIXLVM::VolumeGroup.new
    end
    assert_raises(ArgumentError) do
      vg = AIXLVM::VolumeGroup.new({})
    end
  end
  
  def test_no_name
    assert_raises(ArgumentError) do
      vg = AIXLVM::VolumeGroup.new({no_name: nil})
    end
  end
end
