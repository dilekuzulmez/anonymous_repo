class RemoveNotUseColumnsAndTable < ActiveRecord::Migration[5.1]
  def up
    remove_column :customers, :access_token
    remove_column :customers, :profile_image_url
    remove_column :customers, :point
    remove_column :customers, :referral_code
    remove_column :customers, :invitor_code
    remove_column :customers, :push_token
    remove_column :customers, :favorite_team_id
    remove_column :promotions, :is_season
    remove_column :seasons, :season_ticket_team_ids
    remove_column :seasons, :league_id
    remove_column :seasons, :amount_matches
    remove_column :teams, :payment_info_vi
    remove_column :teams, :payment_info_en
    remove_column :teams, :color_1
    remove_column :teams, :color_2
    remove_column :zones, :gate_id
    remove_column :ticket_types, :benefit
    remove_column :promotions, :ticket_types
    remove_column :orders, :is_season
    remove_column :orders, :kind
    remove_column :orders, :order_code
    remove_column :orders, :payment_type
    remove_column :orders, :project_type
    remove_column :orders, :commission_rate
    remove_column :orders, :bundle_additional_id
    remove_column :orders, :seat_ids
    remove_column :orders, :match_id
    remove_column :matches, :seat_selection
    remove_attachment :stadiums, :seatmap
    remove_attachment :stadiums, :logo  
    remove_attachment :zones, :image  
    remove_attachment :teams, :banner
    drop_table :advertisements
    drop_table :bundle_additionals
    drop_table :campaigns
    drop_table :combos_matches
    drop_table :combos
    drop_table :conversion_rates
    drop_table :csv_files
    drop_table :gates
    drop_table :history_points
    drop_table :identities
    drop_table :images
    drop_table :leagues
    drop_table :loyalty_point_rules
    drop_table :noti_histories
    drop_table :notifications
    drop_table :push_notifications
    drop_table :qr_codes
    drop_table :surveys
    drop_table :versions
    add_column :order_details, :expired_at, :datetime
    add_column :order_details, :hash_key, :string
    add_column :order_details, :is_qr_used, :boolean, default: false
    add_column :order_details, :qr_code_file_name, :string
  end

  def down
  end
end
