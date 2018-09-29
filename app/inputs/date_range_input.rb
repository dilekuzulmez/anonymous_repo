class DateRangeInput < SimpleForm::Inputs::Base
  include ApplicationHelper

  def input(_wrapper_options)
    template.content_tag(:div, class: 'input-group input-daterange') do
      template.concat @builder.text_field("#{attribute_name}_start", input_html_options)
      template.concat to_addon

      template.concat @builder.text_field("#{attribute_name}_end", input_html_options)
    end
  end

  def input_html_options
    super.merge(class: 'form-control')
  end

  def to_addon
    template.content_tag(:div, class: 'input-group-addon') do
      'to'
    end
  end
end
