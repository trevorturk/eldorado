module ActiveRecord
  module ConnectionAdapters 
    class AbstractAdapter
      
      def random_function
        raise ActiveRecord::StatementInvalid, "This database adapter does not have random support "
      end
      
    end
  end
end
