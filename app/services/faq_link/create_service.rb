module FaqLinkModule
  class CreateService
    def initialize(params)
      # TODO: identify origin and set company
      @company = Company.last
      @question = params["question-original"]
      @answer = params["answer-original"]
      @hashtags = params["hashtags-original"]
      @faq_links_type = params["faq_links_type-original"]
    end

    def call
      if @hashtags == nil || @hashtags == ""
        return 'Hashtag Obrigatória'
      elsif @faq_links_type == nil || @faq_links_type == ""
        return 'Algo aconteceu com o tipo do registro. :('
      else
        begin
          FaqLink.transaction do
            faq = FaqLink.create(question: @question, answer: @answer, company: @company, faq_links_type: @faq_links_type.to_i)
            @hashtags.split(/[\s,]+/).each do |hashtag|
              faq.hashtags << Hashtag.create(name: hashtag, company: @company)
            end
            faq.save!
          end
          'Criado com sucesso'
        rescue
          'Problemas na criação'
        end
      end
    end
  end
end
