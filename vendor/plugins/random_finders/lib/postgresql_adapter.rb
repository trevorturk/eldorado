module ActiveRecord
  module ConnectionAdapters 
    class PostgresqlAdapter < AbstractAdapter
      
      def random_function
        'random()'
      end
      
    end
  end
end
