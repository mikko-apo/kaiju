# -*- encoding: utf-8 -*-

require 'optparse'

# Common launcher for all Kaiju commands
# * all command classes can register themselves using the register_cmd method
class KaijuShellCommand
  # Shared command registry
  CommandRegistry = ServiceRegistry.new
  CommandPrefix = "/commands/"

  # Command classes are registered using this method
  def self.register_cmd(name, clazz)
    CommandRegistry.register(CommandPrefix + name, clazz)
  end

  def self.new_cmd(name)
    initialize_cmd(CommandRegistry.find!(CommandPrefix + "#{name}"), name)
  end

  def self.initialize_cmd(cmd_class, name)
    cmd = cmd_class.new
    if cmd.respond_to?(:shell_command=)
      cmd.shell_command="#{$0} #{name}"
    end
    cmd
  end

  # bin/kaiju command line tool calls this method, which finds the correct class to manage the execution
  def execute(args)
    if args.empty?
      KaijuShellHelp.new.execute([])
    else
      my_args = args.dup
      KaijuShellCommand.new_cmd(my_args.delete_at(0)).execute(my_args)
    end
  end
end

# Displays help for given command
class KaijuShellHelp
  # Summary
  attr_chain :summary, -> {"Displays help for given Kaiju command"}
  # Finds matching command and displays its help
  def execute(args)
    if args.size == 1
      puts KaijuShellCommand.new_cmd(args.first).help
    else
      puts <<EOF
Kaiju is a simple issue tracking software. This command line tool gives access to some of its functionality.
Most of the functionality is provided by the web application, which you can start with '#{$0} web start'

Usage:
  #{$0} COMMAND parameters

Available commands:
EOF
      KaijuShellList.new.execute(nil)

puts "\nRun '#{$0} help COMMAND' for more information about that command."
    end
  end
end

# Lists available Kaiju commands
class KaijuShellList
  attr_chain :summary, -> {"Lists available Kaiju commands"}
  # Finds all commands under /commands and outputs their id and summary
  def execute(args)
    commands = KaijuShellCommand::CommandRegistry.find(KaijuShellCommand::CommandPrefix[0..-2])
    commands.each do |id, service_class|
      puts "  #{id[KaijuShellCommand::CommandPrefix.size..-1]}: #{service_class.new.summary}"
    end
  end
end

KaijuShellCommand.register_cmd("help", KaijuShellHelp)
