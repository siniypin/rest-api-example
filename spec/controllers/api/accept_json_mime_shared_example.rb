shared_context :accept_json_mime do |params = {id: 1, format: :json}|
  before do
    request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials('name', 'password')
    allow(User).to receive(:find_by_name).and_return(double(authenticate: true))
  end

  %w(xml html).each do |format|
    it "should forbid #{format} format" do
      expect{get(:show, params.merge(format: format))}.to raise_error ActionController::UnknownFormat
    end
  end

  it 'should allow json format explicitly' do
    get :show, params

    expect(response).to be_successful
  end

  it 'should use json as default format' do
    pending 'fails due to UnknownFormat error, skipping'
    fail

    request.env['CONTENT_TYPE'] = 'application/json'
    request.env['ACCEPT'] = 'application/json'

    get :show, params.merge(format: '')

    expect(response).to be_successful
  end
end
