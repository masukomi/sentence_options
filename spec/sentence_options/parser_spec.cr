require "../spec_helper"
describe SentenceOptions::Parser do
  it "should be initializable" do
    parser = SentenceOptions::Parser.new("banner")
    parser.nil?.should(be_false())
  end

  it "should have no commands initially" do
    parser = SentenceOptions::Parser.new("banner")
    parser.commands.size.should(eq(0))
  end

  it "should be able to add commands" do
    command = SentenceOptions::Command.new("command_name",
      "description",
      Proc(Array(String), Bool).new { |args| true })
    parser = SentenceOptions::Parser.new("banner")
    parser.add_command(command)
    parser.commands.size.should(eq(1))
    parser.commands.first.name.should(eq("command_name"))
  end

  it "should return false if it was unable to handle a command" do
    command = SentenceOptions::Command.new("command_name",
      "description",
      Proc(Array(String), Bool).new { |args| true })
    parser = SentenceOptions::Parser.new("banner")
    parser.add_command(command)
    parser.parse(["bullshit_command", "arg1"]).should(be_false())
  end

  it "should pass args.size -1 args to a command" do
    x = 0
    command = SentenceOptions::Command.new("real_command",
      "description",
      Proc(Array(String), Bool).new { |args|
        x = args.size
        true
      })
    parser = SentenceOptions::Parser.new("banner")
    parser.add_command(command)
    parser.parse(["real_command", "arg1"]).should(be_true())
    x.should(eq(1))
  end
end
