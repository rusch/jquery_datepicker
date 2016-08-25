require 'date'

# Being added to ActionView::Helpers::FormHelper
module JqueryDatepicker

  module FormHelper

    def datetime_input(object_name, method, options = {})
      date_input(object_name, method, options, true)
    end

    def date_input(object_name, method, options = {}, with_time = false)
      jquery_options = options.symbolize_keys
      tag_options = jquery_options.slice!(*jquery_datepicker_option_names)

      tag = ActionView::Helpers::InstanceTag.new(
        object_name, method, self, tag_options.delete(:object))
      tag.to_date_input_tag(options, with_time)
    end

  end

end

# Being added to ActionView::Helpers::FormBuilder
module JqueryDatepicker::FormBuilder
  def datetime_input(method, options = {})
    @template.datetime_input(@object_name, method, objectify_options(options))
  end

  def date_input(method, options = {})
    @template.date_input(@object_name, method, objectify_options(options))
  end
end

module JqueryDatepicker::InputTagHelper
    private

    def separate_tag_and_jquery_options(options)
      jquery_options = options.symbolize_keys # creates a shallow copy
      tag_options = jquery_options.slice!(*jquery_datepicker_option_names)

      # Set default date formatter if none is given.
      unless jquery_options.key?(:dateFormat)
        jquery_options[:dateFormat] = 'yy-mm-dd'
      end

      return [tag_options, jquery_options]
    end

    def format_replacements
      {
        'yy' => '%Y',
        'mm' => '%m',
        'dd' => '%d',
        'd'  => '%-d',
        'm'  => '%-m',
        'y'  => '%y',
        'M'  => '%b'
      }
    end

    def jquery_datepicker_option_names
      [
        :altField, :altFormat, :appendText, :autoSize, :buttonImage,
        :buttonImageOnly, :buttonText, :calculateWeek, :changeMonth,
        :changeYear, :closeText, :constrainInput, :currentText,
        :dateFormat, :dayNames, :dayNamesMin, :dayNamesShort,
        :defaultDate, :disabled, :duration, :firstDay, :gotoCurrent,
        :hideIfNoPrevNext, :isRTL, :maxDate, :minDate, :monthNames,
        :monthNamesShort, :navigationAsDateFormat, :nextText,
        :numberOfMonths, :prevText, :selectOtherMonths,
        :shortYearCutoff, :showAnim, :showButtonPanel,
        :showCurrentAtPos, :showMonthAfterYear, :showOn, :showOptions,
        :showOtherMonths, :showWeek, :stepMonths, :weekHeader,
        :yearRange, :yearSuffix
      ]
    end

    def format_date(value, jquery_date_format, with_time = false)
      if value.blank?
        return ""
      end

      strftime_format = translate_format(jquery_date_format)
      strftime_format += " %R" if with_time

      if value.is_a?(Date) || value.is_a?(Time)
        return value.strftime(strftime_format)
      end

      # Try to parse given string.
      begin
        if include_time
          Time.parse(value)
        else
          Date.parse(value)
        end.strftime(strftime_format)
      rescue
        value
      end
    end

    def translate_format(format)
      format.gsub(/#{format_replacements.keys.join("|")}/) do |match|
        format_replacements[match]
      end
    end
end

module JqueryDatepicker::InstanceTag
  include JqueryDatepicker::InputTagHelper

  def to_date_input_tag(options = {}, with_time = false)
    tag_options, jquery_options = separate_tag_and_jquery_options(options)
    jquery_method = with_time ? 'datepicker' : 'datetimepicker'
    html = to_input_field_tag('text', tag_options)
    html += sprintf(
      '<script type="text/javascript">$(document).ready(function () { $("input#%s").%s(%s); });</script>',
      tag_id, jquery_method, jquery_options.to_json
    ).html_safe
  end

end
