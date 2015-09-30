shared_context :comply_with_hateoas do |params = {id: 1, format: :json}|
  before do
    request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials('name', 'password')
    allow(User).to receive(:find_by_name).and_return(double(authenticate: true))
  end
  
  it 'should reply with HAL-like structure on index' do
    get :index, params.reject { |k, v| k == :id }

    expect(response.body).to include '"links":'
  end

  it 'should reply with HAL-like structure on show' do
    get :index, params.reject { |k, v| k == :id }

    expect(response.body).to include '"links":'
    expect(response.body).to include '"embedded":'
  end
end
