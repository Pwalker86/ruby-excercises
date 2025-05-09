# frozen_string_literal: true

require_relative 'xml_parser'

# CdtrAgtValidator class to validate Creditor Agent format
# This class validates XML against the format:
# <CdtrAgt>
#   <FinInstnId>
#     <ClrSysMmbId>
#       <Id>USABA123456789</Id>
#     </ClrSysMmbId>
#   </FinInstnId>
# </CdtrAgt>
class CdtrAgtValidator < ISO20022Validator
  def default_rules
    {
      'required_elements' => [
        'CdtrAgt',
        'CdtrAgt/FinInstnId',
        'CdtrAgt/FinInstnId/ClrSysMmbId',
        'CdtrAgt/FinInstnId/ClrSysMmbId/Id'
      ],
      'format_validations' => {
        'CdtrAgt/FinInstnId/ClrSysMmbId/Id' => {
          'pattern' => /^[A-Z]{5}[A-Z0-9]{2,}$/,
          'description' => 'Must be a valid clearing system identifier format'
        }
      }
    }
  end

  def validate
    result = super
    return false unless result

    validate_format_rules
    validate_us_aba_format
    @errors.empty?
  end

  private

  def validate_format_rules
    @rules['format_validations']&.each do |xpath, validation|
      element = @xml_doc.at_xpath("//#{xpath}")
      next unless element

      pattern = validation['pattern']
      next unless pattern

      # Convert string pattern from JSON to regex if needed
      pattern = pattern.is_a?(String) ? Regexp.new(pattern) : pattern

      unless element.text.strip.match?(pattern)
        @errors << "Format error for #{xpath}: #{validation['description'] || 'Invalid format'}"
      end
    end
  end

  # Validate the specific structure for US routing number format
  def validate_us_aba_format
    id_element = @xml_doc.at_xpath('//CdtrAgt/FinInstnId/ClrSysMmbId/Id')
    return unless id_element

    value = id_element.text.strip
    return unless value.start_with?('USABA')

    aba_number = value.gsub('USABA', '')

    # ABA routing numbers should be 9 digits
    return if aba_number.match?(/^\d{9}$/)

    @errors << "Invalid ABA routing number format: #{aba_number}. Must be 9 digits."

    # Add additional ABA validation if needed (checksum, etc.)
  end
end

# Execute this file directly if it's the main script
if __FILE__ == $PROGRAM_NAME
  rules = nil

  # Parse command line options
  OptionParser.new do |opts|
    opts.banner = 'Usage: ruby cdtr_agt_validator.rb [options] <path_to_xml_file>'

    opts.on('-r', '--rules=FILE', 'JSON file containing validation rules') do |file|
      if File.exist?(file)
        begin
          rules = JSON.parse(File.read(file))
          puts "Loaded rules from #{file}"
        rescue JSON::ParserError => e
          puts "Error parsing rules file: #{e.message}"
          exit 1
        end
      else
        puts "Error: Rules file '#{file}' not found"
        exit 1
      end
    end

    opts.on('-h', '--help', 'Show this help message') do
      puts opts
      exit
    end
  end.parse!

  if ARGV.empty?
    puts 'Missing XML file path. Use --help for usage details.'
    exit 1
  end

  xml_file = ARGV[0]

  unless File.exist?(xml_file)
    puts "Error: File '#{xml_file}' not found"
    exit 1
  end

  xml_content = File.read(xml_file)

  validator = CdtrAgtValidator.new(xml_content, rules)

  if validator.validate
    puts 'Creditor Agent validation successful! The file follows the required format.'
  else
    puts 'Creditor Agent validation failed with the following errors:'
    validator.errors.each_with_index do |error, index|
      puts "  #{index + 1}. #{error}"
    end
    exit 2
  end
end
