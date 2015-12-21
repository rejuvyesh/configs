#!/usr/bin/env ruby
# -*- encoding: utf-8 -*-

def load_gem gem, &block
  begin
    require gem
    block.call if block_given?
  rescue LoadError => err
    warn "Couldn't load #{gem}: #{err}, skipping..."
  end
end

# useful gems you want loaded by default
gems = [
        "chronic",
        "json",
        "yaml",
        "epitools"
       ]
gems.each {|gem| load_gem gem}

# awesome_print
load_gem("awesome_print") {Pry.config.print = proc {|output, value| Pry::Helpers::BaseHelpers.stagger_output("=> #{value.ai}", output)}}

module Pry::Helpers::Text
  class << self
    alias_method :grey, :bright_black
    alias_method :gray, :bright_black
  end
end

# # pry config
Pry.config.color = true
# Pry.config.theme = "pry-modern"
Pry.config.editor = "emacs-gui-wait"

Pry.commands.instance_eval do
  
  command "lls", "List local files using 'ls'" do |*args|
    cmd = ".ls"
    cmd << " --color=always" if Pry.color
    run cmd, *args
  end
  
  command "pwd" do
    puts Dir.pwd.split("/").map{|s| text.bright_green s}.join(text.grey "/")
  end

end

# some aliases
Pry.config.commands.alias_command "ee", "edit"
