require 'spec_helper'
require 'rails_helper'

describe ReviewDecorator do
  it 'should enrich json representation with hateoas links' do
    subject = ReviewDecorator.decorate OpenStruct.new(id: 1)

    expect(subject.as_json).to include(:links)
  end
end
