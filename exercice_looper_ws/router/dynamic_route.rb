# frozen_string_literal: true
require_relative 'route'

class DynamicRoute < Route
  def match?(request)
    return false unless request.request_method.upcase == @method

    route_parts = @path.split("/")
    request_parts = request.path.split("/")

    puts "[ROUTE]:  #{route_parts}"
    puts "[REQUEST]:  #{request_parts}"

    return false unless route_parts.length == request_parts.length

    route_parts.each_with_index do |route_part, index|
      request_part = request_parts[index]

      if route_part.start_with?(":")
        return false if request_part.empty?
      elsif route_part != request_part
        return false
      end
    end

    true
  end
end

