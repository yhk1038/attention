module Components
  module PageHelper
    def page_heading(title, &block)
      render 'layouts/components/page/heading', title: title, &block
    end
  end
end
