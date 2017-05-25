module FaqLinkModule
  class ListService
    def initialize(params, action)
      # TODO: identify origin and set company
      @company = Company.last
      @action = action
      @faq_links_type = params["faq_links_type-original"]
      @query = params["query"]
    end

    def call
      if @action == "search"
        faqs = FaqLink.search(@query).where(company: @company, faq_links_type: @faq_links_type)
      elsif @action == "search_by_hashtag"
        faqs = []
        @company.faq_links.each do |faq|
          faq.hashtags.each do |hashtag|
            faqs << faq if hashtag.name == @query
          end
        end
      else
        faqs = @company.faq_links.where(company: @company, faq_links_type: @faq_links_type )
      end

      if @faq_links_type == 0 || @faq_links_type == 1
        response = "*Perguntas e Respostas* \n\n"
        faqs.each do |f|
          response += "*#{f.id}* - "
          response += "*#{f.question}*\n"
          response += ">#{f.answer}\n"
          f.hashtags.each do |h|
            response += "_##{h.name}_ "
          end
          response += "\n\n"
        end
        (faqs.count > 0)? response : "Nada encontrado"
      else
        'Parâmetros do tipo associado está errado.'
      end


    end
  end
end
