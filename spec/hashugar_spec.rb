require 'spec_helper'

describe Hashugar do
  context 'when accessing simple hash' do
    it 'should be make accessible string and symbol keys' do
      hashugar = {:a => 1, 'b' => 2}.to_hashugar
      expect(hashugar.a).to eq(1)
      expect(hashugar.b).to eq(2)
    end

    it 'should be readable through nice methods' do
      hashugar = {:a => 1, :b => 2}.to_hashugar
      expect(hashugar.a).to eq(1)
      expect(hashugar.b).to eq(2)
    end

    it 'should be writable through nice methods' do
      hashugar = {:a => 1}.to_hashugar
      hashugar.a = 2
      hashugar.b = 3
      expect(hashugar.a).to eq(2)
      expect(hashugar.b).to eq(3)
    end

    it 'should be readable through old methods' do
      hashugar = {:a => 1}.to_hashugar
      expect(hashugar[:a]).to eq(1)
      expect(hashugar['a']).to eq(1)
    end

    it 'should be writable through old methods' do
      hashugar = {:a => 1}.to_hashugar
      hashugar['a'] = 2
      expect(hashugar.a).to eq(2)
      hashugar[:a] = 3
      expect(hashugar.a).to eq(3)
    end
  end

  context 'when accessing nested hash' do
    it 'should be writable through nice methods' do
      hashugar = {:a => {:b => 1}}.to_hashugar
      expect(hashugar.a.b).to eq(1)
    end

    it 'should be writable through nice methods' do
      hashugar = {:a =>{}}.to_hashugar
      hashugar.a.b = 1
      expect(hashugar.a.b).to eq(1)
    end
  end

  context 'when accessing hashes in array' do
    it 'should return hashugars' do
      hashugar = [{:a => 1}, {:b => 2}].to_hashugar
      expect(hashugar[0].a).to eq(1)
      expect(hashugar.last.b).to eq(2)
    end
  end

  context 'when using respond_to?' do
    it 'should return true on valid key' do
      hashugar = {:a => 1}.to_hashugar
      expect(hashugar.respond_to?('a')).to be_truthy
      expect(hashugar.respond_to?(:a)).to be_truthy
      expect(hashugar.respond_to?(:b)).to be_falsey
    end
  end

  context 'when creating using Hashugar#new' do
    it 'should accept hash in contructor' do
      hashugar = Hashugar.new({:a => {:b => 1}})
      expect(hashugar.a.b).to eq(1)
    end
  end

  context 'when enumerating' do
    it 'should act like normal hash' do
      hashugar = Hashugar.new({:a => 4, :c => 2})

      keys = []
      values = []
      hashugar.each do |k, v|
        keys << k
        values << v
      end

      expect(keys).to eq([:a, :c])
      expect(values).to eq([4, 2])
    end
  end

  describe '#to_hash' do
    it 'responds to to_hash' do
      expect(Hashugar.new({}).respond_to?(:to_hash)).to be true
    end
    it 'returns the original hash' do
      hashugar = Hashugar.new({:a => 4, :c => 2})
      expect(hashugar.to_hash).to eq({:a => 4, :c => 2})
    end

    context 'when containing nested hashugar' do
      it 'returns the original hash' do
        hashugar = Hashugar.new({ nested: { a: 4, c: 2 } })
        expect(hashugar.to_hash[:nested]).to eq({:a => 4, :c => 2})
      end
    end
  end

  describe '#empty?' do
    it 'behaves like the original hash' do
      empty_hashugar = Hashugar.new({})
      hashugar = Hashugar.new({a: 1})
      expect(empty_hashugar.empty?).to be true
      expect(hashugar.empty?).to be false
    end
  end

  describe '#inspect' do
    it 'prints the original hash' do
      hashugar = Hashugar.new({a: { b: 1}})
      expect(hashugar.inspect).to eq('#<Hashugar {:a=>{:b=>1}}>')
    end
  end

  describe 'Enumerable' do
    it 'mixes in  Enumerable methods' do
      hashugar = Hashugar.new({a: 1, b: 2})
      expect(hashugar.any?{|k,v| k == :a}).to eq(true)
      expect(hashugar.all?{|k,v| k == :a}).to eq(false)
      expect(hashugar.map{|k,v| [k, v*2]}).to eq([[:a, 2],[:b, 4]])
    end
  end
end
