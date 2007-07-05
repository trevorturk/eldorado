module ActiveRecord
  class Base
  private    
    def self.add_order!(sql, order, scope = :auto)
      scope = scope(:find) if :auto == scope
      scoped_order = scope[:order] if scope
      
      order = connection.random_function if order == :random
      scoped_order = connection.random_function if scoped_order == :random
      
      if order
        sql << " ORDER BY #{order}"
        sql << ", #{scoped_order}" if scoped_order
      else
        sql << " ORDER BY #{scoped_order}" if scoped_order
      end
    end
  end
end
       