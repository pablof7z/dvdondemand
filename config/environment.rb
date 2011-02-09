# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.9' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.

  # Add additional load paths for your own custom dirs
  # config.autoload_paths += %W( #{RAILS_ROOT}/extras )

  # Specify gems that this application depends on and have them installed with rake gems:install
  # config.gem "hpricot", :version => '0.6', :source => "http://code.whytheluckystiff.net"
  # config.gem "sqlite3-ruby", :lib => "sqlite3"
  # config.gem "aws-s3", :lib => "aws/s3"
  config.gem "activemerchant"
  config.gem "acts-as-taggable-on"
  config.gem "devise"
  config.gem 'csv_builder'
  config.gem "haml"
  config.gem 'googlecharts', :lib => 'gchart'
  config.gem "inherited_resources"
  config.gem 'mime-types', :lib => "mime/types"
  config.gem "paperclip"
  config.gem 'vestal_versions'
  config.gem 'will_paginate'

  # Only load the plugins named here, in the order given (default is alphabetical).
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Skip frameworks you're not going to use. To use Rails without a database,
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Activate observers that should always be running
  config.active_record.observers = :sale_observer

  # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
  # Run "rake -D time" for a list of tasks for finding time zone names.
  config.time_zone = 'UTC'

  # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
  # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
  # config.i18n.default_locale = :de
end

