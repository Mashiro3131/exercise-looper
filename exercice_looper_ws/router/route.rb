class Route

  def initialize(path, method, controller, action)
    @path = path
    @method = method
    @controller = controller
    @action = action
  end

  def match?(request)
    method_match = @method == request.request_method
    path_match = @path === request.path_info
    method_match && path_match
  end

  def act(request)
    @controller.new(request).send(@action)
  end

end
