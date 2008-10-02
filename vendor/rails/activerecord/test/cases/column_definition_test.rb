require "cases/helper"

class ColumnDefinitionTest < ActiveRecord::TestCase
  def setup
    @adapter = ActiveRecord::ConnectionAdapters::AbstractAdapter.new(nil)
    def @adapter.native_database_types
      {:string => "varchar"}
    end
  end

  # Avoid column definitions in create table statements like:
<<<<<<< HEAD:vendor/rails/activerecord/test/cases/column_definition_test.rb
  # `title` varchar(255) DEFAULT NULL
=======
  # `title` varchar(255) DEFAULT NULL NULL
>>>>>>> i18n:vendor/rails/activerecord/test/cases/column_definition_test.rb
  def test_should_not_include_default_clause_when_default_is_null
    column = ActiveRecord::ConnectionAdapters::Column.new("title", nil, "varchar(20)")
    column_def = ActiveRecord::ConnectionAdapters::ColumnDefinition.new(
      @adapter, column.name, "string",
      column.limit, column.precision, column.scale, column.default, column.null)
<<<<<<< HEAD:vendor/rails/activerecord/test/cases/column_definition_test.rb
    assert_equal "title varchar(20)", column_def.to_sql
=======
    assert_equal "title varchar(20) NULL", column_def.to_sql
>>>>>>> i18n:vendor/rails/activerecord/test/cases/column_definition_test.rb
  end

  def test_should_include_default_clause_when_default_is_present
    column = ActiveRecord::ConnectionAdapters::Column.new("title", "Hello", "varchar(20)")
    column_def = ActiveRecord::ConnectionAdapters::ColumnDefinition.new(
      @adapter, column.name, "string",
      column.limit, column.precision, column.scale, column.default, column.null)
<<<<<<< HEAD:vendor/rails/activerecord/test/cases/column_definition_test.rb
    assert_equal %Q{title varchar(20) DEFAULT 'Hello'}, column_def.to_sql
=======
    assert_equal %Q{title varchar(20) DEFAULT 'Hello' NULL}, column_def.to_sql
>>>>>>> i18n:vendor/rails/activerecord/test/cases/column_definition_test.rb
  end

  def test_should_specify_not_null_if_null_option_is_false
    column = ActiveRecord::ConnectionAdapters::Column.new("title", "Hello", "varchar(20)", false)
    column_def = ActiveRecord::ConnectionAdapters::ColumnDefinition.new(
      @adapter, column.name, "string",
      column.limit, column.precision, column.scale, column.default, column.null)
    assert_equal %Q{title varchar(20) DEFAULT 'Hello' NOT NULL}, column_def.to_sql
  end
<<<<<<< HEAD:vendor/rails/activerecord/test/cases/column_definition_test.rb
end
=======
end
>>>>>>> i18n:vendor/rails/activerecord/test/cases/column_definition_test.rb
