module RailsWangeditor
  module SimpleForm
    class WangeditorInput < ::SimpleForm::Inputs::Base
      def input
        @builder.wangeditor(attribute_name, input_html_options)
      end
    end
  end
end

::SimpleForm::FormBuilder.map_type :wangeditor, :to => RailsWangeditor::SimpleForm::WangeditorInput