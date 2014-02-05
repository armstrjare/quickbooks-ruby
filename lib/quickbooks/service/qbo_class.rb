module Quickbooks
  module Service
    class QboClass < BaseService
      include ServiceCrud

      def delete(qbo_class)
        qbo_class.active = false
        update(qbo_class, :sparse => true)
      end

      private

      def default_model_query
        "SELECT * FROM Class"
      end

      def model
        Quickbooks::Model::QboClass
      end
    end
  end
end

