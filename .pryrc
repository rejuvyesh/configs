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
Pry.config.color = true
Pry.config.theme = "pry-modern"
Pry.config.editor = "emacsclient -n -c"

# wrap ANSI codes so Readline knows where the prompt ends
def colour(name, text)
  if Pry.color
    "\001#{Pry::Helpers::Text.send name, '{text}'}\002".sub '{text}', "\002#{text}\001"
  else
    text
  end
end

# pretty prompt
Pry.config.prompt = [
                     proc do |object, nest_level, pry|
                       prompt = colour :bright_black, Pry.view_clip(object)
                       prompt += ":#{nest_level}" if nest_level > 0
                       prompt += colour :cyan, ' » '
                     end, proc { |object, nest_level, pry| colour :cyan, '» '  }
                    ]

# some aliases
Pry.config.commands.alias_command "ee", "edit"
