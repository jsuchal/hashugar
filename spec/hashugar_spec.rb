require 'spec_helper'

describe Hashugar do
  context 'when accessing simple hash' do
    it 'should be make accessible string and symbol keys' do
      hashugar = {:a => 1, 'b' => 2}.to_hashugar
      hashugar.a.should == 1
      hashugar.b.should == 2
    end

    it 'should be readable through nice methods' do
      hashugar = {:a => 1, :b => 2}.to_hashugar
      hashugar.a.should == 1
      hashugar.b.should == 2
    end

    it 'should be writable through nice methods' do
      hashugar = {:a => 1}.to_hashugar
      hashugar.a = 2
      hashugar.b = 3
      hashugar.a.should == 2
      hashugar.b.should == 3
    end

    it 'should be readable through old methods' do
      hashugar = {:a => 1}.to_hashugar
      hashugar[:a].should == 1
      hashugar['a'].should == 1
    end

    it 'should be writable through old methods' do
      hashugar = {:a => 1}.to_hashugar
      hashugar['a'] = 2
      hashugar.a.should == 2
      hashugar[:a] = 3
      hashugar.a.should == 3
    end
  end

  context 'when accessing nested hash' do
    it 'should be writable through nice methods' do
      hashugar = {:a => {:b => 1}}.to_hashugar
      hashugar.a.b.should == 1
    end

    it 'should be writable through nice methods' do
      hashugar = {:a =>{}}.to_hashugar
      hashugar.a.b = 1
      hashugar.a.b.should == 1
    end
  end

  context 'when accessing hashes in array' do
    it 'should return hashugars' do
      hashugar = [{:a => 1}, {:b => 2}].to_hashugar
      hashugar[0].a.should == 1
      hashugar.last.b.should == 2
    end
  end
end