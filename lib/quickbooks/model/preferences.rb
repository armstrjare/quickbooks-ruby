module Quickbooks
  module Model
    class Preferences < BaseModel
      XML_COLLECTION_NODE = "Preferences"
      XML_NODE            = "Preferences"
      REST_RESOURCE       = 'preferences'

      xml_name XML_NODE

      def self.create_preference_class(*attrs, &block)
        ::Class.new(BaseModel) do
          attrs.each do |a|
            xml_reader(a.underscore, :from => a.gsub("?", ""))
          end
          instance_eval(&block) if block_given?
        end
      end

      PREFERENCE_SECTIONS = {
        :accounting_info      => %w(TrackDepartments DepartmentTerminology ClassTrackingPerTxnLine? ClassTrackingPerTxn? CustomerTerminology),
        :product_and_services => %w(ForSales? ForPurchase? QuantityWithPriceAndRate? QuantityOnHand?),
        :sales_forms          => %w(CustomTxnNumbers? AllowDeposit? AllowDiscount? DefaultDiscountAccount? AllowEstimates? EstimateMessage? 
                                                ETransactionEnabledStatus? ETransactionAttachPDF? ETransactionPaymentEnabled? IPNSupportEnabled? 
                                                AllowServiceDate? AllowShipping? DefaultShippingAccount? DefaultTerms DefaultCustomerMessage),
        :vendor_and_purchase  => %w(TrackingByCustomer? BillableExpenseTracking? DefaultTerms? DefaultMarkup? POCustomField),
        :time_tracking        => %w(UseServices? BillCustomers? ShowBillRateToAll WorkWeekStartDate MarkTimeEntiresBillable?),
        :tax                  => %w(UsingSalesTax?),
        :currency             => %w(MultiCurrencyEnabled? HomeCurrency),
        :report               => %w(ReportBasis)
      }

      xml_reader :sales_forms, :from => "SalesFormsPrefs", :as => create_preference_class(*PREFERENCE_SECTIONS.delete(:sales_forms)) {
        xml_reader :custom_fields, :as => [::Class.new(BaseModel) {
          xml_name 'CustomField'
          xml_accessor :name, :from => 'Name'
          xml_accessor :type, :from => 'Type'
          xml_accessor :string_value, :from => 'StringValue'
          xml_accessor :boolean_value, :from => 'BooleanValue'
          xml_accessor :date_value, :from => 'DateValue', :as => Date
          xml_accessor :number_value, :from => 'NumberValue', :as => Integer

          def value
            case type
            when 'BooleanType' then boolean_value == 'true'
            when 'StringType' then string_value
            when 'DateType' then date_value
            when 'NumberType' then number_value
            end
          end
        }], :from => 'CustomField', in: 'CustomField'
      }

      PREFERENCE_SECTIONS.each do |section_name, fields|
        xml_reader section_name, :from => "#{section_name}_prefs".camelize, :as => create_preference_class(*fields)
      end

      EmailMessage          = create_preference_class("Subject", "Message")
      EmailMessageContainer = create_preference_class do
        %w(InvoiceMessage EstimateMessage SalesReceiptMessage StatementMessage).each do |msg|
          xml_reader msg.underscore, :from => msg, :as => EmailMessage
        end
      end

      xml_reader :email_messages, :from => "EmailMessagesPrefs", as: EmailMessageContainer

      xml_reader :other_prefs, :from => "OtherPrefs/NameValue", :as => { :key => "Name", :value => "Value" }
    end

  end
end
