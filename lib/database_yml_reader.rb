# Reads the Rails +database.yml+ configuration file and provides access to its
# data structures.
#
# Structure:
# * username
# * database
#
# Examples:
#
#   struct = DatabaseYmlReader.read
#   puts struct.username
class DatabaseYmlReader
  require 'erb'
  require 'yaml'
  require 'ostruct'

  def self.read
    OpenStruct.new(
      YAML.load(
        ERB.new(
          File.read(
            File.join(RAILS_ROOT, "config", "database.yml"))).result)[RAILS_ENV])
  end
end
