require File.dirname(__FILE__) + '/../spec_helper'
require File.dirname(__FILE__) + '/constraint_helper'

class BoolEnumSampleProblem < Gecode::Model
  attr :bools
  attr :b1
  attr :b2
  
  def initialize
    @bools = bool_var_array(4)
    @b1 = bool_var
    @b2 = bool_var
    branch_on @bools
    branch_on wrap_enum([@b1, @b2])
  end
end

describe Gecode::Constraints::BoolEnum, ' (conjunction)' do
  before do
    @model = BoolEnumSampleProblem.new
    @bools = @model.bools
    @b1 = @model.b1
    @b2 = @model.b2
    
    # For constraint option spec.
    @invoke_options = lambda do |hash| 
      @bools.conjunction.must_be.equal_to(true, hash) 
      @model.solve!
    end
    @expect_options = lambda do |strength, reif_var|
      Gecode::Raw.should_receive(:bool_and).once.with(@model.active_space, 
        an_instance_of(Gecode::Raw::BoolVarArray), 
        an_instance_of(Gecode::Raw::BoolVar), strength)
      unless reif_var.nil?
        Gecode::Raw.should_receive(:bool_eqv).once.with(@model.active_space, 
          an_instance_of(Gecode::Raw::BoolVar), reif_var.bind, true, strength)
      end
    end
  end
  
  it 'should handle being constrained to be true' do
    @bools.conjunction.must_be.true
    @model.solve!
    @bools.all?{ |b| b.true? }.should be_true
  end
  
  it 'should handle being constrained to be negated true' do
    @bools.conjunction.must_not_be.true
    @model.solve!
    @bools.any?{ |b| b.false? }.should be_true
  end
  
  it 'should handle being constrained to be false' do
    @bools.conjunction.must_be.false
    @model.solve!
    @bools.any?{ |b| b.false? }.should be_true
  end
  
  it 'should handle being constrained to be negated false' do
    @bools.conjunction.must_not_be.false
    @model.solve!
    @bools.all?{ |b| b.true? }.should be_true
  end
  
  it 'should handle being constrained to be equal to a variable' do
    @bools.conjunction.must_be == @b1
    @model.solve!
    @bools.all?{ |b| b.true? }.should == @b1.true?
  end
  
  it 'should handle being constrained to not be equal to a variable' do
    @bools.conjunction.must_not_be == @b1
    @model.solve!
    @bools.all?{ |b| b.true? }.should_not == @b1.true?
  end
  
  it 'should handle being constrained to be equal to be a nested expression' do
    @bools.conjunction.must_be == (@b1 | @b2) & @b1
    @model.solve!
    @bools.all?{ |b| b.true? }.should == (@b1.true? | @b2.true?) & @b1.true?
  end
  
  it 'should handle being constrained to not be equal to be a nested expression' do
    @bools.conjunction.must_not_be == (@b1 | @b2) & @b1
    @model.solve!
    @bools.all?{ |b| b.true? }.should_not == (@b1.true? | @b2.true?) & @b1.true?
  end

  it_should_behave_like 'constraint with options'
end  
