module ZonesHelper
  def show_zone_custom_hash(zone)
    {
      gate: link_to(zone.gate_code, stadium_gate_path(zone.stadium, zone.gate)).html_safe,
      stadium: link_to(zone.stadium_name, stadium_path(zone.stadium)).html_safe,
      image: zone_image(zone)
    }
  end

  def zone_image(zone)
    image_tag(zone.image.url, size: '100') unless zone.image_file_name.nil?
  end
end
