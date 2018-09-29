module AdminsHelper
  def show_admin_custom_hash(admin)
    creator = admin.created_by
    name = creator.try(:name)
    value = name ? link_to(name, admin_path(id: creator.id)) : 'N/A'
    { created_by: value.html_safe }
  end

  def profile_image_url_of(admin)
    if admin.profile_image_url.blank?
      asset_path('profile.png')
    else
      admin.profile_image_url
    end
  end
end
