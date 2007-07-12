require File.dirname(__FILE__) + '/spec_helper'

describe Gecode::FreeSetVar, '(not assigned)' do
  before do
    model = Gecode::Model.new
    @var = model.set_var(0..3, 0..4)
  end
  
  it 'should not be assigned' do
    @var.should_not be_assigned
  end
  
  it 'should give glb and lub ranges when inspecting' do
    @var.inspect.should include('lub-range')
    @var.inspect.should include('glb-range')
  end
  
  it 'should report the correct bounds' do
    @var.glb.sort.should == (0..3).to_a
    @var.lub.sort.should == (0..4).to_a
  end
end

describe Gecode::FreeSetVar, '(assigned)' do
  before do
    model = Gecode::Model.new
    @var = model.set_var([1], [1])
    model.solve!
  end
  
  it 'should be assigned' do
    @var.should be_assigned
  end
  
  it 'should include the assigned elements' do
    @var.should include(1)
    @var.should_not include(0)
  end
  
  it "should give it's value when inspecting" do
    @var.inspect.should include('1..1')
    @var.inspect.should_not include('lub-range')
  end
  
  it 'should report the correct bounds' do
    @var.lub.should == [1]
    @var.glb.should == [1]
  end
end
