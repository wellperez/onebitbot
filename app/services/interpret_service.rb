class InterpretService
  def self.call action, params
    case action
    when "list", "search", "search_by_hashtag"
      FaqLinkModule::ListService.new(params, action).call()
    when "create"
      FaqLinkModule::CreateService.new(params).call()
    when "remove"
      FaqLinkModule::RemoveService.new(params).call()
    when "help"
      HelpService.call()
    else
      "Não compreendi o seu desejo"
    end
  end
end
