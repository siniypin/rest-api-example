require 'spec_helper'
require 'rails_helper'

describe Api::ReviewsController, type: :controller do
  it_should_behave_like :basic_auth
  it_should_behave_like :accept_json_mime
end
