module SentenceOptions
  class Parser
    getter :commands
    getter :banner

    # Creates a new Parser with the specified banner
    def initialize(@banner : String)
      @commands = Array(Command).new
    end

    # Adds a `Command` to the list of commands.
    # Note: Commands will be compared against arguments
    # in the order added.
    def add_command(command : Command)
      @commands << command
    end

    # parses the arguments (typically ARGV) passed to your app
    # Returns: Bool - false if no `Command`s matched, or no arguments were passed.
    # When a `Command` matches it returns the return value of its attempt to
    # handle the args.
    #
    # ```
    # successful = my_parser.parse(ARGV)
    # STDERR.puts my_parser.banner unless successful
    # ```
    def parse(args)
      if args.size > 0
        first_arg = args.first
        @commands.each do |command|
          if command.handles_command? first_arg
            return command.handle (args.size > 1 ? args[1..-1] : Array(String).new)
          end
        end
      end
      return false
    end

    # Retuns a usage string comprised of the baner and the description from
    # all the `Command` objects that have been added.
    # typically displayed when --help is called or
    # when no arguments are passed
    def usage
      String.build do |str|
        str << @banner
        str << "\n"
        @commands.each do |command|
          str << command.description
          str << "\n"
        end
      end
    end
  end
end
