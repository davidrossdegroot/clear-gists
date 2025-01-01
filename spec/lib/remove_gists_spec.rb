require 'remove_gists'

describe RemoveGists do
  it 'works' do
    expect { RemoveGists.perform }.to_not raise_error
  end

  let(:token) { 'test_token' }
  let(:gist_deleter) { described_class.new(token) }
  let(:gists_url) { 'https://api.github.com/gists' }

  before do
    stub_request(:get, gists_url)
      .with(headers: { 'Authorization' => "Bearer #{token}" })
      .to_return(
        status: 200,
        body: [
          { id: '123' },
          { id: '456' },
          { id: '789' }
        ].to_json
      )

    stub_request(:delete, "#{gists_url}/123")
      .with(headers: { 'Authorization' => "Bearer #{token}" })
      .to_return(status: 204)

    stub_request(:delete, "#{gists_url}/456")
      .with(headers: { 'Authorization' => "Bearer #{token}" })
      .to_return(status: 204)

    stub_request(:delete, "#{gists_url}/789")
      .with(headers: { 'Authorization' => "Bearer #{token}" })
      .to_return(status: 204)
  end

  describe '#fetch_gists' do
    it 'retrieves the list of gists' do
      gists = gist_deleter.fetch_gists
      expect(gists).to eq([{ 'id' => '123' }, { 'id' => '456' }, { 'id' => '789' }])
    end

    it 'only gets the gists with "iOS Note" in the name' do
      
    end
  end

  describe '#delete_gist' do
    it 'deletes a gist successfully' do
      result = gist_deleter.delete_gist('123')
      expect(result).to be true
    end
  end

  describe '#bulk_delete' do
    it 'deletes all gists successfully' do
      gist_deleter.bulk_delete
      expect(WebMock).to have_requested(:delete, "#{gists_url}/123").once
      expect(WebMock).to have_requested(:delete, "#{gists_url}/456").once
      expect(WebMock).to have_requested(:delete, "#{gists_url}/789").once
    end
  end
end
