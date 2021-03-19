require 'rails_helper'

describe AuthenticationTokenService do
  describe '.call' do
    let(:user) { create(:user) }
    let(:token) { described_class.call(user.id) }
    it 'should return an authentication token' do
      decoded_token = JWT.decode(
        token, described_class::HMAC_SECRET,
        true,
        { algorithm: described_class::ALGORITHM_TYPE }
      )

      expect(decoded_token).to eq(
        [
          { 'user_id' => user.id },
          { 'alg' => 'HS256' }
        ]
      )
    end
  end
end
