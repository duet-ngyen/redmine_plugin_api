class Api < ActiveRecord::Base
  unloadable

  validates :endpoint, presence: true
  validates :name, presence: true
  validates :description, presence: true
  validates :query, presence: true
  validates :endpoint, uniqueness: true

  enum status: {
    active: 0,
    inactive: 1
  }

  def get_params_from_query
    param_reg = /:[\w]+/m
    return self.query.scan(param_reg).each{|p|p[0] = ''}
  end

  def endpoint_url
    params_from_query = self.get_params_from_query

    params_in_url = "/public_apis_v2/#{self.endpoint}/[format]"
    params_count = params_from_query.count

    params_in_url += "?" if params_count > 0

    params_from_query.each.with_index do |p, index|
      join_character = (index > 0 && index < params_count) ? "&" : ""
      params_in_url += "#{join_character}#{p}=[val_#{index+1}]"
    end

    params_in_url
  end
end
