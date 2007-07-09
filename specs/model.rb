require File.dirname(__FILE__) + '/spec_helper'

describe Gecode::Model, ' (integer creation)' do
  before do
    @model = Gecode::Model.new
  end

  it 'should allow the creation of int variables with range' do
    range = 0..3
    @model.int_var(range).should have_domain(range)
  end
  
  # This currently fails, see specs/int_var for an explanation.
  it 'should allow the creation of int variables with non-range domains' do
    domain = [1, 3, 5]
    @model.int_var(*domain).should have_domain(domain)
  end
  
  it 'should allow the creation of int variables with single element domains' do
    domain = 3
    @model.int_var(domain).should have_domain([domain])
  end
  
  it 'should not accept empty domains' do
    lambda{ @model.int_var }.should raise_error(ArgumentError)
    lambda{ @model.int_var_array(1) }.should raise_error(ArgumentError)
  end
  
  it 'should allow the creation of int-var arrays with range domains' do
    range = 0..3
    count = 5
    vars = @model.int_var_array(count, range)
    vars.size.should equal(count)
    vars.each{ |var| var.should have_domain(range) }
  end
  
  it 'should allow the creation of int-var arrays with non-range domains' do
    domain = [1,3,5]
    count = 5
    vars = @model.int_var_array(count, *domain)
    vars.size.should equal(count)
    vars.each{ |var| var.should have_domain(domain) }
  end
  
  it 'should allow the creation of int-var matrices with range domains' do
    range = 0..3
    rows = 5
    columns = 4
    vars = @model.int_var_matrix(rows, columns, range)
    vars.row_size.should equal(rows)
    vars.column_size.should equal(columns)
    vars.each{ |var| var.should have_domain(range) }
  end
  
  it 'should allow the creation of int-var matrices with non-range domains' do
    domain = [1,3,5]
    rows = 5
    columns = 4
    vars = @model.int_var_matrix(rows, columns, *domain)
    vars.row_size.should equal(rows)
    vars.column_size.should equal(columns)
    vars.each{ |var| var.should have_domain(domain) }
  end
end

describe Gecode::Model, ' (bool creation)' do
  before do
    @model = Gecode::Model.new
  end

  it 'should allow the creation of boolean variables' do
    @model.bool_var.should_not be_nil
  end
  
  it 'should allow the creation of arrays of boolean variables' do
    @model.bool_var_array(3).size.should equal(3)
  end
  
  it 'should allow the creation of matrices of boolean variables' do
    matrix = @model.bool_var_matrix(3, 4)
    matrix.row_size.should equal(3)
    matrix.column_size.should equal(4)
  end
end

describe Gecode::Model, ' (set creation)' do
  before do
    @model = Gecode::Model.new
    @glb_range = 0..3
    @lub_range = 3..5
    @glb_enum = [0, 3]
    @lubb_enum = [3, 5]
  end

  it 'should allow the creation of set variables with range' do
    @model.set_var(@glb_range, @lub_range).should have_bounds(@glb_range, 
      @lub_range) 
  end
end