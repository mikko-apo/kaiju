require 'spec_helper'

describe Tester do
  before do
    @tester = Tester.new
  end

  after do
    @tester.after
  end

  it "tmpdir should create temp directory and clear it after" do
    tmp = @tester.tmpdir
    tmp_2 = @tester.tmpdir
    File.directory?(tmp).should == true
    File.directory?(tmp_2).should == true
    @tester.after
    File.exists?(tmp).should == false
    File.exists?(tmp_2).should == false
  end

  it "tmpdir should copy visible files" do
    tmp = @tester.tmpdir
    Tester.write_files(tmp, "foo.txt" => "aa", "bar/foo.txt" => "bb", ".config" => "cc", "bar/.config" => "dd")
    FileUtils.mkdir(File.join(tmp, ".test"))
    FileUtils.mkdir(File.join(tmp, "bar/.test"))
    dest = @tester.tmpdir(tmp)
    IO.read(File.join(dest, "foo.txt")).should == "aa"
    IO.read(File.join(dest, "bar/foo.txt")).should == "bb"
    File.exists?(File.join(dest, ".config")).should == false
    File.exists?(File.join(dest, "bar/.config")).should == false
    File.exists?(File.join(dest, ".test")).should == false
    File.exists?(File.join(dest, "bar/.test")).should == false
    block_path = nil
    @tester.tmpdir(tmp) do |path|
       IO.read(File.join(path, "foo.txt")).should == "aa"
       block_path = path
       File.exists?(path).should == true
    end
    File.exists?(block_path).should == false
  end

  it "tmpdir should delete target file if there is exception during setup" do
    Tester.expects(:copy_visible_files).raises("test error")
    FileUtils.expects(:remove_entry_secure)
    lambda {@tester.tmpdir("/non-existing-path-for-testing")}.should raise_error("test error")
  end

  it "catch_stdio should catch output" do
    @tester.catch_stdio do
      puts "foo"
    end
    @tester.stdout.join.should == "foo\n"
    @tester.catch_stdio do
      puts "bar"
    end
    @tester.stdout.join.should == "bar\n"
    @tester.catch_stdio
    puts "zap"
    @tester.stdout.join.should == "zap\n"
  end

  it "chdir should change directory" do
    original = Dir.pwd
    parent = File.dirname(original)
    parent.should_not == original
    @tester.chdir(parent) do
       Dir.pwd.should == parent
    end
    Dir.pwd.should == original
    @tester.chdir(parent)
    Dir.pwd.should == parent
  end

  it "should write files and check that files are correct" do
    tmp = @tester.tmpdir
    files = {"a" => "1", "b/c.txt" => "2"}
    Tester.write_files(tmp, files)
    IO.read(File.join(tmp, "a")).should == "1"
    IO.read(File.join(tmp, "b/c.txt")).should == "2"
    Tester.verify_files(tmp, files)
    Tester.verify_files(tmp, "b/" => nil)
    Tester.verify_files(tmp, "b" => nil)
    Tester.verify_files(tmp, "a" => /1/)
    Tester.verify_files(tmp, "a" => lambda { |s| s == "1"} )
    lambda {Tester.verify_files(tmp, files.merge("a" => "bar"))}.should raise_error "File '#{tmp}/a' is broken! Expected 'bar' but was '1'"
    lambda {Tester.verify_files(tmp, "a" => /2/)}.should raise_error "File '#{tmp}/a' does not match regexp /2/, file contents: '1'"
    lambda {Tester.verify_files(tmp, "a" => lambda { |s| s == "2"} )}.should raise_error "File '#{tmp}/a' did not pass test!"
    lambda {Tester.verify_files(tmp, files.merge("foo" => "bar"))}.should raise_error "File '#{tmp}/foo' is missing!"
    lambda {Tester.verify_files(tmp, "c/" => nil)}.should raise_error "Directory '#{tmp}/c/' is missing!"
    lambda {Tester.verify_files(tmp, "b" => "foo")}.should raise_error "Existing directory '#{tmp}/b' should be a file!"
    lambda {Tester.verify_files(tmp, true, "b/c.txt" => "2")}.should raise_error "File '#{tmp}/a' exists, but it should not exist!"
    lambda {Tester.verify_files(tmp, true, "a" => "1")}.should raise_error "Directory '#{tmp}/b' exists, but it should not exist!"
  end
end

