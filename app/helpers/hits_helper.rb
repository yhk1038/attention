module HitsHelper
  def bar_chart_format(category_name, group_by_query_result_hash)
    d = group_by_query_result_hash

    {
      categories: d.keys,
      series: [
        {
          name: category_name,
          data: d.values
        }
      ]
    }
  end
end
