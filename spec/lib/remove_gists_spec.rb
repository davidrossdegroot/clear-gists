require 'remove_gists'

describe RemoveGists do
  let(:token) { 'test_token' }
  let(:gist_deleter) { described_class.new(token) }
  let(:gists_url) { 'https://api.github.com/gists' }
  let(:gist_response) do
    [{
      "files" => {
        "Can u type your question iOS Note" => {}
      }
    }]
  end

  before do
    stub_request(:get, gists_url)
      .with(headers: { 'Authorization' => "Bearer #{token}" })
      .to_return(
        status: 200,
        body: [
          { id: '123', files: { "Note iOS Note": {} } },
          { id: '456', files: { "Note Bing": {} } },
          { id: '789', files: { "Note Bang": {} } }
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
    it 'retrieves the list of gists with "iOS Note" in the name' do
      gists = gist_deleter.fetch_gists
      expect(gists).to eq([{"files" => {"Note iOS Note" => {}}, "id" => "123"}])
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
