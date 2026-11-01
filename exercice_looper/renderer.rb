def view(name, data: {}, layout: 'layout', code: 200, headers: {})
  template_path = File.join(__dir__, "views", "#{name}.erb")
  body = ERB.new(File.read(template_path)).result_with_hash(data)

  if layout
    layout_path = File.join(__dir__, 'views', "#{layout}.html.erb")
    body = ERB.new(File.read(layout_path)).result_with_hash(data.merge(content: body))
  end

  [code, headers, [body]]
end

def file(pathname, code: 200, headers: {})
  [code, headers, [File.read(pathname)]]
end

def redirect(url, code: 303)
  [code, { "location" => url }, []]
end
