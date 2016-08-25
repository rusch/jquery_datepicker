require 'app/helpers/form_helper'

module JqueryDatepicker
  module DatepickerHelper

    include JqueryDatepicker::FormHelper
    include JqueryDatepicker::InputTagHelper

    # Helper method that creates a datepicker input field
    def date_input_tag(name, value = nil, options = {}, with_time = nil)
      tag_options, jquery_options = separate_tag_and_jquery_options(options)
      tag_options[:id] ||= sanitize_to_id(name)

      # Format value
      value = format_date(value, jquery_options[:dateFormat], with_time)

      # Render field
      jquery_method = with_time ? 'datepicker' : 'datetimepicker'
      html = text_field_tag(name, value, tag_options);
      html += javascript_tag(
        '$(document).ready(function () { $("input#%s").%s(%s); });' %
        [ tag_options[:id], jquery_method, jquery_options.to_json ]
      )
      html.html_safe
    end

    def datetime_input_tag(name, value = nil, options = {})
      datepicker_input(name, value, options, true)
    end

    alias :datepicker_input, :date_input_tag
    alias :datetime_picker_input, :datetime_input_tag
  end

end
