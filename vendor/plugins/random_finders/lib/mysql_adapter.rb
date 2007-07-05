module ActiveRecord
  module ConnectionAdapters 
    class MysqlAdapter < AbstractAdapter
      
      def random_function
        'rand()'
      end
      
    end
  end
end
