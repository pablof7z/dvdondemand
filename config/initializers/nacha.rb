require 'ach'

ACH.load_config(YAML.load(File.read(File.join(RAILS_ROOT, 'config', 'nacha.yml'))))
