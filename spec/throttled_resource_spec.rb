require 'spec_helper'

describe ThrottledResource do
  before do
    @tester = Tester.new
  end

  after do
    @tester.after
  end

  it "tmpdir should create temp directory and clear it after" do
    tr = ThrottledResource.new(1)
    a = Thread.new do
      tr.throttle do
        sleep 1
        puts "a"
      end
    end
    tr.throttle do
      puts "b"
    end
    a.join
  end
end

