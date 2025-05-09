# frozen_string_literal: true

# !/usr/bin/env ruby
# ISO 20022 XML Parser and Validator
# This program parses and validates XML against ISO 20022 format rules

require 'nokogiri'
require 'optparse'
require 'json'

# ISO20022Validator class to handle XML parsing and validation
class ISO20022Validator
  attr_reader :errors, :xml_doc, :rules

  def initialize(xml_content, rules = nil)
    @errors = []
    @rules = rules || default_rules

    begin
      @xml_doc = Nokogiri::XML(xml_content) { |config| config.strict }
      @xml_doc.errors.each do |error|
        @errors << "XML parsing error: #{error}"
      end
    rescue Nokogiri::XML::SyntaxError => e
      @errors << "Invalid XML: #{e.message}"
    end
  end

  def validate
    return false unless @errors.empty?

    validate_structure
    validate_content
    validate_custom_rules

    @errors.empty?
  end

  private

  def default_rules
    {
      'required_elements' => [
        'SvcLvl',
        'SvcLvl/Prtry',
        'CtgyPurp',
        'CtgyPurp/Cd'
      ],
      'expected_values' => {
        'SvcLvl/Prtry' => 'NURG',
        'CtgyPurp/Cd' => 'SUPP'
      }
    }
  end

  def validate_structure
    # Check for required elements based on rules
    @rules['required_elements']&.each do |element_path|
      validate_element_exists(element_path)
    end
  end

  def validate_content
    # Validate specific content values according to rules
    @rules['expected_values']&.each do |element_path, expected_value|
      validate_element_value(element_path, expected_value)
    end
  end

  def validate_custom_rules
    # Check if root element matches expected value
    if @rules['root_element']
      root_name = @xml_doc.root&.name
      unless root_name == @rules['root_element']
        @errors << "Root element is '#{root_name}' but expected '#{@rules['root_element']}'"
      end
    end

    # Check expected content of root element if specified
    return unless @rules['root_content']

    root_content = @xml_doc.root&.text&.strip
    return if root_content == @rules['root_content']

    @errors << "Root element content is '#{root_content}' but expected '#{@rules['root_content']}'"
  end

  def validate_element_exists(xpath)
    return if @xml_doc.at_xpath("//#{xpath}")

    @errors << "Required element missing: #{xpath}"
  end

  def validate_element_value(xpath, expected_value)
    element = @xml_doc.at_xpath("//#{xpath}")
    return unless element
    return if element.text.strip == expected_value

    @errors << "Invalid value for #{xpath}. Expected: '#{expected_value}', Found: '#{element.text.strip}'"
  end
end

# Main execution code starts here
if __FILE__ == $PROGRAM_NAME
  options = {}
  rules = nil
  
  # Parse command line options
  OptionParser.new do |opts|
    opts.banner = "Usage: ruby xml_parser.rb [options] <path_to_xml_file>"
    
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

    opts.on('-p', '--payment-method TAG=VALUE', 'Check specific payment method tag and value') do |tag_value|
      tag, value = tag_value.split('=', 2)
      options[:payment_method] = { tag: tag, value: value }
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

  # Apply payment method check if specified
  if options[:payment_method]
    tag = options[:payment_method][:tag]
    value = options[:payment_method][:value]

    rules ||= {}
    rules['required_elements'] ||= []
    rules['required_elements'] << tag
    rules['expected_values'] ||= {}
    rules['expected_values'][tag] = value

    puts "Validating that <#{tag}> contains '#{value}'"
  end

  validator = ISO20022Validator.new(xml_content, rules)

  if validator.validate
    puts 'XML validation successful! The file follows the ISO 20022 format rules.'
  else
    puts 'XML validation failed with the following errors:'
    validator.errors.each_with_index do |error, index|
      puts "  #{index + 1}. #{error}"
    end
    exit 2
  end
end

