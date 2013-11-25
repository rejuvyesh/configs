begin
        require 'rubygems'
        require 'brice/init'
rescue LoadError => err
  warn "Error loading brice: #{err} (#{err.class})"
end

# useful gems
gems = %w{awesome_print date json set yaml chronic}

gems.each do |gem|
  begin
              require gem
  rescue LoadError => err
    warn "Couldn't load #{gem}: #{err}, skipping..."
  end
end
  
