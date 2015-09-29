require 'spec_helper'
require 'rails_helper'

describe ReviewCollectionDecorator do
  it 'should enrich json representation with hateoas links' do
    subject = ReviewCollectionDecorator.decorate [Review.new(id: 1)]

    expect(subject.as_json).to include(:links)
  end
end
