# frozen_string_literal: true

require "erb"

class BaseController
  def view(name, data: {}, layout: nil, code: 200, headers: {})
    template_path = File.expand_path("../views/#{name}.erb", __dir__)

    body = ERB.new(
      File.read(template_path, encoding: "UTF-8")
    ).result_with_hash(data)

    if layout
      layout_path = File.expand_path("../views/#{layout}.erb", __dir__)

      body = ERB.new(
        File.read(layout_path, encoding: "UTF-8")
      ).result_with_hash(data.merge(content: body))
    end

    headers = {
      "content-type" => "text/html; charset=utf-8"
    }.merge(headers)

    [code, headers, [body]]
  end

  def redirect(url)
    [303, { "location" => url }, []]
  end
end