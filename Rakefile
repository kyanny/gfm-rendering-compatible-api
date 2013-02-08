require "rspec/core/rake_task"

RSpec::Core::RakeTask.new("spec")
task :default => :spec

namespace :td do
  desc 'Treasure Data One-Time import (/var/log/httpd/access.log)'
  task :import do
    home = ENV['HOME']
    Dir.chdir("#{home}/current") do
      latest_access_log_gz = `ls -t1 /var/log/httpd/access.log-*.gz | head -n 1`.chomp
      gz = File.basename(latest_access_log_gz)
      system("cp #{latest_access_log_gz} #{home}/tmp/#{gz}")
      system("gunzip #{home}/tmp/#{gz}")
      system("ruby -anle 'puts $F[1..-1].join(" ")' < #{home}/tmp/#{gz}") # remote preceding $host field
      system("bundle exec td table:import gfm www_access #{home}/tmp/#{gz}")
    end
  end
end
