require 'erubis'

require 'telegram/controller/view_object'
require 'telegram/errors/renderer/bad_template_format_error'
require 'telegram/errors/renderer/double_render_error'
require 'telegram/errors/renderer/format_not_supported_error'
require 'telegram/errors/renderer/multiple_templates_error'
require 'telegram/errors/renderer/template_not_found_error'


module Telegram
  class Controller
    class Renderer

      def initialize(controller:, action:)
        @controller, @action = controller, action
      end


      def render opts = {}
        options = normalize_options(opts)
        view    = Controller::ViewObject.new(@controller.expose_instance_variables)
        template_file_name, response_format = resolve_template(options)

        template_body = File.read template_file_name
        template      = Erubis::Eruby.new(template_body)
        response_body = template.evaluate(view)

        [response_body, response_format]
      end


      private

      def normalize_options opts
        if opts.is_a? String
          opts = {template: opts}
        end
        default_render_options.merge(opts)
      end


      def default_render_options
        controller_name = @controller.class.to_s.underscore.gsub(/_controller$/,'')
        {
          template: "#{controller_name}/#{@action}"
        }
      end


      def resolve_template options
        view_name = options[:template]

        template_name  = File.join "app", "views", view_name
        template_files = Dir.glob "#{template_name}.*.erb"

        if template_files.length > 1 && options[:format].nil?
          raise Telegram::Errors::Renderer::MultipleTemplatesError, view_name
        end

        if template_files.length == 1
          template_file = template_files[0]
        else
          template_file = template_files.find do |t|
            template_file_format(t) == options[:format]
          end
        end

        if template_file
          template_format = template_file_format(template_file)
        end

        if !(template_file && template_format) || (options[:format] && template_format != options[:format])
          raise Telegram::Errors::Renderer::BadTemplateFormatError, view_name
        end

        unless template_file
          raise Telegram::Errors::Renderer::TemplateNotFoundError, view_name
        end

        [template_file, template_format]
      end


      def template_file_format name
        extension = name.split('.')[-2]
        template_format = extensions_map[extension] || extension
        unless extensions_map.values.include? template_format
          raise Telegram::Errors::Renderer::FormatNotSupportedError, template_format
        end
        template_format
      end


      def extensions_map
        {
          'txt'  =>  :text,
          'md'   =>  :markdown,
          'html' =>  :html,
        }
      end


      def template_extensions_whitelist
        extensions_map.keys
      end


    end # Renderer
  end # Controller
end #Telegram
