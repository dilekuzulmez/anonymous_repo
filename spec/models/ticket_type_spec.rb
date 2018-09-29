# == Schema Information
#
# Table name: ticket_types
#
#  id         :integer          not null, primary key
#  match_id   :integer          not null
#  zone_id    :integer
#  quantity   :integer          not null
#  code       :string           not null
#  slug       :string
#  price      :decimal(, )      default(0.0), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  class_type :integer          default(NULL), not null
#
# Indexes
#
#  index_ticket_types_on_match_id           (match_id)
#  index_ticket_types_on_match_id_and_code  (match_id,code) UNIQUE
#  index_ticket_types_on_slug               (slug) UNIQUE
#  index_ticket_types_on_zone_id            (zone_id)
#
# Foreign Keys
#
#  fk_rails_...  (match_id => matches.id)
#  fk_rails_...  (zone_id => zones.id)
#

require 'rails_helper'

RSpec.describe TicketType, type: :model do
  subject { create(:ticket_type) }

  it { is_expected.to belong_to :match }
  it { is_expected.to belong_to :zone }

  it { is_expected.to validate_presence_of(:code) }
  it { is_expected.to validate_uniqueness_of(:code).scoped_to(:match_id).case_insensitive }
  it { is_expected.to validate_presence_of(:price) }
  it { is_expected.to validate_numericality_of(:price).is_greater_than_or_equal_to(0) }
  it { is_expected.to validate_presence_of(:match) }
  it { is_expected.to validate_presence_of(:quantity) }
  it { is_expected.to validate_numericality_of(:quantity).only_integer.is_greater_than_or_equal_to(0) }
  it { is_expected.to normalize_attribute(:code).from('abc').to('ABC') }

  describe '.new_from_zone' do
    context 'zone is nil' do
      it 'raise error' do
        expect { TicketType.new_from_zone(nil) }.to raise_error(ArgumentError)
      end
    end

    context 'zone is not nil' do
      let(:zone) { create(:zone) }
      let(:ticket_type) { TicketType.new_from_zone(zone) }

      it 'inits new TicketType' do
        expect(ticket_type).not_to be_persisted
      end

      it 'copies info from zone' do
        { code: 'code', quantity: 'capacity', price: 'price' }.each_pair do |ticket_field, zone_field|
          expect(ticket_type.public_send(ticket_field)).to eq(zone.public_send(zone_field))
        end
      end
    end
  end
end
