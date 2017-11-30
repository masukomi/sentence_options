require "../spec_helper"
describe SentenceOptions::Command do
  it "should be initializable" do
    command = SentenceOptions::Command.new("command_name",
      "description",
      Proc(Array(String), Bool).new { |args| true })
    command.nil?.should(be_false())
    (command.name == "command_name").should(be_true())
    (command.description == "description").should(be_true())
  end

  it "should handle commands matching name" do
    command = SentenceOptions::Command.new("command_name",
      "description",
      Proc(Array(String), Bool).new { |args| true })
    command.handles_command?("command_name").should(be_true())
  end

  it "should not handle commands that don't match name" do
    command = SentenceOptions::Command.new("command_name",
      "description",
      Proc(Array(String), Bool).new { |args| true })
    command.handles_command?("bullshit").should(be_false())
  end

  it "should run the proc via handle" do
    x = 0
    command = SentenceOptions::Command.new("command_name",
      "description",
      Proc(Array(String), Bool).new { |args|
        x = args.size
        true
      })
    command.handle(["a", "b"])
    (x == 2).should(be_true())
  end
  it "handle should return true or false" do
    x = 0
    command = SentenceOptions::Command.new("command_name",
      "description",
      Proc(Array(String), Bool).new { |args|
        args.size % 2 == 0
      }
    )
    # true for even numbers
    response = command.handle(["a", "b"])
    response.should(be_true())
    response = command.handle(["a"])
    response.should(be_false())
  end
end
