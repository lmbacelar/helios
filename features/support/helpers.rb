def current_path
  URI.parse(current_url).path
end

def klass_from resource
  resource.titleize.singularize.gsub(/\s+/,'').constantize
end

def table_name_from resource
  klass_from(resource).name.tableize
end

def last_id_from resource
  klass_from(resource).last.id
end