# overwrite country_select plugin to allow 2-letter country CODES
# COUNTRIES constant thanks to http://harryche2008.wordpress.com/2009/02/17/ruby-code-to-convert-country-name-to-2-letter-code/
ActionView::Helpers::FormOptionsHelper::COUNTRIES = {
  'AF'=>'Afghanistan',
  'AL'=>'Albania',
  'DZ'=>'Algeria',
  'AS'=>'American Samoa',
  'AD'=>'Andorra',
  'AO'=>'Angola',
  'AI'=>'Anguilla',
  'AQ'=>'Antarctica',
  'AG'=>'Antigua And Barbuda',
  'AR'=>'Argentina',
  'AM'=>'Armenia',
  'AW'=>'Aruba',
  'AU'=>'Australia',
  'AT'=>'Austria',
  'AZ'=>'Azerbaijan',
  'BS'=>'Bahamas',
  'BH'=>'Bahrain',
  'BD'=>'Bangladesh',
  'BB'=>'Barbados',
  'BY'=>'Belarus',
  'BE'=>'Belgium',
  'BZ'=>'Belize',
  'BJ'=>'Benin',
  'BM'=>'Bermuda',
  'BT'=>'Bhutan',
  'BO'=>'Bolivia',
  'BA'=>'Bosnia And Herzegovina',
  'BW'=>'Botswana',
  'BV'=>'Bouvet Island',
  'BR'=>'Brazil',
  'IO'=>'British Indian Ocean Territory',
  'BN'=>'Brunei',
  'BG'=>'Bulgaria',
  'BF'=>'Burkina Faso',
  'BI'=>'Burundi',
  'KH'=>'Cambodia',
  'CM'=>'Cameroon',
  'CA'=>'Canada',
  'CV'=>'Cape Verde',
  'KY'=>'Cayman Islands',
  'CF'=>'Central African Republic',
  'TD'=>'Chad',
  'CL'=>'Chile',
  'CN'=>'China',
  'CX'=>'Christmas Island',
  'CC'=>'Cocos (Keeling) Islands',
  'CO'=>'Columbia',
  'KM'=>'Comoros',
  'CG'=>'Congo',
  'CK'=>'Cook Islands',
  'CR'=>'Costa Rica',
  'CI'=>'Cote D\'Ivorie (Ivory Coast)',
  'HR'=>'Croatia (Hrvatska)',
  'CU'=>'Cuba',
  'CY'=>'Cyprus',
  'CZ'=>'Czech Republic',
  'CD'=>'Democratic Republic Of Congo (Zaire)',
  'DK'=>'Denmark',
  'DJ'=>'Djibouti',
  'DM'=>'Dominica',
  'DO'=>'Dominican Republic',
  'TP'=>'East Timor',
  'EC'=>'Ecuador',
  'EG'=>'Egypt',
  'SV'=>'El Salvador',
  'GQ'=>'Equatorial Guinea',
  'ER'=>'Eritrea',
  'EE'=>'Estonia',
  'ET'=>'Ethiopia',
  'FK'=>'Falkland Islands (Malvinas)',
  'FO'=>'Faroe Islands',
  'FJ'=>'Fiji',
  'FI'=>'Finland',
  'FR'=>'France',
  'FX'=>'France, Metropolitan',
  'GF'=>'French Guinea',
  'PF'=>'French Polynesia',
  'TF'=>'French Southern Territories',
  'GA'=>'Gabon',
  'GM'=>'Gambia',
  'GE'=>'Georgia',
  'DE'=>'Germany',
  'GH'=>'Ghana',
  'GI'=>'Gibraltar',
  'GR'=>'Greece',
  'GL'=>'Greenland',
  'GD'=>'Grenada',
  'GP'=>'Guadeloupe',
  'GU'=>'Guam',
  'GT'=>'Guatemala',
  'GN'=>'Guinea',
  'GW'=>'Guinea-Bissau',
  'GY'=>'Guyana',
  'HT'=>'Haiti',
  'HM'=>'Heard And McDonald Islands',
  'HN'=>'Honduras',
  'HK'=>'Hong Kong',
  'HU'=>'Hungary',
  'IS'=>'Iceland',
  'IN'=>'India',
  'ID'=>'Indonesia',
  'IR'=>'Iran',
  'IQ'=>'Iraq',
  'IE'=>'Ireland',
  'IL'=>'Israel',
  'IT'=>'Italy',
  'JM'=>'Jamaica',
  'JP'=>'Japan',
  'JO'=>'Jordan',
  'KZ'=>'Kazakhstan',
  'KE'=>'Kenya',
  'KI'=>'Kiribati',
  'KW'=>'Kuwait',
  'KG'=>'Kyrgyzstan',
  'LA'=>'Laos',
  'LV'=>'Latvia',
  'LB'=>'Lebanon',
  'LS'=>'Lesotho',
  'LR'=>'Liberia',
  'LY'=>'Libya',
  'LI'=>'Liechtenstein',
  'LT'=>'Lithuania',
  'LU'=>'Luxembourg',
  'MO'=>'Macau',
  'MK'=>'Macedonia',
  'MG'=>'Madagascar',
  'MW'=>'Malawi',
  'MY'=>'Malaysia',
  'MV'=>'Maldives',
  'ML'=>'Mali',
  'MT'=>'Malta',
  'MH'=>'Marshall Islands',
  'MQ'=>'Martinique',
  'MR'=>'Mauritania',
  'MU'=>'Mauritius',
  'YT'=>'Mayotte',
  'MX'=>'Mexico',
  'FM'=>'Micronesia',
  'MD'=>'Moldova',
  'MC'=>'Monaco',
  'MN'=>'Mongolia',
  'MS'=>'Montserrat',
  'MA'=>'Morocco',
  'MZ'=>'Mozambique',
  'MM'=>'Myanmar (Burma)',
  'NA'=>'Namibia',
  'NR'=>'Nauru',
  'NP'=>'Nepal',
  'NL'=>'Netherlands',
  'AN'=>'Netherlands Antilles',
  'NC'=>'New Caledonia',
  'NZ'=>'New Zealand',
  'NI'=>'Nicaragua',
  'NE'=>'Niger',
  'NG'=>'Nigeria',
  'NU'=>'Niue',
  'NF'=>'Norfolk Island',
  'KP'=>'North Korea',
  'MP'=>'Northern Mariana Islands',
  'NO'=>'Norway',
  'OM'=>'Oman',
  'PK'=>'Pakistan',
  'PW'=>'Palau',
  'PA'=>'Panama',
  'PG'=>'Papua New Guinea',
  'PY'=>'Paraguay',
  'PE'=>'Peru',
  'PH'=>'Philippines',
  'PN'=>'Pitcairn',
  'PL'=>'Poland',
  'PT'=>'Portugal',
  'PR'=>'Puerto Rico',
  'QA'=>'Qatar',
  'RE'=>'Reunion',
  'RO'=>'Romania',
  'RU'=>'Russia',
  'RW'=>'Rwanda',
  'SH'=>'Saint Helena',
  'KN'=>'Saint Kitts And Nevis',
  'LC'=>'Saint Lucia',
  'PM'=>'Saint Pierre And Miquelon',
  'VC'=>'Saint Vincent And The Grenadines',
  'SM'=>'San Marino',
  'ST'=>'Sao Tome And Principe',
  'SA'=>'Saudi Arabia',
  'SN'=>'Senegal',
  'SC'=>'Seychelles',
  'SL'=>'Sierra Leone',
  'SG'=>'Singapore',
  'SK'=>'Slovak Republic',
  'SI'=>'Slovenia',
  'SB'=>'Solomon Islands',
  'SO'=>'Somalia',
  'ZA'=>'South Africa',
  'GS'=>'South Georgia And South Sandwich Islands',
  'KR'=>'South Korea',
  'ES'=>'Spain',
  'LK'=>'Sri Lanka',
  'SD'=>'Sudan',
  'SR'=>'Suriname',
  'SJ'=>'Svalbard And Jan Mayen',
  'SZ'=>'Swaziland',
  'SE'=>'Sweden',
  'CH'=>'Switzerland',
  'SY'=>'Syria',
  'TW'=>'Taiwan',
  'TJ'=>'Tajikistan',
  'TZ'=>'Tanzania',
  'TH'=>'Thailand',
  'TG'=>'Togo',
  'TK'=>'Tokelau',
  'TO'=>'Tonga',
  'TT'=>'Trinidad And Tobago',
  'TN'=>'Tunisia',
  'TR'=>'Turkey',
  'TM'=>'Turkmenistan',
  'TC'=>'Turks And Caicos Islands',
  'TV'=>'Tuvalu',
  'UG'=>'Uganda',
  'UA'=>'Ukraine',
  'AE'=>'United Arab Emirates',
  'UK'=>'United Kingdom',
  'US'=>'United States',
  'UM'=>'United States Minor Outlying Islands',
  'UY'=>'Uruguay',
  'UZ'=>'Uzbekistan',
  'VU'=>'Vanuatu',
  'VA'=>'Vatican City (Holy See)',
  'VE'=>'Venezuela',
  'VN'=>'Vietnam',
  'VG'=>'Virgin Islands (British)',
  'VI'=>'Virgin Islands (US)',
  'WF'=>'Wallis And Futuna Islands',
  'EH'=>'Western Sahara',
  'WS'=>'Western Samoa',
  'YE'=>'Yemen',
  'YU'=>'Yugoslavia',
  'ZM'=>'Zambia',
  'ZW'=>'Zimbabwe'
}.invert.sort

WHOLESALER_CREDIT_LIMIT = 2000
WHOLESALER_MINIMUM_PAYMENT = 1
DEFAULT_CURRENCY = 'USD'
DEFAULT_AFFILIATE_COMISSION_PERCENTAGE = 10
DEFAULT_AFFILIATE_COMISSION_PER_UNIT = 0.0
