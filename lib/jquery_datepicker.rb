# JqueryDatepicker
require 'action_view/helpers'
require "app/helpers/datepicker_helper"
require "app/helpers/form_helper"

module JqueryDatepicker
  class Railtie < Rails::Railtie
    initializer "JqueryDatepicker" do
      # ActionController::Base.helper(JqueryDatepicker::DatepickerHelper)
      ActionView::Helpers::InstanceTag.send(:include, JqueryDatepicker::InstanceTag)
      ActionView::Helpers::FormHelper.send(:include, JqueryDatepicker::FormHelper)
      ActionView::Base.send(:include, JqueryDatepicker::DatepickerHelper)
     ActionView::Helpers::FormBuilder.send(:include, JqueryDatepicker::FormBuilder)
    end
  end
end
