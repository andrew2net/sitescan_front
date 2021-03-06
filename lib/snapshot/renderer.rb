module Snapshot
  class Renderer
    BOTS = [
      'baiduspider',
      'facebookexternalhit',
      'facebot',
      'twitterbot',
      'rogerbot',
      'linkedinbot',
      'embedly',
      'bufferbot',
      'quora link preview',
      'showyoubot',
      'outbrain',
      'pinterest',
      'developers.google.com/+/web/snippet',
      'googlebot',
      'slackbot',
      'yandexbot'
    ]

    def initialize(app)
      @app = app
    end

    def call(env)
      fragment = parse_fragment(env)

      if fragment
        render_fragment(env, fragment)
      elsif bot_request?(env) && page_request?(env)
        Rails.logger.info "Its a bot"
        fragment = { path: env['REQUEST_PATH'], query: env['QUERY_STRING'] }
        render_fragment(env, fragment)
      else
        Rails.logger.info "It is not a bot"
        @app.call(env)
      end
    end

    private

    def parse_fragment(env)
      # regexp = /(?:&?_escaped_fragment_=)([^&]*&?)/
      query = Rack::Utils.parse_nested_query(env['QUERY_STRING'])
      match = query.delete '_escaped_fragment_'
      # match = regexp.match(query)

      # Interpret _escaped_fragment_ and figure out which page needs to be rendered
      # { path: URI.unescape(match[1]), query: query.sub(regexp, '') } if match
      {
        path: URI.unescape(env['REQUEST_PATH']),
        query: query.map{|k,v| "#{k}=#{v}"}.join('&')
      } if match
    end

    def render_fragment(env, fragment)
      url = "#{env['rack.url_scheme']}://#{env['HTTP_HOST']}#{fragment[:path]}"
      url += '?bot'
      url += "&#{ fragment[:query] }" if fragment[:query].present?

      # Run PhantomJS
      body = Rails.cache.fetch fragment, expires_in: 1.day do
        # Tempfile.open 'page' do |temp|
          # if Rails.env == 'development'
            # %x{phantomjs lib/snapshot/phantom-script.js #{ url }}
          resp = %x{phantomjs lib/snapshot/phantom-script.js '#{url}'}
          # else
          #   %x{aws lambda invoke --function-name seo-renderer --payload '{"page_url": "#{url}"}' #{temp.path}}
          # end
          # resp = temp.read #.gsub(/\\"/, '"').gsub(/\\n/, '')
          # temp.close
          # temp.unlink
          doc = Nokogiri::HTML resp
          if (ttl = doc.xpath('//title').first)
            Rails.logger.info "Render title: #{ttl.children.first.to_s}"
          else
            Rails.logger.info 'Render title error: not found.'
          end
          resp
        # end
      end

      # Output pre-rendered response
      status, headers = @app.call(env)
      response = Rack::Response.new(body, status, headers)
      response.finish
    end

    def bot_request?(env)
      user_agent = env['HTTP_USER_AGENT']
      buffer_agent = env['X-BUFFERBOT']

      Rails.logger.info "User agent: #{buffer_agent || user_agent}"

      buffer_agent || (user_agent && BOTS.any? { |bot| user_agent.downcase.include? bot })
    end

    def page_request?(env)
      method = env['REQUEST_METHOD'] || 'GET'
      accept = env['HTTP_ACCEPT']
      path = env['REQUEST_PATH']

      # Rails.logger.info "Method: #{method} Accept: #{accept} Path: #{path}"

      # Only return true if it is a GET request, accepting text/html response
      # not hitting API endpoint, and not requesting static asset
      method.upcase == 'GET' &&
      accept =~ /(text\/html|\*\/\*)/ &&
      !(path =~ /^\/(?:assets|api)/) &&
      !(path =~ /\.[a-z0-9]{2,4}$/i)
    end
  end
end
