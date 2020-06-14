module Components
  module SidebarHelper
    def sidebar_list_item(text, path, option = {}, &block)
      _path = URI.encode(URI.decode_www_form_component(path).strip)
      option[:active] ||= request.path.include?(_path) && request.path.first(5) == _path.first(5)
      render 'layouts/components/sidebar/list-item', text: text, path: path, option: option, &block
    end
  end
end
