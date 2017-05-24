module FaqLinkModule
  class RemoveService
    def initialize(params)
      # TODO: identify origin and set company
      @company = Company.last
      @params = params
      @id = params["id"]
    end

    def call
      begin
        faq = @company.faq_links.find(@id)
      rescue
        return "Questão inválida, verifique o Id"
      end

      FaqLink.transaction do
        # Deleta as tags associadas que não estejam associadas a outros faqs
        faq.hashtags.each do |h|
          if h.faq_links.count <= 1
            h.delete
          end
        end
        faq.delete
        "Deletado com sucesso"
      end
    end
  end
end
