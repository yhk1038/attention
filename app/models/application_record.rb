class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def humanized_id
    '#' + [self.class::MODEL_INITIAL, id].join('-')
  end

  scope :find_or_first, ->(id) { where(id: id).first || first }
  scope :find_or_first_by, ->(query) { where(query).first || first }
end
