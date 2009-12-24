require 'gli'
require 'gli/command'
require 'yaml'

module GLI
  class InitConfig < Command
    COMMANDS_KEY = 'commands'

    def initialize(config_file_name)
      @filename = config_file_name
      super(:initconfig,"Initialize the config file using current global options",nil,'Initializes a configuration file where you can set default options for command line flags, but globally and on a per-command basis.  These defaults override the built-in defaults and allow you to omit commonly-used command line flags when invoking this program')

      self.desc 'force overwrite of existing config file'
      self.switch :force
    end

    def execute(global_options,options,arguments)
      if options[:force] || !File.exist?(@filename)
        config = global_options
        config[COMMANDS_KEY] = {}
        GLI.commands.each do |name,command|
          config[COMMANDS_KEY][name.to_sym] = {} if command != self
        end
        File.open(@filename,'w') do |file|
          YAML.dump(config,file)
        end
      else
        puts "Not overwriting existing config file #{@filename}"
        puts 'Use --force to override'
      end
    end
  end
end
