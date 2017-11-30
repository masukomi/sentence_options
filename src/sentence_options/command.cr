module SentenceOptions
  class Command
    getter :name, :description

    # It is assumed that every set of args begins with a Command keyword/name.
    # The name of this command will be used to determine if it should be used to
    # handle the current set of arguments.
    # The description will be used when generating usage instructions.
    # the handler is a proc that will be passed all the arguments after
    # the one that matched the name.
    #
    # For example. The following:
    # ```
    # my_app tag last item urgent
    # ```
    # will be handled by the Command with the name "tag"
    # and its handler will be passed "last item urgent"
    # It is assumed that the handler would have the logic needed
    # to know that "last" is followed by a modifier to tell what
    # kind of thing to choose the last one of, and then tag with "urgent"
    def initialize(
                   @name : String,
                   @description : String,
                   @handler : Proc(Array(String), Bool))
    end

    # Returns a Bool indicating if it can handle the specified command.
    def handles_command?(a_command : String) : Bool
      return @name == a_command
    end

    # Calls the stored proc with the specified args.
    # Returns a Bool from the proc indicating if it was successful or not.
    def handle(args : Array(String)) : Bool
      @handler.call(args)
    end
  end
end
