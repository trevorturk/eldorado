require 'test_helper'

class FixtureValidationTest < ActionController::IntegrationTest

  def test_fixtures_should_be_valid
    models = Fixtures.all_loaded_fixtures.keys
    models.each do |model|
      model = model.camelize.singularize.constantize
      fixtures = model.find(:all)
      fixtures.each do |fixture|
        if !fixture.valid?
          puts; puts "WARNING: Invalid fixture: #{fixture.inspect}"
        end
        assert fixture.valid?
      end
    end
  end
end
