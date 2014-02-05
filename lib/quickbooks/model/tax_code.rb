module Quickbooks
  module Model
    class TaxCode < BaseModel
      XML_COLLECTION_NODE = "TaxCode"
      XML_NODE = "TaxCode"
      REST_RESOURCE = "taxcode"

      # NB: TaxCodeRef Id can be one of the following:
      #       TAX - A special code ID.
      #       NON - A special code ID indicating non-taxable
      #       CustomSalesTax - Indicating a custom sales tax on the line
      #       Integer - An integer of the custom tax ID
      xml_accessor :id, :from => "Id"
      xml_accessor :sync_token, :from => "SyncToken", :as => Integer
      xml_accessor :meta_data, :from => "MetaData", :as => MetaData
      xml_accessor :name, :from => "Name"
      xml_accessor :description, :from => "Description"
      xml_accessor :active?, :from => "Active"
      xml_accessor :taxable?, :from => "Taxable"
      xml_accessor :tax_group?, :from => "TaxGroup"
      xml_accessor :sales_tax_rate_list, :from => "SalesTaxRateList", :as => SalesTaxRateList

    end
  end
end
