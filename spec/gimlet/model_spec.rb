require_relative '../spec_helper'

class TestModel
  include Gimlet::Model
  source Gimlet::DataStore.new(fixture_path('model'))

  scope :even, -> { where(even: true) }
  scope :odd,  -> { where(odd:  true) }
end

class TestMessage
  include Gimlet::Model
  source Gimlet::DataStore.new(fixture_path('messages.yml'))
end

describe Gimlet::Model do
  describe '.find' do
    subject { TestModel.find(1) }

    it do
      expect(subject.id).to eq(1) # NOTE or should be "1" ?
    end

    it do
      expect(subject.name).to eq('one')
    end
  end

  describe '.all' do
    subject { TestModel.all }

    it do
      expect(subject.size).to eq(3)
    end
  end

  describe '.count' do
    subject { TestModel.count }

    it do
      expect(subject).to eq(3)
    end
  end

  describe '.where' do
    subject { TestModel.where(even: true) }

    it do
      expect(subject.first.name).to eq('two')
    end
  end

  describe '.scope' do
    subject { TestModel.even }

    it do
      expect(subject.first.name).to eq('two')
    end
  end

  describe 'where chain' do
    subject { TestModel.where(id: 1).where(odd: true) }

    it do
      expect(subject.first.name).to eq('one')
    end
  end

  describe 'where then scope' do
    subject { TestModel.where(id: 1).odd }

    it do
      expect(subject.first.name).to eq('one')
    end
  end

  describe 'scope then where' do
    subject { TestModel.odd.where(id: 1) }

    it do
      expect(subject.first.name).to eq('one')
    end
  end

  describe 'disjoint scopes' do
    subject { TestModel.odd.even }

    it do
      expect(subject.all).to eq([])
    end
  end

  describe 'when source given as array' do
    subject { TestMessage.first }

    it do
      expect(subject.id).to eq(1)
    end
  end
end
