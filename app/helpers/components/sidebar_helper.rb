module Components
  module SidebarHelper
    def sidebar_list_item(text, path, option = {}, &block)
      option[:active] ||= match_path(path, request.url) # request.path.include?(_path) && request.path.first(5) == _path.first(5)
      render 'layouts/components/sidebar/list-item', text: text, path: path, option: option, &block
    end

    def match_path(base, compare)
      base_uri = URI.parse(URI.encode(URI.decode_www_form_component(base).strip))
      compare_uri = URI.parse(compare)
      base_uri.path.present? && compare_uri.path.start_with?(base_uri.path)
    end
  end
end
