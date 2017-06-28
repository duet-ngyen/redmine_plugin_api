module PublicApisHelper
  def get_condition_types_by_data_type(data_type)
    case data_type.to_s
    when "integer", "float"
      [
        {"equals" => "="},
        {"different" => "!="},
        {"less" => "<"},
        {"greater" => ">"},
        {"less_or_equal" => "<="},
        {"greater_or_equal" => ">="}
      ]
    else
      [
        {"contains" => "Contains"},
        {"equal" => "="},
        {"start_with" => "start_with"},
        {"from_date" => "From"},
        {"to_date" => "To"}
      ]
    end
  end

  def filters_options_for_select(query)
    ungrouped = []
    grouped = {}
    query.available_filters.map do |field, field_options|
      if [:tree, :relation].include?(field_options[:type])
        group = :label_relations
      elsif field =~ /^(.+)\./
        # association filters
        group = "field_#{$1}"
      elsif %w(member_of_group assigned_to_role).include?(field)
        group = :field_assigned_to
      elsif field_options[:type] == :date_past || field_options[:type] == :date
        group = :label_date
      end
      if group
        (grouped[group] ||= []) << [field_options[:name], field]
      else
        ungrouped << [field_options[:name], field]
      end
    end
    # Don't group dates if there's only one (eg. time entries filters)
    if grouped[:label_date].try(:size) == 1
      ungrouped << grouped.delete(:label_date).first
    end
    s = options_for_select([[]] + ungrouped)
    if grouped.present?
      localized_grouped = grouped.map {|k,v| [l(k), v]}
      s << grouped_options_for_select(localized_grouped)
    end
    s
  end
end
