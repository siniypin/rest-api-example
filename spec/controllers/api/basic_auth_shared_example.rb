shared_context :basic_auth do |params = {id: 1, format: :json}|
  context 'when no credentials provided' do
    it 'should reply with 401' do
      get :show, params, format: :json

      expect(response).to have_http_status :unauthorized
    end

    it 'should set WWW-Authenticate header' do #NOTE: a bit of framework testing for learning purposes
      get :show, params

      expect(response.headers['WWW-Authenticate']).not_to be_nil
    end
  end

  context 'when invalid credentials provided' do
    before do
      request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials('name', 'password')
      allow(User).to receive(:find_by_name).and_return(nil)
    end

    it 'should reply with 401' do
      get :show, params

      expect(response).to have_http_status :unauthorized
    end

    it 'should set WWW-Authenticate header' do
      get :show, params

      expect(response.headers['WWW-Authenticate']).not_to be_nil
    end
  end

  context 'valid credentials provided' do
    it 'should reply with 200' do
      request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials('name', 'password')
      allow(User).to receive(:find_by_name).and_return(double(authenticate: true))

      get :show, params

      expect(response).to have_http_status :ok
    end
  end
end
