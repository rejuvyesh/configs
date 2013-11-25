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
       ]
gems.each {|gem| load_gem gem}

# awesome_print
load_gem("awesome_print") {Pry.config.print = proc {|output, value| Pry::Helpers::BaseHelpers.stagger_output("=> #{value.ai}", output)}}

# pry config
Pry.config.editor = "emacsclient -n -c"

# some aliases
Pry.config.commands.alias_command "ee", "edit"
