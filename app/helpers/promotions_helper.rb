module PromotionsHelper
  SUCCESS = 'success'.freeze
  DEFAULT = 'default'.freeze
  ACTIVE = 'active'.freeze
  INACTIVE = 'inactive'.freeze

  def active_tag(promotion)
    if promotion.active
      klass = SUCCESS
      content = ACTIVE
    else
      klass = DEFAULT
      content = INACTIVE
    end

    content_tag('span', class: "label label-#{klass}") { content }
  end
end
