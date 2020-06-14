module SettingPageHelper
  def setting_top_nav
    render 'layouts/components/page/setting_top_nav'
  end

  def setting_subside
    render 'layouts/components/page/setting_subside'
  end

  def setting_list_group_section(title, option = {}, &block)
    render 'layouts/components/page/setting_list_group_section', title: title, option: option, &block
  end

  def setting_list_item(option = {})
    render 'layouts/components/page/setting_list_item', option: option
  end
end
