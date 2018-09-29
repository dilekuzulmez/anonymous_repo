# == Schema Information
#
# Table name: admins
#
#  id                 :integer          not null, primary key
#  email              :string           not null
#  uid                :string
#  provider           :string
#  first_name         :string
#  last_name          :string
#  profile_image_url  :string
#  sign_in_count      :integer          default(0), not null
#  current_sign_in_at :datetime
#  last_sign_in_at    :datetime
#  current_sign_in_ip :inet
#  last_sign_in_ip    :inet
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  created_by_id      :integer
#  employee_token     :string
#  token_expire       :datetime
#
# Indexes
#
#  index_admins_on_created_by_id  (created_by_id)
#  index_admins_on_email          (email) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (created_by_id => admins.id)
#

require 'rails_helper'

RSpec.describe Admin, type: :model do
  subject(:admin) { create(:admin) }

  it { is_expected.to validate_presence_of :email }
  it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
  it { is_expected.to have_many :unread_notifications }

  describe '#unread_notifications' do
    before do
      create_list(:notification, 5, admin: admin)
      create_list(:notification, 2, admin: admin, viewed_at: Time.now)
    end

    it 'returns 5 notifications' do
      expect(admin.unread_notifications.length).to eq(5)
    end
  end

  describe '#update_from_oauth' do
    let(:admin) { create(:admin) }
    let(:auth) { OmniAuth::AuthHash.new(Faker::Omniauth.google) }

    before do
      admin.update_from_oauth(auth)
    end

    it 'updates first_name' do
      expect(admin.first_name).to eq(auth.info.first_name)
    end

    it 'updates last_name' do
      expect(admin.last_name).to eq(auth.info.last_name)
    end

    it 'updates profile_image_url' do
      expect(admin.profile_image_url).to eq(auth.info.image)
    end

    it 'updates uid' do
      expect(admin.uid).to eq(auth.uid)
    end

    it 'updates provider' do
      expect(admin.provider).to eq(auth.provider)
    end
  end

  describe '#created_by' do
    let!(:creator) { create(:admin) }
    let!(:child) { create(:admin, created_by_id: creator.id) }

    it 'returns creator when call created_by on child' do
      expect(child.created_by).to eq(creator)
    end
  end

  describe '#name' do
    let(:admin) { build(:admin, first_name: 'Foo', last_name: 'Bar') }

    it 'returns full name' do
      expect(admin.name).to eq('Foo Bar')
    end
  end

  describe '#activated?' do
    context 'when uid is nil' do
      let(:admin) { build(:admin, uid: nil) }

      it 'returns false' do
        expect(admin).not_to be_activated
      end
    end

    context 'when uid is not nil' do
      let(:admin) { build(:admin) }

      it 'returns true' do
        expect(admin).to be_activated
      end
    end
  end
end
