class KaijuFileSystemRoot < DirectoryBase
  def projects
    ProjectList.new(path("project.json"))
  end

  def create_project(name, item_id_prefix)
    project_list = projects
    if !project_list.include?(name)
      project_list.edit_data do |l|
        l << name
      end
    end
  end
end