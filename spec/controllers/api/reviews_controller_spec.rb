require 'spec_helper'
require 'rails_helper'

describe Api::ReviewsController, type: :controller do
  it_should_behave_like :basic_auth
end
