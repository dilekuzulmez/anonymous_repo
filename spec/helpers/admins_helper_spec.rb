require 'rails_helper'

describe AdminsHelper do
  describe 'show_admin_custom_hash' do
    let!(:creator) { create(:admin) }
    let!(:child) { create(:admin, created_by_id: creator.id) }

    context 'has creator' do
      it 'returns hash with link to creator show page' do
        hash = helper.show_admin_custom_hash(child)
        link = link_to(creator.name, admin_path(id: creator.id))
        expect(hash[:created_by]).to eq(link)
      end
    end

    context 'dont have creator' do
      it 'returns hash with N/A' do
        hash = helper.show_admin_custom_hash(creator)
        expect(hash[:created_by]).to eq('N/A')
      end
    end
  end

  describe 'profile_image_url_of' do
    let(:admin) { create(:admin, profile_image_url: '') }

    it 'always return url' do
      expect(helper.profile_image_url_of(admin)).not_to be_empty
    end
  end
end
