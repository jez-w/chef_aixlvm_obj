#Copyright (c) 2013 Steve Richert
#
#MIT License
#
#Permission is hereby granted, free of charge, to any person obtaining
#a copy of this software and associated documentation files (the
#"Software"), to deal in the Software without restriction, including
#without limitation the rights to use, copy, modify, merge, publish,
#distribute, sublicense, and/or sell copies of the Software, and to
#permit persons to whom the Software is furnished to do so, subject to
#the following conditions:
#
#The above copyright notice and this permission notice shall be
#included in all copies or substantial portions of the Software.
#
#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
#EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
#MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
#NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
#LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
#OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
#WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# Modified by Jez Wain, May 2016.


require 'open3'
require 'shellwords'

module AIXLVM
  
  class Command
    attr_reader :stdin, :stdout, :stderr
    
    def self.run(command)
      new(command).run
    end
    
    def initialize(command)
      @stdin = (command.shellescape)
    end
    
    def run
      # Ensure that not working with non-English output
      @stdout, @stderr, @status = Open3.capture3({'LANG' => 'C'}, @stdin)
      self
    end
    
    def success?
      @status && @status.success?
    end
    
    def exitstatus
      @status && @status.exitstatus
    end
    
  end  
  
end