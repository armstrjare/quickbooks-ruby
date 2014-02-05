module Quickbooks
  module Model
    class QboClass < BaseModel

      XML_COLLECTION_NODE = "Class"
      XML_NODE = "Class"
      REST_RESOURCE = 'class'

      xml_name 'Class'

      xml_accessor :id, :from => 'Id', :as => Integer
      xml_accessor :name, :from => 'Name'
      xml_accessor :active, :from => 'Active'

      def active?
        active == "true"
      end
    end
  end
end

