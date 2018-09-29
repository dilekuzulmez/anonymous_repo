require 'rails_helper'

RSpec.describe CreateRefQrJob, type: :job do
  describe 'generate QR code' do
    let!(:team) { create(:team) }
    let(:perform) { CreateRefQrJob.perform_now(5, 'MB', 'COURTSIDE', team.id) }

    it 'generate by home team & quantity defined' do
      perform
      expect(QrCode.where(home_team_id: team.id, ticket_type: 'COURTSIDE', channel: 'MB').count).to eq(5)
    end
  end
end
