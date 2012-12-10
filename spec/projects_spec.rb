require 'spec_helper'

describe KaijuFileSystemRoot do
  before do
    @tester = Tester.new
    @root = KaijuFileSystemRoot.new(@tester.tmpdir)
  end

  after do
    @tester.after
  end

  it "should return project" do
    @root.projects.empty?.should == true
    @root.projects.size.should == 0
    @root.projects.include?("foo").should == false
    foo = @root.create_project("foo","XX")
    @root.projects.empty?.should == false
    @root.projects.size.should == 1
    @root.projects.include?("foo").should == true
    foo.name.should == "foo"
    foo.items.empty?.should == true
    foo.groups.empty?.should == true
  end

  it "should return item" do
    foo = @root.projects.create_project("foo","XX")
    bar = foo.create_item("description" =>"Test description")
    bar.item_id.should == "XX-1"
    bar["description"].should == "Test description"
  end

end