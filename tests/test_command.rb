#
# Author:: Jez Wain
# Cookbook Name:: lvmaix
# Library::  lvmobj.rb
#
# Copyright:: © IBM 2016

require 'minitest/autorun'
require_relative '../libraries/command'
require 'date'

class TestCommand < MiniTest::Unit::TestCase
  
  def setup
    @command = AIXLVM::Command.run('date')
    @date = DateTime.now
  end
  
  def test_exists?
    refute @command.nil?, "Failed to create command"
  end
  
  def test_success
    assert @command.success?, "Command unsuccessful"
  end
  
  def test_success_status
    assert_equal 0, @command.exitstatus
  end
  
  def test_date_result
    assert_instance_of String, @command.stdout
    assert @date === DateTime.parse(@command.stdout)
  end
  
  def test_options
    @command = AIXLVM::Command.run('ls -l')
    p @command.stdout
    p '-------------------------'
    p @command.stderr
  end
end