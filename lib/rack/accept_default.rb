module Rack
  class AcceptDefault
    def initialize(app, default='*/*')
      @app = app
      @default = default
    end

    def call(env)
      env['HTTP_ACCEPT'] = nil if env['HTTP_ACCEPT'] == "*/*" && env['HTTP_USER_AGENT'] =~ /google-api-ruby-client/
      env['HTTP_ACCEPT'] ||= @default
      @app.call(env)
    end
  end
end
