require 'spec_helper'

describe KaijuShellCommand do
  before do
    @tester = Tester.new
  end
  after do
    @tester.after
  end

  it "should support pluggable commands" do
    original_commands = KaijuShellCommand::CommandRegistry.dup
    @tester.cleaners << lambda do
      KaijuShellCommand::CommandRegistry.clear
      KaijuShellCommand::CommandRegistry.register(original_commands)
    end
    class TestCommand

    end
    TestCommand.any_instance.expects(:execute).with(["123","456"])
    TestCommand.any_instance.expects(:help).returns("Help")
    KaijuShellCommand.register_cmd("test-command", TestCommand)
    KaijuShellCommand.new.execute(["test-command","123","456"])
    @tester.catch_stdio do
      KaijuShellCommand.new.execute(["help","test-command"])
    end.stdout.join.should == "Help\n"
  end

  it "should list available commands" do
    original_commands = KaijuShellCommand::CommandRegistry.dup
    @tester.cleaners << lambda do
      KaijuShellCommand::CommandRegistry.clear
      KaijuShellCommand::CommandRegistry.register(original_commands)
    end
    class TestCommand

    end
    KaijuShellCommand.register_cmd("test-command", TestCommand)
    TestCommand.any_instance.expects(:summary).returns("Test command is for testing")
    @tester.catch_stdio do
      KaijuShellCommand.new.execute(["help"])
    end.stdout.join.should =~ /Test command is for testing/
  end

end
