# frozen_string_literal: true

require 'ollama-ai'
require 'pry'
require 'singleton'

class ProblemGeneratorAI
  include Singleton
  attr_reader :result

  def initialize
    @client = Ollama.new(
      credentials: { address: 'http://localhost:11434' },
      options: { server_sent_events: true }
    )
  end

  def generate_problem(category, _category_symbol, grade)
    result = @client.generate(
      { model: 'llama3.2',
        prompt: "generate a #{category} problem appropriate for #{ordinalize(grade)} grade that aligns with common core standards. only give me the problem and the answer in this format: { 'problem': ..., 'answer': ...}",
        # prompt: "generate a #{category} problem appropriate for #{ordinalize(grade)} grade that aligns with common core standards. only give me the problem, the standards they align with and the answer in this format: { 'problem': ..., 'answer': ..., 'standards': [...] }",
        options: {
          repeat_penalty: 1.5
        },
        format: 'json',
        stream: false }
    )
    formatted = formatted_result(result)
    Problem.new(problem_text: formatted['problem'], correct_answer: formatted['answer'].to_i,
                standards: formatted['standards'])
  end

  private

  def formatted_result(result)
    res = result[0]['response']
    res = res[res.index('{')..res.index('}')].gsub('\'', '"')
    JSON.parse(res)
  end

  def ordinalize(number)
    case number
    when 11, 12, 13 then "#{number}th"
    else
      case number % 10
      when 1 then "#{number}st"
      when 2 then "#{number}nd"
      when 3 then "#{number}rd"
      else "#{number}th"
      end
    end
  end
end
