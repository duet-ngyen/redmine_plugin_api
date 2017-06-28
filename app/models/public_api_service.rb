class PublicApiService
  def self.available_filters(class_name)
    available_filters = {}



    types = {
      list: ["is_private", "watcher_id", "is_public", "admin"],
      list_optional: ["member_of_group", "assigned_to_role"],
      list_status: ["status_id"],
      list_subprojects: ["subproject_id"],
      date: ["start_date", "due_date"],
      date_past: ["created_on", "updated_on", "closed_on"],
      string: ["name", "identifier", "login", "firstname", "lastname"],
      text: ["subject", "description"],
      relation: [],
      integer: ["project_id", "tracker_id",
                "priority_id", "author_id", "assigned_to_id",
                "category_id", "fixed_version_id", "issue_id",
                "default_version_id", "default_assigned_to_id",
                "auth_source_id"],
      float: ["estimated_hours"],
      tree: ["done_ratio", "parent_id", "child_id"]
    }

    class_name.classify.constantize.column_names.each do |column_name|
      filter_type = types.find{|k,v|v.include?(column_name)}
      if filter_type.present?
        available_filters[column_name.to_s] = {name: column_name, type: filter_type[0], values: ["thuc"]}
      end
    end
    available_filters
  end
end
