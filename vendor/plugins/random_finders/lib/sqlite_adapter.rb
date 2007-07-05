module ActiveRecord
  module ConnectionAdapters 
    class SQLiteAdapter < AbstractAdapter
      
      def random_function
        'random()'
      end
      
    end
  end
end
