module TasksHelper
  def flash_message(message_type)
    %Q(<p class="flash_#{message_type}"\>#{flash[message_type]}</p\>).html_safe
  end

  def delete_link_to(label, url, danger = false)
    if danger == true
      return (
        link_to label, 
        url, 
        class: "btn btn-danger",
        method: 'delete', 
        data: { confirm: I18n.t("are_you_sure") } 
      )
    else
      return (
        link_to label, 
        url,
        method: 'delete', 
        data: { confirm: I18n.t("are_you_sure") } 
      )
    end
  end

  def sort_link_to(label, url, param)
    if params[param] == "asc"
      return (
        link_to label,
        { controller: url, action: 'index', params: { param => 'desc' } },
        class: 'sort_link asc'
      )
    elsif params[param] == "desc"
      return (
        link_to label,
        { controller: url, action: 'index', params: { param => 'asc' } },
        class: 'sort_link desc'
      )
      
      # The following for page's default views
    else
      return (
        link_to label,
        { controller: url, action: 'index', params: { param => 'desc' } }
      )
    end
  end

  def tag_select_with_name_options
    options = Tag.all.pluck(:name, :name)
    return (
      select_tag :tag, 
      options_for_select(options),
      include_blank: true
    )
  end
end
