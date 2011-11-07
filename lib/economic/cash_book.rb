require 'economic/entity'

module Economic

  # Represents a cash book in E-conomic.
  #
  # API documentation: http://www.e-conomic.com/apidocs/Documentation/T_Economic_Api_ICashBook.html
  class CashBook < Entity
    has_properties :name, :number

    def handle
      Handle.new({:number => @number})
    end

    def entries
      CashBookEntryProxy.new(self)
    end

    protected

    def build_soap_data
      data = ActiveSupport::OrderedHash.new

      data['Handle'] = handle.to_hash
      data['Name'] = name
      data['Number'] = number

      return data
    end
  end
end
